#!/usr/bin/env python3
"""Split a DATA module at a longword-aligned label so its tail can become C.

    python3 tools/data_split.py data/wdisp.s            # show the candidates
    python3 tools/data_split.py data/wdisp.s --write    # split at the first one

A data module may only be replaced by C when it is LAYOUT-NEUTRAL: its start
offset in the DATA section is a multiple of 4 AND its size is. Most modules are
neither, because the original's file boundaries have nothing to do with longword
alignment.

Splitting fixes that. Cut the module at a label whose ABSOLUTE offset is
4-aligned and the tail is layout-neutral by construction -- it starts aligned,
and it ends where the module ended, so its size carries the module's own
remainder. The head keeps whatever misalignment there was and stays in assembly.

Cutting at the FIRST aligned label therefore converts as much as possible. For a
module that is already 0 mod 4 in size, every aligned label yields a convertible
tail AND a convertible head.

It is also the answer to a compiler limit. SAS/C 6.51 gives up with no
diagnostic on a single file holding two 4,102-byte arrays, which is why
data/esq.s had to be halved before either piece would build.

THE SPLIT IS BYTE-NEUTRAL. Content and order are unchanged, so both gates must
stay green across it. If test-hash.sh moves, this tool has a bug.

XDEFs ARE DISTRIBUTED, NOT COPIED. Each one goes to the half that DEFINES its
symbol, and the tool asserts that none is lost. Getting this wrong is quiet: the
monolithic gate does not need XDEFs at all, so test-hash.sh still passes and
build-split.sh fails with an undefined symbol.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))


def module_start(path):
    """Absolute offset of `path` within the DATA section."""
    old = os.environ.copy()
    os.environ.pop('C_REPLACEMENTS', None)
    os.environ.pop('ESQ_FARCALLS', None)
    try:
        import gen_units as gu
        prelude, incs = gu.read_root()
        os.makedirs(gu.OUT, exist_ok=True)
        gu.far_rewrite(incs)
        sizes, ncode = gu.measure(incs)
        off = 0
        for p, s in zip(incs[ncode:], sizes[ncode:]):
            if p == path:
                return off, s
            off += s
        sys.exit('data_split: %s is not a DATA module' % path)
    finally:
        os.environ.clear()
        os.environ.update(old)


def candidates(path):
    import data_to_c as d
    base, total = module_start(path)
    spans, parsed, cond = d.parse(path)
    if parsed != total:
        sys.exit('data_split: %s: parser says %d bytes, vasm says %d. Fix '
                 'tools/data_to_c.py first.' % (path, parsed, total))
    out, off = [], 0
    for lab, items in spans:
        if off and (base + off) % 4 == 0:
            tail = total - off
            out.append((lab, off, tail, tail % 4 == 0))
        off += d.span_bytes(items)
    return base, total, out


def split(path, label):
    src = os.path.join(ROOT, 'src', path)
    orig = open(src).read().split('\n')
    xdefs = [l for l in orig if re.match(r'^\s*XDEF\s', l)]
    body = [l for l in orig if not re.match(r'^\s*XDEF\s', l)]

    # A label may carry a trailing comment -- data/wdisp.s has
    # `_GCOMMAND_PpvEditorLayoutPen:    ; 22EA`. Anchoring on end-of-line missed
    # five of them, and the XDEF guard below is what caught it.
    import data_to_c as _d
    idx = next(i for i, l in enumerate(body)
               if re.match(r'^%s:\s*$' % re.escape(label), _d._strip_comment(l).rstrip()))
    j = idx
    while j > 0 and (body[j - 1].startswith(';') or not body[j - 1].strip()):
        j -= 1
    head, tail = body[:j], body[j:]

    def labels(ls):
        return {m.group(1) for l in ls
                for m in [re.match(r'^([A-Za-z_][\w]*):\s*$',
                                   _d._strip_comment(l).rstrip())] if m}

    hl, tl = labels(head), labels(tail)
    hx = [x for x in xdefs if x.split()[1] in hl]
    tx = [x for x in xdefs if x.split()[1] in tl]
    lost = [x for x in xdefs if x not in hx and x not in tx]
    if lost:
        sys.exit('data_split: %s: these XDEFs match no label in either half: %s'
                 % (path, [x.split()[1] for x in lost]))
    assert len(hx) + len(tx) == len(xdefs)

    # A module may be split more than once -- data/wdisp.s needs four pieces to
    # get under the compiler's limit -- so take the first free _pN.
    n = 1
    while os.path.exists(os.path.join(ROOT, 'src', path[:-2] + '_p%d.s' % n)):
        n += 1
    dst = path[:-2] + '_p%d.s' % n

    open(src, 'w').write('\n'.join(hx + head))
    open(os.path.join(ROOT, 'src', dst), 'w').write('\n'.join(tx + tail))

    root = os.path.join(ROOT, 'src', 'Prevue.asm')
    t = open(root).read()
    inc = '    include "%s"\n' % path
    if inc not in t:
        sys.exit('data_split: %s is not included by Prevue.asm' % path)
    open(root, 'w').write(t.replace(inc, inc + '    include "%s"\n' % dst, 1))
    return dst, len(hx), len(tx)


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    path = sys.argv[1]
    base, total, cands = candidates(path)
    sys.stderr.write('%s: %d bytes at DATA offset %d (%d mod 4)\n'
                     % (path, total, base, base % 4))
    if not cands:
        sys.exit('  no longword-aligned label inside it -- cannot be split')
    for lab, off, tail, ok in cands[:8]:
        sys.stderr.write('  %-52s head=%-7d tail=%-7d %s\n'
                         % (lab, off, tail, 'TAIL CONVERTIBLE' if ok else ''))
    if len(cands) > 8:
        sys.stderr.write('  ... %d candidates\n' % len(cands))

    if '--write' in sys.argv:
        want = None
        if '--at' in sys.argv:
            want = sys.argv[sys.argv.index('--at') + 1]
        pick = (next((c for c in cands if c[0] == want), None) if want
                else next((c for c in cands if c[3]), None))
        if want and not pick:
            sys.exit('  %s is not a longword-aligned label in this module' % want)
        if not pick:
            sys.exit('  no candidate yields a convertible tail')
        dst, nh, nt = split(path, pick[0])
        sys.stderr.write('split at %s -> %s (head %d bytes / %d xdefs, '
                         'tail %d bytes / %d xdefs)\n'
                         % (pick[0], dst, pick[1], nh, pick[2], nt))
        sys.stderr.write('RUN BOTH GATES NOW. The split must be byte-neutral.\n')


if __name__ == '__main__':
    main()
