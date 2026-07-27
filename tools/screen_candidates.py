#!/usr/bin/env python3
"""Rank restoration candidates by whether a byte-exact match is even possible.

    python3 tools/screen_candidates.py [candidates.py args...]

Three divergence classes are known to be unreachable with SAS/C 6.51 and a
one-function-per-file layout, and each has a signature visible in the reference
bytes. Screening on those turns a blind list into a ranked one, so compile time
goes to functions that can actually match.

  4E55            LINK.W A5 -- the original reserves A5 as a frame pointer and
                  6.51 does not, so any function with a stack frame diverges.
  4EBA            JSR (d16,PC) -- the original's encoding for a call whose callee
                  was in another translation unit. We emit BSR.W (6100) for every
                  call, because every call from a one-function file is external.
  A3 in a save    MOVE.L A3,-(A7) (2F0B) or a MOVEM mask with bit 11 set: an
                  address register variable, which 6.51 puts in A5.

See docs/compiler-version.md. A candidate with none of these is not guaranteed
to match, but one with them is guaranteed not to.
"""
import re, subprocess, sys, os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def movem_regs(word):
    """Register list of a MOVEM.L <list>,-(A7) predecrement mask."""
    # predecrement order is A7..A0,D7..D0 from bit 0
    names = [f'A{7-i}' for i in range(8)] + [f'D{7-i}' for i in range(8)]
    return {names[i] for i in range(16) if word & (1 << i)}


def blockers(hexb):
    b = bytes.fromhex(hexb)
    out = []
    if b'\x4e\x55' in b:
        out.append('A5-frame')
    if b'\x4e\xba' in b:
        out.append('cross-unit-call')
    if b[:2] == b'\x2f\x0b':
        out.append('A3-regvar')
    elif b[:2] == b'\x48\xe7' and len(b) >= 4:
        if 'A3' in movem_regs(int.from_bytes(b[2:4], 'big')):
            out.append('A3-regvar')
    return out


def main():
    args = sys.argv[1:] or ['--allow-calls', '--allow-link',
                            '--max-instr', '40', '--limit', '900']
    r = subprocess.run(['python3', os.path.join(ROOT, 'tools', 'candidates.py')] + args,
                       capture_output=True, text=True, cwd=ROOT)
    cur = None
    rows = []
    for line in r.stdout.split('\n'):
        m = re.match(r'^=== (\S+)\s+\[(\S+)\]\s+(\d+) bytes', line)
        if m:
            cur = (m.group(1), m.group(2), int(m.group(3)))
        m = re.match(r'^\s+BYTES: ([0-9a-f]+)', line)
        if m and cur:
            rows.append((cur[0], cur[1], cur[2], blockers(m.group(1))))
            cur = None

    clean = [r for r in rows if not r[3]]
    blocked = [r for r in rows if r[3]]
    print(f'{len(rows)} candidates: {len(clean)} with no known blocker, '
          f'{len(blocked)} blocked\n')
    print('=== reachable (no known blocker) ===')
    for name, src, n, _ in sorted(clean, key=lambda x: x[2]):
        print(f'  {n:5d}  {name:52s} {src}')
    tally = {}
    for _, _, _, bl in blocked:
        for x in bl:
            tally[x] = tally.get(x, 0) + 1
    print('\n=== blocked, by cause ===')
    for k, v in sorted(tally.items(), key=lambda kv: -kv[1]):
        print(f'  {v:5d}  {k}')


if __name__ == '__main__':
    main()
