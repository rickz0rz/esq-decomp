#!/usr/bin/env python3
"""Speak ESQ's RBF serial protocol, so a build can be driven the way the head
end drives it.

    python3 tools/rbf.py --show                    # print the frames, send nothing
    python3 tools/rbf.py --serve --delay 95        # wait for fs-uae, then send

WHY THIS EXISTS

Every screen harness judges a build by what is on screen, and fileio_esq.sh
judges what it writes to disk. That one found nothing, and the reason is
structural: ESQ is a BROADCAST RECEIVER. Its file writes are gated behind
pending flags that only the listing data path sets, and that path is fed by the
serial line, not the keyboard.

    DISKIO2_FlushDataFilesIfNeeded
        -> if (CTASKS_PrimaryOiWritePendingFlag) COI_WriteOiDataFile(...)

    DISKIO_SaveConfigToFileHandle
        <- ESQPARS_ConsumeRbfByteAndDispatchCommand   (the 'f' command)

So no key sequence can reach the write path. This sends the bytes that can.

THE WIRE FORMAT, READ OUT OF THE DISPATCHER

Every frame opens with the two-byte preamble, then one command letter:

    0x55 0xAA <cmd> ...

`ESQPARS_ConsumeRbfByteAndDispatchCommand` runs that as a state machine: 0x55
arms the "seen" flag, 0xAA with "seen" set arms the command flag, and anything
else clears both. Until a selection code matches, ONLY 'A', 'W' and 'w' are
accepted. After it matches, the full 30-command table opens.

SELECT -- 'A' (65)

    0x55 0xAA 'A' <code bytes> 0x00 <checksum>

`ESQIFF2_ReadSerialRecordIntoBuffer(buf, 0, 0)` reads until a zero byte, which
terminates the record and is not counted, then reads one checksum byte. The
code must be 16 bytes or fewer.

    checksum = ('A' ^ 0xFF) ^ XOR(code bytes)

CONFIG WRITE -- 'f' (102)

    0x55 0xAA 'f' <sub> <lenHi> <lenLo> <data> <checksum>

    seed     = 'f' ^ sub ^ lenHi ^ lenLo
    lenword  = len(data) + 1        (the dispatcher subtracts one)
    checksum = (seed ^ 0xFF) ^ XOR(data)

`sub` is read into the seed and never used again, so its value is free. This
command calls `DISKIO_ParseConfigBuffer` and then
`DISKIO_SaveConfigToFileHandle`, which is a real write to `df0:config.dat`.

THE CHECKSUM IS NOT A SUM. `ESQ_GenerateXorChecksumByte(seed, data, count)`
starts at `seed ^ 0xFF` and XORs `count` bytes. The loop is a do-while over
`n = count - 1`, so it covers data[0] through data[count-1] -- exactly `count`
bytes, not one more.

THE SELECT CODE IS THE COMMAND-LINE ARGUMENT. `ESQ_StartupEntry` does
`strcpy(ESQ_SelectCodeBuffer, argv[1])`, and the emulated drive launches it from
`S/uv-startup` as `esq GA24005`. `ESQ_WildcardMatch` returns 0 on a match and
the buffer holds no wildcard, so the address sent must be that string exactly.
Read `S/uv-startup` rather than trusting this default.

FS-UAE CARRIES THE LINE OVER TCP. The config already says
`serial_port = tcp://127.0.0.1:1234`, so no pty is needed. Which side listens is
not documented the same way in every version, so `--serve` tries to listen and
falls back to connecting.
"""
import argparse
import os
import socket
import sys
import time

# The address the emulated drive launches ESQ with, in S/uv-startup.
DEFAULT_SELECT = 'GA24005'

PREAMBLE = bytes([0x55, 0xAA])


def xor_all(data):
    acc = 0
    for b in data:
        acc ^= b
    return acc & 0xFF


def frame_select(code):
    """'A' -- match a selection code and open the full command table."""
    body = code.encode('ascii')
    if len(body) > 16:
        raise ValueError('a selection code over 16 bytes is rejected by the '
                         'dispatcher as a line error')
    checksum = (ord('A') ^ 0xFF) ^ xor_all(body)
    return PREAMBLE + b'A' + body + b'\x00' + bytes([checksum & 0xFF])


def frame_config(data, sub=0):
    """'f' -- parse a configuration record and WRITE it to df0:config.dat."""
    if len(data) + 1 >= 0x2328:
        raise ValueError('a record of 0x2328 or more is rejected as a line error')
    lenword = len(data) + 1
    hi, lo = (lenword >> 8) & 0xFF, lenword & 0xFF
    seed = (ord('f') ^ sub ^ hi ^ lo) & 0xFF
    checksum = (seed ^ 0xFF) ^ xor_all(data)
    return (PREAMBLE + b'f' + bytes([sub, hi, lo]) + data
            + bytes([checksum & 0xFF]))


def build(select_code, config_path):
    """The frames to send, in order: select first, then the write."""
    frames = [('select %s' % select_code, frame_select(select_code))]
    if config_path:
        with open(config_path, 'rb') as fh:
            data = fh.read()
        frames.append(('config %d bytes' % len(data), frame_config(data)))
    return frames


def hexdump(label, frame):
    print('  %-22s %3d bytes  %s' % (label, len(frame), frame.hex()))


def open_line(host, port, timeout):
    """Get a socket to the emulator.

    CONNECT, because FS-UAE is the one that LISTENS. Its own log says so:

        TCP: Listen 127.0.0.1:1234
        TCP: bind() failed, 127.0.0.1:1234: 48
        SERIAL: Could not open device tcp://127.0.0.1:1234

    Error 48 is EADDRINUSE. An earlier version of this function bound the port
    first, which stopped the emulator opening its own serial device at all --
    so the run reported no link and, worse, would have reported a healthy
    machine that simply had no serial port. START THE EMULATOR FIRST AND DO NOT
    BIND THIS PORT.

    Listening is kept only as a fallback for a version that connects outward.
    """
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            conn = socket.create_connection((host, port), timeout=5)
            print('  connected to %s:%d' % (host, port))
            return conn
        except OSError:
            time.sleep(1)

    print('  no listener on %s:%d after %ds, trying to listen instead'
          % (host, port, timeout))
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        srv.bind((host, port))
        srv.listen(1)
        srv.settimeout(timeout)
        conn, peer = srv.accept()
        print('  emulator connected from %s:%d' % peer)
        srv.close()
        return conn
    except OSError as exc:
        srv.close()
        print('  cannot listen either (%s)' % exc)
    return None


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--select', default=DEFAULT_SELECT,
                    help='selection code to address (default %s)' % DEFAULT_SELECT)
    ap.add_argument('--config', default=None,
                    help="file whose bytes to send as the 'f' record")
    ap.add_argument('--show', action='store_true',
                    help='print the frames and send nothing')
    ap.add_argument('--serve', action='store_true',
                    help='open the line and send the frames')
    ap.add_argument('--host', default='127.0.0.1')
    ap.add_argument('--port', type=int, default=1234)
    ap.add_argument('--delay', type=float, default=95.0,
                    help='seconds to wait after the link is up, so ESQ is '
                         'running before the first byte (default 95)')
    ap.add_argument('--gap', type=float, default=3.0,
                    help='seconds between frames')
    ap.add_argument('--hold', type=float, default=30.0,
                    help='seconds to hold the line open after the last frame, '
                         'so the write completes before the run ends')
    args = ap.parse_args()

    frames = build(args.select, args.config)

    print('RBF frames:')
    for label, frame in frames:
        hexdump(label, frame)

    if args.show or not args.serve:
        return 0

    conn = open_line(args.host, args.port, timeout=60)
    if conn is None:
        print('  NO LINE. Nothing was sent, so this run proves nothing.')
        return 2

    try:
        print('  waiting %.0fs for ESQ to come up' % args.delay)
        time.sleep(args.delay)
        for label, frame in frames:
            conn.sendall(frame)
            print('  sent %s' % label)
            time.sleep(args.gap)
        print('  holding the line %.0fs' % args.hold)
        time.sleep(args.hold)
    finally:
        conn.close()
    return 0


if __name__ == '__main__':
    sys.exit(main())
