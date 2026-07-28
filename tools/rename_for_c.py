#!/usr/bin/env python3
"""Rename assembly symbols to the name SAS/C emits for them.

    python3 tools/rename_for_c.py <Symbol> [<Symbol> ...]

`sc` puts an underscore in front of every external name, so C that says
`extern short FOO` asks the linker for `_FOO`. A data label or a JMPTBL wrapper
that a restoration must reach therefore has to carry the underscore in the
assembly as well.

The rename is byte-neutral: a label name has no effect on the encoding, so
`./test-hash.sh` and `./build-split.sh` must both stay green across it. Run
them.

`tools/split_module.py` already does this for the function label it extracts.
This tool is for everything ELSE a restoration touches -- the format strings,
the globals it reads, and the jump-table wrappers it calls.

A symbol that already starts with an underscore is skipped, and so is a symbol
that is not present in `src/`, which is reported rather than passed over in
silence.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'src')


def sources():
    for dirpath, _, files in os.walk(SRC):
        for f in files:
            if f.endswith(('.s', '.asm')):
                yield os.path.join(dirpath, f)


def rename(symbols):
    pending = []
    for s in symbols:
        if s.startswith('_'):
            print(f'skip    {s}  (already has the underscore)')
            continue
        pending.append(s)
    if not pending:
        return 0

    seen = {s: 0 for s in pending}
    pat = {s: re.compile(r'(?<![\w])' + re.escape(s) + r'(?![\w])') for s in pending}
    for p in sources():
        t = open(p).read()
        n = t
        for s in pending:
            n, k = pat[s].subn('_' + s, n)
            seen[s] += k
        if n != t:
            open(p, 'w').write(n)

    rc = 0
    for s in pending:
        if seen[s]:
            print(f'renamed {s} -> _{s}  ({seen[s]} site(s))')
        else:
            print(f'ABSENT  {s}  (no site in src/)')
            rc = 1
    return rc


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    sys.exit(rename(sys.argv[1:]))
