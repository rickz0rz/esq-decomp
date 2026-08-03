#!/usr/bin/env python3
"""Identify which `modules/submodules/` routines are SAS/C library members.

    python3 tools/libmatch.py <label> [<label> ...]
    python3 tools/libmatch.py --module modules/submodules/unknown22_p0.s
    python3 tools/libmatch.py --all-remaining     # every submodule not yet in C

AGENTS.md says library code should be LINKED from sc.lib rather than
hand-decompiled, and that a stubborn mismatch in `submodules/` is a signal that
the routine is library code. This answers the question that turns that advice
into an action: for a given routine, WHICH member of WHICH library is it, and
under what symbol name.

A raw byte search only finds relocation-free routines, which is why AGENTS.md
calls its 5% figure a floor. The reference bytes come out of the LINKED binary
with every address already patched in. A library member holds zeros in those
fields plus a relocation list. So the comparison masks each field a relocation
or an external reference would patch, at its own width -- 4 bytes for RELOC32,
2 for the A4-relative DREL16 that dominates a near-data library.

A match here is evidence about identity, not a licence to link. The member's
symbol name is SAS/C's (`_strcat`), not the disassembly's
(`STRING_AppendAtNull`), so linking it means renaming every caller first.
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import sclib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIB_DIR = os.path.expanduser('~/Downloads/SAS-C-hdd/sc/lib')
LIBS = ['sc.lib', 'amiga.lib', 'scnb.lib', 'small.lib']


def refbytes(label):
    out = subprocess.run(['python3', os.path.join(ROOT, 'tools', 'refbytes.py'), label],
                         capture_output=True, text=True, cwd=ROOT).stdout
    for line in out.split('\n'):
        if line.startswith('bytes:'):
            try:
                return bytes.fromhex(line.split(':', 1)[1].strip())
            except ValueError:
                return None
    return None


def load_libs():
    out = []
    for n in LIBS:
        p = os.path.join(LIB_DIR, n)
        if os.path.exists(p):
            try:
                out.append((n, sclib.parse(p)))
            except SystemExit:
                pass
    return out


def find(raw, libs, everywhere=True):
    """Every (library, member, symbol) whose bytes match raw with relocs masked.

    Offsets where a symbol is DEFINED are the interesting ones, but they are not
    the only ones. A routine can sit inside a member without a symbol of its own,
    and a string constant almost always does. Checking only the def offsets
    reported 2 of 51 and missed four strings that a plain byte search finds, so
    the default sweeps every word-aligned offset and reports the nearest symbol
    at or before the hit.
    """
    hits = []
    n = len(raw)
    for libname, members in libs:
        for m in members:
            if not m.data or len(m.data) < n:
                continue
            offsets = range(0, len(m.data) - n + 1, 2) if everywhere \
                else sorted(set(m.defs.values()))
            for off in offsets:
                if off + n > len(m.data):
                    continue
                # Cheap reject first: the whole point is to avoid the masked
                # compare on the ~99.9% of offsets that cannot match.
                if raw[0] != m.data[off] and not any(
                        o <= off < o + w for o, w in m.relocs):
                    continue
                shifted = {(o - off, w) for o, w in m.relocs
                           if off <= o < off + n}
                if sclib.masked_equal(raw, m.data[off:off + n], shifted):
                    at = [(v, s) for s, v in m.defs.items() if v <= off]
                    sym = max(at)[1] if at else '(no symbol)'
                    hits.append((libname, m, sym, off, len(shifted)))
                    break
    return hits


def labels_of(module):
    body = open(os.path.join(ROOT, 'src', module)).read()
    return re.findall(r'^(_?[A-Za-z][\w]*):', body, re.M)


def remaining_submodules():
    env = dict(os.environ)
    env.pop('C_REPLACEMENTS', None)
    env.pop('ESQ_FARCALLS', None)
    old = os.environ.copy()
    os.environ.clear()
    os.environ.update(env)
    try:
        sys.path.insert(0, os.path.join(ROOT, 'tools'))
        import gen_units as gu
        _, incs = gu.read_root()
        os.makedirs(gu.OUT, exist_ok=True)
        gu.far_rewrite(incs)
    finally:
        os.environ.clear()
        os.environ.update(old)
    repl = set()
    with open(os.path.join(ROOT, 'src', 'c', 'replacements-all.txt')) as f:
        for line in f:
            line = line.split('#')[0].strip()
            p = line.split()
            if len(p) >= 2:
                repl.add(p[0])
    return [m for m in incs if 'submodules' in m and m not in repl]


def main():
    args = [a for a in sys.argv[1:]]
    labels = []
    if '--all-remaining' in args:
        for m in remaining_submodules():
            labels += labels_of(m)
    elif '--module' in args:
        labels = labels_of(args[args.index('--module') + 1])
    else:
        labels = args
    labels = [l for l in dict.fromkeys(labels) if l]
    if not labels:
        sys.exit(__doc__)

    libs = load_libs()
    if not libs:
        sys.exit('libmatch: no libraries found under %s' % LIB_DIR)

    found, missing = [], []
    for lab in labels:
        raw = refbytes(lab)
        if not raw or len(raw) < 8:
            missing.append((lab, 0, 'no usable reference bytes'))
            continue
        hits = find(raw, libs)
        if hits:
            found.append((lab, len(raw), hits))
        else:
            missing.append((lab, len(raw), 'no member matches'))

    # A short routine matches by accident. Every AmigaOS stub in amiga.lib is
    # the same three instructions -- load the base into A6, JSR a negative
    # offset, RTS -- so a 20-byte routine "matching" _FreeVisualInfo says
    # nothing. Anything under this bar is reported separately rather than
    # counted as an identification.
    MIN_TRUSTED = 24
    solid = [f for f in found if f[1] >= MIN_TRUSTED]
    weak = [f for f in found if f[1] < MIN_TRUSTED]

    def show(rows):
        for lab, n, hits in sorted(rows, key=lambda x: -x[1]):
            libname, m, sym, off, nrel = hits[0]
            extra = '' if len(hits) == 1 else '   (+%d more)' % (len(hits) - 1)
            print('  %5d  %-44s %s :: %-16s %-22s +%d  %d masked%s'
                  % (n, lab, libname, m.unit, sym, off, nrel, extra))

    print('=== MATCHED (%d of %d) ===' % (len(solid), len(labels)))
    show(solid)
    if weak:
        print('\n=== TOO SHORT TO TRUST, under %d bytes (%d) ===' % (MIN_TRUSTED, len(weak)))
        print('    Library-call stubs are all the same shape. Treat as coincidence')
        print('    unless the surrounding member also matches.')
        show(weak)
    print('\n=== NOT MATCHED (%d) ===' % len(missing))
    for lab, n, why in sorted(missing, key=lambda x: -x[1]):
        print('  %5d  %-44s %s' % (n, lab, why))
    return 0


if __name__ == '__main__':
    sys.exit(main())
