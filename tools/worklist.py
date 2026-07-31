#!/usr/bin/env python3
"""Print the remaining restoration targets for the current tranche.

    python3 tools/worklist.py            # the tranche target: everything under 400 bytes
    python3 tools/worklist.py 800        # a different size limit
    python3 tools/worklist.py --bands    # how far each size band would take coverage

The point of this script is that it CANNOT go stale. A checked-in list of
function names starts rotting the moment somebody restores one. This reads
coverage.survey() every time, so a name disappears from the output as soon as
its restoration lands.

Ranking. Targets come out smallest first. Small functions restore fastest, each
one is independently verifiable, and a tranche of them survives a context reset
better than one large function left half-read. `kind` is the call encoding in the
ORIGINAL, which decides whether an exact match is even possible -- see AGENTS.md,
"Progress is measured in BYTES". It does not decide whether the restoration is
worth doing, because a behavioural restoration still counts.

Blocked shapes are excluded. So are functions whose header already says
DO-NOT-LINK, and functions already restored.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import coverage

BLOCK = {'register-args', 'live-register-on-entry', 'interior-label',
         'rotate-instruction', 'tail-jump', 'predecrement-store',
         'falls-through'}
TOTAL_BYTES = 193516
TARGET_LIMIT = 400          # the current tranche: everything under this size


def module_index():
    """label -> (module path relative to src/, number of labels in that module).

    The label count matters: gen_all_manifest.py SILENTLY skips a restoration
    whose module holds more than one label, so a multi-label module needs
    tools/split_module.py first. Printing it here saves finding out after the
    C is already written.
    """
    home = {}
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for f in fs:
            if not f.endswith('.s'):
                continue
            p = os.path.join(dp, f)
            labs = re.findall(r'^([A-Za-z_][\w]*):', open(p).read(), re.M)
            for l in labs:
                home[l] = (os.path.relpath(p, os.path.join(ROOT, 'src')),
                           len(labs))
    return home


def targets():
    home = module_index()
    out = []
    for f in coverage.survey():
        if f['status'] is not None or (set(f['blockers']) & BLOCK):
            continue
        bare = f['name'].lstrip('_')
        cand = next((c for c in (f['name'], '_' + bare, bare) if c in home),
                    None)
        mod, nlab = home.get(cand, ('?', 0))
        out.append((f['size'], f['name'], f['kind'], mod, nlab))
    out.sort()
    return out


def main():
    args = sys.argv[1:]
    done = sum(f['size'] for f in coverage.survey() if f['status'] is not None)
    all_t = targets()

    if '--bands' in args:
        print(f'baseline {done / TOTAL_BYTES * 100:.1f}%')
        cum = done
        for lo, hi in ((0, 250), (250, 400), (400, 600), (600, 800),
                       (800, 1200), (1200, 10**9)):
            s = [t for t in all_t if lo <= t[0] < hi]
            cum += sum(t[0] for t in s)
            print(f'  {lo:5d}-{hi:<7d} {len(s):4d} fns '
                  f'{sum(t[0] for t in s):7,} bytes  -> {cum / TOTAL_BYTES * 100:5.1f}%')
        return

    limit = int(args[0]) if args and args[0].isdigit() else TARGET_LIMIT
    sel = [t for t in all_t if t[0] < limit]
    gain = sum(t[0] for t in sel)
    print(f'TRANCHE TARGET: every unblocked function under {limit} bytes')
    print(f'  now      {done:,} bytes  {done / TOTAL_BYTES * 100:.1f}%')
    print(f'  target   {done + gain:,} bytes  '
          f'{(done + gain) / TOTAL_BYTES * 100:.1f}%   '
          f'(+{gain / TOTAL_BYTES * 100:.1f} points)')
    print(f'  remaining {len(sel)} functions, {gain:,} bytes')
    print()
    print(f'{"bytes":>6}  {"kind":11s}  {"labels":>6}  name / module')
    for size, name, kind, mod, nlab in sel:
        flag = '  SPLIT' if nlab > 1 else ''
        print(f'{size:6d}  {kind:11s}  {nlab:6d}{flag}  {name}')
        print(f'{"":6}  {"":11s}  {"":6}    {mod}')


if __name__ == '__main__':
    main()
