#!/usr/bin/env python3
"""Find C externs whose assembly label does not carry the SAS/C underscore.

    python3 tools/check_c_symbols.py            # report
    python3 tools/check_c_symbols.py --fix      # report and rename

`sc` emits `_FOO` for `extern ... FOO`. If the assembly still calls the label
`FOO`, the link fails with "Reference to undefined symbol _FOO" -- but only at
the end of a full split build, after every module has assembled. That is a slow
way to find a one-word problem, and a restoration that reads a dozen globals can
need a dozen renames.

This reports each extern in `src/c/` that has no `_NAME` label in `src/` but
does have a `NAME` label, which is exactly the set `tools/rename_for_c.py`
fixes. `--fix` calls that tool for you.

A name that matches NEITHER is reported separately: it is either a typo, or a
symbol that does not exist, and renaming cannot help it.

The rename is byte-neutral, so run `./test-hash.sh` and `./build-split.sh`
after --fix. See tools/check_c_externs.py for the opposite mistake, a C
declaration written WITH the underscore.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')
SRC = os.path.join(ROOT, 'src')

# names sc resolves itself, plus the ones mkabsdefs.py synthesises
BUILTIN = {'SysBase', 'GfxBase', 'DOSBase', 'IntuitionBase', 'strlen', 'strcpy',
           'strcat', 'strcmp', 'memcpy', 'memset', 'sprintf',
           'VPOSR', 'CIAB_PRA', 'SERDAT', 'INTENA'}


def asm_labels():
    out = set()
    for dp, _, fs in os.walk(SRC):
        for f in fs:
            if f.endswith(('.s', '.asm')):
                t = open(os.path.join(dp, f), errors='replace').read()
                out |= set(re.findall(r'^([A-Za-z_][\w]*):', t, re.M))
    return out


def c_externs():
    """{name: [files]} for every identifier declared extern in src/c."""
    out = {}
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c'):
            continue
        text = open(os.path.join(CDIR, fn), errors='replace').read()
        # drop the header comment block so prose names are not picked up
        if '*/' in text:
            text = text.split('*/', 1)[1]
        for m in re.finditer(r'^\s*extern\b([^;]*);', text, re.M | re.S):
            # Cut at the first top-level '(' -- everything after it is a
            # PARAMETER list, and parameter names are not linker symbols. An
            # earlier version took every identifier in the declaration and
            # reported 111 nonexistent symbols called `x`, `rp` and `size`.
            decl, depth = [], 0
            for ch in m.group(1):
                if ch == '(':
                    depth += 1
                    if depth == 1:
                        decl.append(';')     # stop this declarator
                        continue
                elif ch == ')':
                    depth -= 1
                    continue
                if depth == 0:
                    decl.append(ch)
            for part in ''.join(decl).replace(';', ',').split(','):
                names = re.findall(r'[A-Za-z_]\w*', part.split('[')[0])
                if names:
                    out.setdefault(names[-1], []).append(fn)
    return out


def main():
    labels = asm_labels()
    need, missing = [], []
    for name, files in sorted(c_externs().items()):
        if name in BUILTIN or ('_' + name) in labels:
            continue
        if name in labels:
            need.append((name, files))
        else:
            missing.append((name, files))

    for name, files in need:
        print(f'RENAME  {name} -> _{name}   ({files[0]})')
    for name, files in missing:
        print(f'ABSENT  {name}   no label either way   ({files[0]})')

    if need and '--fix' in sys.argv:
        print(f'\nrenaming {len(need)} symbol(s)')
        subprocess.call([sys.executable,
                         os.path.join(ROOT, 'tools', 'rename_for_c.py')]
                        + [n for n, _ in need])
        return 0

    return 1 if (need or missing) else 0


if __name__ == '__main__':
    sys.exit(main())
