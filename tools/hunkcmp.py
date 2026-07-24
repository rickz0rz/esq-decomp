#!/usr/bin/env python3
"""Compare two AmigaDOS hunk executables by CONTENT, ignoring container encoding.

Checks: hunk count/kinds, declared sizes, memory flags, full hunk image bytes
(zero-extended to declared size), and the SET of relocation targets per hunk.
Reloc *encoding* (RELOC32 vs RELOC32SHORT, block order, trailing-zero trimming)
is ignored -- it carries no program semantics.
"""
import sys, struct

def parse(fn):
    d = open(fn, 'rb').read(); p = 0
    def u32():
        nonlocal p
        v = struct.unpack('>I', d[p:p+4])[0]; p += 4; return v
    sizes = []; hunks = []; cur = None
    while p < len(d):
        h = u32(); t = h & 0x3FFFFFFF
        if t == 0x3F3:                                    # HEADER
            while u32() != 0: pass
            u32(); f = u32(); l = u32()
            sizes = [u32() for _ in range(l - f + 1)]
        elif t in (0x3E9, 0x3EA, 0x3EB):                  # CODE / DATA / BSS
            kind = {0x3E9: 'CODE', 0x3EA: 'DATA', 0x3EB: 'BSS'}[t]
            n = u32() * 4
            img = b'' if t == 0x3EB else d[p:p+n]
            if t != 0x3EB: p += n
            cur = {'kind': kind, 'img': img, 'relocs': set()}
            hunks.append(cur)
        elif t == 0x3EC:                                  # RELOC32 (long)
            while True:
                c = u32()
                if c == 0: break
                hn = u32()
                for _ in range(c): cur['relocs'].add((hn, u32()))
        elif t == 0x3F7:                                  # RELOC32SHORT (in load files)
            st = p
            while True:
                c = struct.unpack('>H', d[p:p+2])[0]; p += 2
                if c == 0: break
                hn = struct.unpack('>H', d[p:p+2])[0]; p += 2
                for _ in range(c):
                    cur['relocs'].add((hn, struct.unpack('>H', d[p:p+2])[0])); p += 2
            if (p - st) % 4: p += 2
        elif t == 0x3F0:                                  # SYMBOL
            while True:
                n = u32()
                if n == 0: break
                p += n*4 + 4
        elif t == 0x3F2: pass                             # END
        else: break
    for i, h in enumerate(hunks):
        h['size'] = (sizes[i] & 0x3FFFFFFF) * 4
        h['mem']  = sizes[i] >> 30
        h['img']  = h['img'].ljust(h['size'], b'\0')      # normalize trimmed zeros
    return hunks

a, b = parse(sys.argv[1]), parse(sys.argv[2])
ok = True
if len(a) != len(b):
    print(f'MISMATCH hunk count: {len(a)} vs {len(b)}'); sys.exit(1)
for i, (x, y) in enumerate(zip(a, b)):
    for k in ('kind', 'size', 'mem'):
        if x[k] != y[k]:
            print(f'hunk{i} MISMATCH {k}: {x[k]} vs {y[k]}'); ok = False
    if x['img'] != y['img']:
        diff = [j for j in range(min(len(x['img']), len(y['img']))) if x['img'][j] != y['img'][j]]
        print(f'hunk{i} ({x["kind"]}) MISMATCH image: {len(diff)} differing bytes, first at 0x{diff[0]:x}' if diff
              else f'hunk{i} MISMATCH image length'); ok = False
    if x['relocs'] != y['relocs']:
        print(f'hunk{i} ({x["kind"]}) MISMATCH relocs: {len(x["relocs"])} vs {len(y["relocs"])}, '
              f'only-in-A={len(x["relocs"]-y["relocs"])} only-in-B={len(y["relocs"]-x["relocs"])}'); ok = False
    if ok:
        print(f'hunk{i} {x["kind"]:4s} size={x["size"]:>7} mem={x["mem"]} relocs={len(x["relocs"]):>5}  IDENTICAL')
print('\n*** CONTENT-IDENTICAL ***' if ok else '\n*** DIFFERS ***')
sys.exit(0 if ok else 1)
