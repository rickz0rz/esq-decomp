#!/usr/bin/env python3
"""What is still assembly in the maximum-C build, and why.

    python3 tools/lastmile.py [manifest]        # default src/c/replacements-all.txt
    python3 tools/lastmile.py --list jumptable  # print the modules in one bucket

A raw count of unreplaced modules OVERSTATES the work by about four times, and
that is the reason this script exists. Most of what is left holds no code at
all: `src/Prevue.asm` includes 150 EMPTY files and 10 that carry only alignment.
Neither needs a C replacement, because neither contributes a byte.

The buckets:

  empty            the file has no code lines
  alignment        the file has a few lines and no label (a DC.W pad)
  jumptable        every label is a thunk -- tools/jmptbl_to_c.py writes these
  library          modules/submodules/, which is SAS/C runtime code, not ESQ's
  code             real application code, and the only bucket that is work

Read the `code` bucket as the worklist. A jump table cannot be converted until
every function it points at has a restoration, so the code bucket gates the
jumptable bucket and must be worked first.
"""
import collections
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LABEL = re.compile(r'^([A-Za-z_][A-Za-z0-9_.]*):')


def modules():
    """Module includes, in link order, from the canonical module list."""
    out = []
    with open(os.path.join(ROOT, 'src', 'Prevue.asm')) as fh:
        for ln in fh:
            m = re.match(r'\s*include\s+"?([^"\s]+)"?', ln, re.I)
            if m and m.group(1).startswith(('modules/', 'data/')):
                out.append(m.group(1))
    return out


def replaced(manifest):
    out = set()
    with open(manifest) as fh:
        for ln in fh:
            ln = ln.split('#')[0].strip()
            if ln:
                out.add(ln.split()[0])
    return out


def classify(path):
    full = os.path.join(ROOT, 'src', path)
    if not os.path.exists(full):
        return 'missing', 0
    if '/submodules/' in path:
        return 'library', 0
    text = open(full, errors='replace').read()
    body = [l for l in text.split('\n') if l.strip() and not l.strip().startswith(';')]
    labels = [l.split(':')[0] for l in text.split('\n') if LABEL.match(l)]
    labels = [L for L in labels if not L.endswith('_Return')]
    if not body:
        return 'empty', 0
    if labels and all('JMPTBL' in L for L in labels):
        return 'jumptable', len(labels)
    if not labels and len(body) <= 6:
        return 'alignment', 0
    return 'code', len(labels)


def main():
    args = [a for a in sys.argv[1:]]
    want = None
    if '--list' in args:
        i = args.index('--list')
        want = args[i + 1]
        del args[i:i + 2]
    manifest = args[0] if args else os.path.join(ROOT, 'src/c/replacements-all.txt')

    left = [m for m in modules() if m not in replaced(manifest)]
    buckets = collections.defaultdict(list)
    labels = collections.Counter()
    for m in left:
        kind, n = classify(m)
        buckets[kind].append(m)
        labels[kind] += n

    if want:
        for m in buckets.get(want, []):
            print(m)
        return 0

    print(f'manifest: {os.path.relpath(manifest, ROOT)}')
    print(f'module includes still assembly: {len(left)}\n')
    order = ['code', 'jumptable', 'library', 'alignment', 'empty', 'missing']
    for k in order:
        if not buckets[k]:
            continue
        extra = f'   ({labels[k]} labels)' if labels[k] else ''
        print(f'  {len(buckets[k]):4d}  {k}{extra}')
    work = len(buckets['code']) + len(buckets['jumptable'])
    print(f'\n  real work: {work} modules '
          f'({len(buckets["code"])} code + {len(buckets["jumptable"])} jump tables)')
    print(f'  no work:   {len(buckets["empty"]) + len(buckets["alignment"])} '
          f'empty or alignment-only modules')

    if buckets['code']:
        print('\n=== code bucket -- the worklist, largest first ===')
        sized = sorted(buckets['code'],
                       key=lambda m: -len(open(os.path.join(ROOT, 'src', m),
                                               errors='replace').read().split('\n')))
        for m in sized[:25]:
            n = classify(m)[1]
            print(f'  {n:2d} labels   {m}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
