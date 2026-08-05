#!/usr/bin/env python3
"""Replay a PrevueCommander byte stream, so two builds get IDENTICAL input.

    python3 tools/rbf_replay.py <commander.log> [--delay 95] [--host 127.0.0.1]

WHY THIS EXISTS

PrevueCommander pulls its line-up and programmes from a Channels DVR server at
run time, and THE ANSWER IS NOT THE SAME TWICE. Two runs half an hour apart
returned different channel sets and different numbers of programme records:

    control  5 channels starting [WJBK]     15 programme frames
    max-C    5 channels starting [WJBKDT4]  14 programme frames

So a control run and a candidate run are NOT COMPARABLE, and diffing what they
each wrote to curday.dat measures the DVR as much as the build. That cost a
long detour: the maximum-C build appeared to invent a channel "2.5" and to
reorder the line-up, and both were real -- the commander had genuinely sent
2.4, 2.5, 2, 2.1, 2.2 that run. The channel path was never broken.

This replays a byte stream captured from one commander run, so both builds see
the same frames in the same order. It reads the hex that
`output: Verbose` prints after each command name.

USE A CAPTURED LOG, NOT A LIVE COMMANDER, FOR ANY A/B COMPARISON.
"""
import re, socket, sys, time

FRAME = re.compile(r'\]\s+((?:[0-9A-Fa-f]{2}\s+)+[0-9A-Fa-f]{2})\s*$')


def frames(path):
    out = []
    for line in open(path, errors='replace'):
        m = FRAME.search(line.rstrip())
        if m:
            out.append(bytes(int(b, 16) for b in m.group(1).split()))
    return out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    log = sys.argv[1]
    delay = 95.0
    host = '127.0.0.1'
    port = 1234
    for i, a in enumerate(sys.argv):
        if a == '--delay':
            delay = float(sys.argv[i + 1])
        elif a == '--host':
            host = sys.argv[i + 1]
        elif a == '--port':
            port = int(sys.argv[i + 1])

    fr = frames(log)
    total = sum(len(f) for f in fr)
    print('replay: %d frame(s), %d byte(s) from %s' % (len(fr), total, log))
    if not fr:
        print('NO FRAMES PARSED -- the log must come from `output: Verbose`')
        return 2

    print('waiting %.0fs for the box to boot' % delay)
    time.sleep(delay)

    # FS-UAE LISTENS on the serial port, so this side connects. Retry: the
    # emulator can still be opening the device when the delay expires.
    s = None
    for attempt in range(30):
        try:
            s = socket.create_connection((host, port), timeout=5)
            break
        except OSError:
            time.sleep(1)
    if s is None:
        print('could not connect to %s:%d -- is fs-uae running?' % (host, port))
        return 2
    print('connected')

    # Pace the stream. The link is 2400 baud, which is 240 bytes a second, and
    # blasting the whole capture at once puts it in a socket buffer the box
    # cannot drain. Send at roughly wire speed so the receiver sees the same
    # arrival pattern the commander produced.
    for i, f in enumerate(fr):
        s.sendall(f)
        time.sleep(max(0.05, len(f) / 240.0))
        if (i + 1) % 10 == 0:
            print('  sent %d/%d' % (i + 1, len(fr)))
    print('sent all %d frame(s)' % len(fr))
    s.close()
    return 0


if __name__ == '__main__':
    sys.exit(main())
