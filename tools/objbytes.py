#!/usr/bin/env python3
"""Dump the code-hunk bytes of an Amiga hunk object file.

    python3 tools/objbytes.py foo.o [--hex]

Prints the first CODE/DATA hunk's contents as hex. Offsets carrying a
relocation are reported separately, since those longs hold link-time addresses
and cannot be compared by value against a linked reference.
"""
import struct, sys


def parse(fn):
    d = open(fn, 'rb').read(); p = 0; code = b''; relocs = set(); xdefs = {}; xrefs = {}

    def u32():
        nonlocal p
        v = struct.unpack('>I', d[p:p+4])[0]; p += 4; return v

    # NB: never write `p += u32() * 4` -- Python loads p before evaluating the
    # right-hand side, so u32()'s advance of p is silently discarded. Always
    # capture the count into a local first.
    while p < len(d):
        t = u32() & 0x3FFFFFFF
        if t in (0x3E7, 0x3E8):
            n = u32(); p += n * 4
        elif t in (0x3E9, 0x3EA):
            n = u32() * 4; code = d[p:p+n]; p += n
        elif t == 0x3EB:
            u32()
        elif t == 0x3EC:
            while True:
                c = u32()
                if c == 0: break
                u32()
                for _ in range(c): relocs.add(u32())
        elif t == 0x3EF:                                   # HUNK_EXT
            while True:
                x = u32()
                if x == 0: break
                typ = x >> 24; nl = (x & 0xFFFFFF) * 4
                name = d[p:p+nl].rstrip(b'\0').decode('latin1'); p += nl
                # 1/2/3 = definition (abs/rel/common); 129=REF32, 130=COMMON,
                # 131=REF16, 132=REF8, 133=DREF32, 134=DREF16, 135=DREF8.
                # The WIDTH matters: a 16-bit PC-relative reference occupies two
                # bytes, and masking four would also blank the following opcode,
                # hiding a real difference there.
                WIDTH = {129: 4, 130: 4, 131: 2, 132: 1, 133: 4, 134: 2, 135: 1}
                if typ in (1, 2, 3):
                    xdefs[name] = u32()
                elif typ == 130:                           # common: size then refs
                    u32()
                    c = u32()
                    for _ in range(c): xrefs.setdefault(name, []).append((u32(), 4))
                else:
                    w = WIDTH.get(typ, 4)
                    c = u32()
                    for _ in range(c): xrefs.setdefault(name, []).append((u32(), w))
        elif t == 0x3F0:                                   # HUNK_SYMBOL
            while True:
                nl = u32()
                if nl == 0: break
                p += nl * 4; u32()
        elif t == 0x3F1:
            n = u32(); p += n * 4
        elif t == 0x3F2:
            pass
        else:
            break
    return code, sorted(relocs), xdefs, xrefs


if __name__ == '__main__':
    code, relocs, xdefs, xrefs = parse(sys.argv[1])
    print(f'code: {len(code)} bytes')
    if xdefs:
        print('xdef: ' + ', '.join(f'{k}@0x{v:x}' for k, v in sorted(xdefs.items(), key=lambda kv: kv[1])))
    if xrefs:
        print('xref: ' + ', '.join(f'{k}@{[(hex(o), w) for o, w in v]}' for k, v in sorted(xrefs.items())))
    if relocs:
        print(f'relocs at: {[hex(r) for r in relocs]}')
    print(f'bytes: {code.hex()}')
