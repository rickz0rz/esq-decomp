#!/usr/bin/env python3
"""Join a DATA module to the one that immediately follows it.

    python3 tools/data_merge.py                 # what can be joined, and why
    python3 tools/data_merge.py --write         # do it

A C replacement substitutes for a WHOLE module, and a hunk object is
longword-sized, so a DATA module can only move to C when its size AND its start
offset are both multiples of 4. Twenty-eight of the remaining fragments are
neither -- they are 2, 6, 10 or 18 bytes long.

Every one of them PAIRS with its neighbour into a group that is aligned at both
ends. So the fix is not a smarter generator, it is a coarser module: join the two
assembly files into one, and convert that.

Joining is byte-neutral. The content and the order do not change, only which
file holds them, so both gates stay green -- this is tools/split_module.py run
backwards.

Two things have to hold before a pair is joined, and the tool checks both rather
than trusting the offsets:

- The two modules must be CONSECUTIVE include lines in src/Prevue.asm. Equal
  offsets are not proof, because a zero-length module in between leaves them
  looking adjacent.
- Neither may already be replaced by C.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))


def plan():
    os.environ.pop('C_REPLACEMENTS', None)
    os.environ.pop('ESQ_FARCALLS', None)
    import gen_units as gu
    prelude, incs = gu.read_root()
    os.makedirs(gu.OUT, exist_ok=True)
    gu.far_rewrite(incs)
    sizes, _ = gu.measure(incs)
    size = dict(zip(incs, sizes))

    repl = {l.split()[0] for l in open(os.path.join(ROOT, 'src/c/replacements-all.txt'))
            if l.strip() and not l.startswith('#')}

    data = [m for m in incs if m.startswith('data/')]
    off, o = {}, 0
    for m in data:
        off[m] = o
        o += size[m]

    pairs, used = [], set()
    for i, a in enumerate(data[:-1]):
        b = data[i + 1]
        if a in used or b in used or a in repl or b in repl:
            continue
        if size[a] == 0 or size[b] == 0:
            continue
        if off[a] % 4 or (size[a] + size[b]) % 4:
            continue
        pairs.append((a, b, off[a], size[a] + size[b]))
        used.add(a)
        used.add(b)
    return pairs


def join(a, b):
    """Append module b's body to a, drop b's include, delete b."""
    pa = os.path.join(ROOT, 'src', a)
    pb = os.path.join(ROOT, 'src', b)
    ta = open(pa).read()
    tb = open(pb).read()
    open(pa, 'w').write(ta.rstrip('\n') + '\n\n'
                        + '; ---- joined from %s by tools/data_merge.py ----\n' % b
                        + tb)
    root = os.path.join(ROOT, 'src', 'Prevue.asm')
    lines = open(root).read().split('\n')
    want = 'include "%s"' % b
    out = [l for l in lines if want not in l]
    if len(out) != len(lines) - 1:
        sys.exit('data_merge: expected exactly one include of %s, found %d'
                 % (b, len(lines) - len(out)))
    open(root, 'w').write('\n'.join(out))
    os.remove(pb)


def main():
    pairs = plan()
    for a, b, o, n in pairs:
        print('%-26s + %-26s  start %6d  size %3d'
              % (a.split('/')[-1], b.split('/')[-1], o, n))
    sys.stderr.write('%d pair(s), %d bytes\n'
                     % (len(pairs), sum(n for _, _, _, n in pairs)))
    if '--write' in sys.argv:
        for a, b, _, _ in pairs:
            join(a, b)
        sys.stderr.write('joined %d pair(s)\n' % len(pairs))


if __name__ == '__main__':
    main()
