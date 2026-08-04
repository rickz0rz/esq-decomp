#!/usr/bin/env python3
"""Compare what two builds wrote to the emulated drive.

    tools/fileio_esq.sh <pure-build>   pure
    tools/fileio_esq.sh <candidate>    cand
    python3 tools/fileiodiff.py pure cand

Exits nonzero when the two builds disagree about the FILE SET or, after
normalising, about the CONTENT of a file. That is the acceptance test the screen
harnesses cannot provide for the SAS/C stdio layer.

WHY NORMALISE

ESQ stamps most of what it writes with the clock, so two runs a minute apart
differ by construction and a raw byte diff is useless. Anything that looks like
a time, a date or a long run of digits is masked before comparing. What survives
is the part a stdio defect would corrupt: the line structure, the LINE ENDINGS,
the field layout and the length.

Masking is deliberately blunt. A stdio bug that changed only a digit would be
hidden -- but a stdio bug that changed only a digit is not what these functions
can do. STREAM_BufferedPutcOrFlush handles buffering, flushing, CRLF translation
and the Ctrl-Z end-of-file marker; when it is wrong, whole bytes are dropped,
doubled or written in the wrong order.

WHAT COUNTS AS A DIFFERENCE

  file set      one build wrote a file the other did not
  size          same file, different length after normalising
  content       same length, different normalised bytes
  line endings  reported separately, because CRLF versus LF is the single most
                likely stdio defect and it is worth naming rather than burying
                in a byte offset
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Volatile: clock stamps and anything else that moves between two runs.
VOLATILE = [
    (re.compile(rb'\d{1,2}:\d{2}:\d{2}'), b'HH:MM:SS'),
    (re.compile(rb'\d{1,2}:\d{2}'), b'HH:MM'),
    (re.compile(rb'\d{1,2}/\d{1,2}/\d{2,4}'), b'DD/MM/YYYY'),
    (re.compile(rb'\d{4,}'), b'NNNN'),
]


def normalise(data):
    out = data
    for pat, rep in VOLATILE:
        out = pat.sub(rep, out)
    return out


def line_endings(data):
    crlf = data.count(b'\r\n')
    lf = data.count(b'\n') - crlf
    cr = data.count(b'\r') - crlf
    return crlf, lf, cr


def collect(label):
    base = os.path.join('/tmp', 'esqio_' + label, 'files')
    if not os.path.isdir(base):
        sys.exit('no capture for %r -- run tools/fileio_esq.sh <binary> %s first'
                 % (label, label))
    out = {}
    for root, _, files in os.walk(base):
        for f in files:
            p = os.path.join(root, f)
            out[os.path.relpath(p, base)] = open(p, 'rb').read()
    return out


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    a_label, b_label = sys.argv[1], sys.argv[2]
    a, b = collect(a_label), collect(b_label)

    print(f'{a_label}: {len(a)} file(s)    {b_label}: {len(b)} file(s)')

    problems = 0

    only_a = sorted(set(a) - set(b))
    only_b = sorted(set(b) - set(a))
    for f in only_a:
        print(f'  ONLY IN {a_label}: {f} ({len(a[f])} bytes)')
        problems += 1
    for f in only_b:
        print(f'  ONLY IN {b_label}: {f} ({len(b[f])} bytes)')
        problems += 1

    for f in sorted(set(a) & set(b)):
        na, nb = normalise(a[f]), normalise(b[f])
        ea, eb = line_endings(a[f]), line_endings(b[f])

        if ea != eb:
            print(f'  LINE ENDINGS DIFFER: {f}')
            print(f'      {a_label}: CRLF={ea[0]} LF={ea[1]} CR={ea[2]}')
            print(f'      {b_label}: CRLF={eb[0]} LF={eb[1]} CR={eb[2]}')
            problems += 1
            continue

        if len(na) != len(nb):
            print(f'  SIZE DIFFERS: {f}  {a_label}={len(na)} {b_label}={len(nb)}'
                  f'  (normalised)')
            problems += 1
            continue

        if na != nb:
            off = next(i for i in range(len(na)) if na[i] != nb[i])
            lo = max(0, off - 16)
            print(f'  CONTENT DIFFERS: {f}  first at byte {off}')
            print(f'      {a_label}: {na[lo:off+16]!r}')
            print(f'      {b_label}: {nb[lo:off+16]!r}')
            problems += 1

    if not a and not b:
        print('\nNEITHER BUILD WROTE ANYTHING.')
        print('That is not a pass. It means the run never reached the write')
        print('path, so this comparison proves nothing about the stdio layer.')
        print('Drive a write before trusting a clean result here.')
        return 2

    if problems == 0:
        print(f'\nIDENTICAL after normalising: {len(a)} file(s) agree.')
        return 0

    print(f'\n{problems} difference(s).')
    return 1


if __name__ == '__main__':
    sys.exit(main())
