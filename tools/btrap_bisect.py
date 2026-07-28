#!/usr/bin/env python3
"""Removal-bisect the ESC-menu fault down to a single C restoration.

    python3 tools/btrap_bisect.py <first> <last>     # indices into the manifest
    python3 tools/btrap_bisect.py --list <file>      # explicit candidate list
    python3 tools/btrap_bisect.py --fixed <f> --list <g>   # always exclude <f> too

WHEN THERE ARE TWO CULPRITS, a plain bisect stalls: removing either half leaves
the other half's bug in place, so both halves "FAIL" and the script correctly
refuses to pick one. --fixed breaks that deadlock. Remove half B permanently
(the baseline still fails, which proves half A also contains a culprit), then
bisect half A against that baseline. Repeat with the halves swapped to find the
other. This is what the ED_* window needed.

Drives tools/btrap_test.sh, which is the deterministic oracle: it reports a
B-Trap from the emulator log AND a guru from the screen, so a build that swaps
one failure mode for the other is not mistaken for a fix.

WHY REMOVAL AND NOT "KEEP A SUBSET"

Both directions are valid logically; they are not equivalent in practice. A
kept-subset build is SMALL, and this fault is layout-sensitive -- the trap
address and even the opcode move as the image shifts (FFF8@2248F6, FFEC@224932,
FFF8@224524 across three builds). Shrinking the image can therefore stop the
fault firing for reasons that have nothing to do with the entry under test,
which produces a false acquittal. Removing a window from the FULL manifest keeps
the image close to the failing one, so a clean verdict is much more likely to
mean what it says. Same reasoning as tools/bisect_remove.sh.

Invariant: `remove(window)` clean => the culprit is inside `window`.
           `remove(window)` fails => the culprit is outside it (or interacts).

If BOTH halves of a window fail when removed, a single culprit cannot explain
it -- that is the interaction signature, and the script says so rather than
picking a half. Do not paper over it; switch to tools/ddmin_guru.py, which tests
complements and refines granularity.
"""
import subprocess
import sys
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MANIFEST = os.path.join(ROOT, 'src/c/replacements-all.txt')


def entries():
    return [l.split()[1] for l in open(MANIFEST)
            if l.strip() and not l.startswith('#')]


FIXED = []          # always-excluded baseline; see --fixed


def test(label, exclude):
    """True = FAILS (fault present). False = clean. None = inconclusive."""
    ex = f'/tmp/btrap_ex_{label}.txt'
    with open(ex, 'w') as f:
        f.write('\n'.join(exclude) + '\n')
    r = subprocess.run(['bash', os.path.join(ROOT, 'tools/btrap_test.sh'), label]
                       + FIXED + exclude,
                       capture_output=True, text=True, cwd=ROOT)
    tail = [l for l in r.stdout.splitlines() if 'VERDICT' in l or 'LINK' in l or 'WRONG' in l]
    msg = tail[-1].strip() if tail else r.stdout.strip()[-120:]
    if r.returncode == 2:
        print(f'    [{label}] INCONCLUSIVE (link) -- {msg}')
        return None
    fails = r.returncode in (1, 3)
    print(f'    [{label}] removed {len(exclude):3d} -> {"FAILS" if fails else "clean"}   {msg}')
    return fails


def main():
    global FIXED
    if '--fixed' in sys.argv:
        i = sys.argv.index('--fixed')
        FIXED = [l.strip() for l in open(sys.argv[i + 1]) if l.strip()]
        del sys.argv[i:i + 2]
        print(f'baseline also excludes {len(FIXED)} entries (--fixed)')
    all_e = entries()
    if sys.argv[1] == '--list':
        want = [l.strip() for l in open(sys.argv[2]) if l.strip()]
        unknown = [f for f in want if f not in all_e]
        if unknown:
            sys.exit('not in manifest: ' + ' '.join(unknown))
        window = want
        print(f'bisecting an explicit list of {len(window)} entries, '
              f'by REMOVING from the full {len(all_e)}-entry manifest')
    else:
        lo, hi = int(sys.argv[1]), int(sys.argv[2])
        window = all_e[lo:hi]
        print(f'bisecting manifest[{lo}:{hi}] = {len(window)} entries, '
              f'by REMOVING from the full {len(all_e)}-entry manifest')

    step = 0
    while len(window) > 1:
        step += 1
        mid = len(window) // 2
        a, b = window[:mid], window[mid:]
        ra = test(f'bx{step}a', a)
        if ra is False:                       # removing a fixed it -> culprit in a
            window = a
            print(f'  step {step}: culprit in the FIRST half ({len(a)})')
            continue
        rb = test(f'bx{step}b', b)
        if rb is False:
            window = b
            print(f'  step {step}: culprit in the SECOND half ({len(b)})')
            continue
        print(f'  step {step}: removing NEITHER half fixes it '
              f'(a={ra}, b={rb}) -- not a single culprit.')
        print('  INTERACTION or layout sensitivity. Stop here and use ddmin_guru.py;')
        print('  do not pick a half.')
        print(f'  remaining window ({len(window)}):')
        for f in window:
            print(f'    {f}')
        return 2

    if window:
        print(f'\n*** CULPRIT: {window[0]} ***')
        print('Confirm it: remove it alone from the full manifest, and separately')
        print('build with ONLY it added to a clean baseline. One test is not enough.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
