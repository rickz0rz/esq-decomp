#!/usr/bin/env python3
"""Catch C declarations of assembly symbols written with a leading underscore.

    python3 tools/check_c_externs.py

`sc` PREPENDS an underscore to every external name, so C that declares
`extern long _FOO(void)` asks the linker for `__FOO` and fails with
"Reference to undefined symbol __FOO". The assembly label is `_FOO`, so the C
must say `FOO`.

This is worth a check rather than a docs line because it is invisible until the
maximum-C build links -- both byte gates stay green, cmatch is perfectly happy
(the reference bytes match; only the relocation target name is wrong), and
mismatches.py reports nothing. It cost three separate link failures in one
session before being automated.

Exits nonzero and names the file and identifier, so it can be wired into a
pre-build step.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')

# A leading-underscore identifier in a declaration or call position. Skip the
# reserved forms C itself uses (__asm, __saveds, __emit, _Return...) and
# double-underscore names, which are the compiler's own.
BAD = re.compile(r'(?<![\w])_([A-Z][A-Za-z0-9_]{2,})\s*(?=[(;,)\[]|$)', re.M)
ALLOW = {'_SysBase'}


def main():
    hits = []
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c'):
            continue
        text = open(os.path.join(CDIR, fn), errors='replace').read()
        # strip comments so header prose (which legitimately names _FOO labels,
        # e.g. "RESTORES: _FOO") is not flagged
        text = re.sub(r'/\*.*?\*/', '', text, flags=re.S)
        text = re.sub(r'//[^\n]*', '', text)
        for m in BAD.finditer(text):
            name = '_' + m.group(1)
            if name in ALLOW or name.startswith('__'):
                continue
            hits.append((fn, name))

    if not hits:
        print(f'check_c_externs: clean ({len(os.listdir(CDIR))} files)')
        return 0
    print('C code naming an assembly symbol with a LEADING UNDERSCORE.')
    print('sc prepends its own, so this links as __NAME and fails. Drop the underscore.\n')
    for fn, name in sorted(set(hits)):
        print(f'  {fn:52s} {name}  -> should be {name[1:]}')
    return 1


if __name__ == '__main__':
    sys.exit(main())
