#!/usr/bin/env python3
"""Add the XDEFs that module splitting makes necessary.

    python3 tools/fix_exports.py [--dry-run]

A label referenced only from inside its own .s file needs no export. Split that
file and the reference becomes cross-module, so the split build fails with
"Reference to undefined symbol" -- one at a time, which is a miserable way to
find several hundred of them.

This computes the closure instead: every label defined in one module and
referenced from another gets an `XDEF` in the module that defines it. Adding an
export changes no bytes (the monolithic build resolves everything either way), so
`./test-hash.sh` must stay green across it, and `./build-split.sh` is what the
change is actually for.

Comments are stripped before looking for references, so a function named in a
`; CALLS:` header does not manufacture an export. A stray extra XDEF would be
harmless anyway -- vlink does not care -- but the noise would obscure the real
dependency structure.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODS = os.path.join(ROOT, 'src', 'modules')


def strip_comments(text):
    return '\n'.join(l.split(';')[0] for l in text.split('\n'))


def main():
    dry = '--dry-run' in sys.argv
    files = []
    for dp, _, fs in os.walk(MODS):
        for f in fs:
            if f.endswith('.s'):
                files.append(os.path.join(dp, f))

    defs, texts = {}, {}
    for p in files:
        t = open(p).read()
        texts[p] = t
        for l in re.findall(r'^([A-Za-z_][\w]*):', t, re.M):
            defs.setdefault(l, p)          # first definition wins; duplicates are a
                                           # separate error the assembler will report

    # which labels does each file mention, ignoring its own definitions?
    needed = {}
    for p in files:
        toks = set(re.findall(r'[A-Za-z_][\w]*', strip_comments(texts[p])))
        for l in toks & set(defs):
            if defs[l] != p:
                needed.setdefault(defs[l], set()).add(l)

    added = 0
    for p, labels in sorted(needed.items()):
        t = texts[p]
        have = set(re.findall(r'^\s*XDEF\s+(\S+)', t, re.M))
        missing = sorted(labels - have)
        if not missing:
            continue
        added += len(missing)
        if dry:
            print(f'{os.path.relpath(p, ROOT)}: +{len(missing)} {missing[:4]}')
            continue
        block = ''.join(f'    XDEF    {l}\n' for l in missing)
        lines = t.split('\n')
        last = -1
        for i, ln in enumerate(lines):
            if ln.strip().startswith('XDEF'):
                last = i
            elif ln.strip() and last >= 0:
                break
        if last >= 0:
            lines.insert(last + 1, block.rstrip('\n'))
            open(p, 'w').write('\n'.join(lines))
        else:
            open(p, 'w').write(block + '\n' + t)

    print(f'{"would add" if dry else "added"} {added} XDEF(s) '
          f'across {len(needed)} module(s)')


if __name__ == '__main__':
    main()
