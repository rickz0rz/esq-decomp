#!/usr/bin/env python3
"""Read an AmigaDOS object library (HUNK_LIB/HUNK_INDEX) and list its members.

    python3 tools/sclib.py <library.lib>                # every member and its symbols
    python3 tools/sclib.py <library.lib> --symbol foo   # the member defining foo
    python3 tools/sclib.py <library.lib> --size 50      # members of exactly 50 bytes

`sc.lib` is not an `ar` archive. Each block is HUNK_LIB (0x3FA), a longword
count, a body of concatenated hunks with NO HUNK_UNIT or HUNK_END between
units, then HUNK_INDEX (0x3FB) naming the units and their symbols. A file holds
one or more such blocks -- sc.lib 6.51 holds two. vlink reads the format
natively, so nothing here is needed to LINK the library. It is needed to answer
a different question: which routine in `modules/submodules/` is which member.

WHY A RAW BYTE SEARCH IS NOT ENOUGH. AGENTS.md records that the relocation-free
routines in `submodules/` appear verbatim in sc.lib, and that the 5% figure is a
floor rather than a ceiling. It is a floor because a reference extracted from
the LINKED binary has its addresses baked in, while a library member holds zeros
plus a relocation list. Any routine carrying a relocation fails a verbatim
search even when it is the same code. The honest test masks the patched fields,
and that needs the member's own relocation offsets and WIDTHS.

The width matters. sc.lib is built for the near-data model, so its commonest
relocation is DREL16 -- an A4-relative 16-bit displacement. Masking four bytes
there would hide two bytes of real opcode and turn a mismatch into a false
match.

Symbol definitions live in the INDEX, not in a HUNK_EXT in the body, so a parser
that only walks the body finds 528 hunks and zero symbols.
"""
import struct
import sys

HUNK_CODE, HUNK_DATA, HUNK_BSS = 0x3E9, 0x3EA, 0x3EB
HUNK_RELOC32, HUNK_RELOC16, HUNK_RELOC8 = 0x3EC, 0x3ED, 0x3EE
HUNK_EXT, HUNK_SYMBOL, HUNK_DEBUG, HUNK_END = 0x3EF, 0x3F0, 0x3F1, 0x3F2
HUNK_UNIT, HUNK_NAME = 0x3E7, 0x3E8
HUNK_LIB, HUNK_INDEX = 0x3FA, 0x3FB
HUNK_DREL32, HUNK_DREL16, HUNK_DREL8 = 0x3F7, 0x3F8, 0x3F9

RELOC_WIDTH = {
    HUNK_RELOC32: 4, HUNK_RELOC16: 2, HUNK_RELOC8: 1,
    HUNK_DREL32: 4, HUNK_DREL16: 2, HUNK_DREL8: 1,
}
REF_WIDTH = {129: 4, 131: 2, 132: 1}     # REF32 / REF16 / REF8
EXT_DEFS = (0, 1, 2, 3)


class Member(object):
    """One hunk of one library unit."""

    def __init__(self):
        self.unit = ''
        self.name = ''
        self.kind = ''
        self.data = b''
        self.relocs = set()       # (byte offset, width in bytes)
        self.defs = {}            # symbol -> byte offset within the hunk
        self.refs = set()

    def __repr__(self):
        return '<%s %s %d bytes>' % (self.unit, self.name, len(self.data))


def _body_hunks(d, start, end):
    """Walk a HUNK_LIB body. Returns {longword offset: (kind, data, relocs)}."""
    out = {}
    i = start
    cur = None
    while i < end:
        t = struct.unpack('>I', d[i:i + 4])[0] & 0x3FFFFFFF
        here = (i - start) // 4
        i += 4
        if t in (HUNK_CODE, HUNK_DATA):
            n = struct.unpack('>I', d[i:i + 4])[0]
            i += 4
            cur = ['CODE' if t == HUNK_CODE else 'DATA', d[i:i + n * 4], set()]
            out[here] = cur
            i += n * 4
        elif t == HUNK_BSS:
            n = struct.unpack('>I', d[i:i + 4])[0]
            i += 4
            cur = ['BSS', b'\0' * (n * 4), set()]
            out[here] = cur
        elif t in RELOC_WIDTH:
            w = RELOC_WIDTH[t]
            while True:
                c = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if c == 0:
                    break
                i += 4
                for _ in range(c):
                    off = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    if cur is not None:
                        cur[2].add((off, w))
        elif t == HUNK_EXT:
            while True:
                w = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w == 0:
                    break
                kind, ln = w >> 24, w & 0xFFFFFF
                i += ln * 4
                if kind in EXT_DEFS:
                    i += 4
                elif kind == 130:
                    i += 4
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4 + c * 4
                else:
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    for _ in range(c):
                        off = struct.unpack('>I', d[i:i + 4])[0]
                        i += 4
                        if cur is not None and kind in REF_WIDTH:
                            cur[2].add((off, REF_WIDTH[kind]))
        elif t == HUNK_SYMBOL:
            while True:
                w = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w == 0:
                    break
                i += (w & 0xFFFFFF) * 4 + 4
        elif t == HUNK_DEBUG:
            n = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + n * 4
        elif t == HUNK_END:
            pass
        elif t in (HUNK_UNIT, HUNK_NAME):
            n = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + n * 4
        else:
            break
    return out


def _parse_units(d):
    """A library that is just object units concatenated: HUNK_UNIT ... HUNK_END.

    amiga.lib and small.lib use this rather than HUNK_LIB, and their symbols
    live in HUNK_EXT inside each unit instead of in an index. A parser written
    only for HUNK_LIB reports 0 members on them, which reads exactly like an
    empty library.
    """
    members = []
    i = 0
    n = len(d)
    unit = ''
    cur = None
    while i + 4 <= n:
        t = struct.unpack('>I', d[i:i + 4])[0] & 0x3FFFFFFF
        i += 4
        if t == HUNK_UNIT:
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4
            unit = d[i:i + ln * 4].rstrip(b'\0').decode('latin1')
            i += ln * 4
            cur = None
        elif t == HUNK_NAME:
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + ln * 4
        elif t in (HUNK_CODE, HUNK_DATA, HUNK_BSS):
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4
            cur = Member()
            cur.unit = unit
            cur.kind = {HUNK_CODE: 'CODE', HUNK_DATA: 'DATA', HUNK_BSS: 'BSS'}[t]
            if t == HUNK_BSS:
                cur.data = b'\0' * (ln * 4)
            else:
                cur.data = d[i:i + ln * 4]
                i += ln * 4
            members.append(cur)
        elif t in RELOC_WIDTH:
            w = RELOC_WIDTH[t]
            while i + 4 <= n:
                c = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if c == 0:
                    break
                i += 4
                for _ in range(c):
                    off = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    if cur is not None:
                        cur.relocs.add((off, w))
        elif t == HUNK_EXT:
            while i + 4 <= n:
                w = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w == 0:
                    break
                kind, ln = w >> 24, w & 0xFFFFFF
                name = d[i:i + ln * 4].rstrip(b'\0').decode('latin1')
                i += ln * 4
                if kind in EXT_DEFS:
                    val = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    if cur is not None:
                        cur.defs[name] = val
                elif kind == 130:
                    i += 4
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4 + c * 4
                    if cur is not None:
                        cur.refs.add(name)
                else:
                    c = struct.unpack('>I', d[i:i + 4])[0]
                    i += 4
                    for _ in range(c):
                        off = struct.unpack('>I', d[i:i + 4])[0]
                        i += 4
                        if cur is not None and kind in REF_WIDTH:
                            cur.relocs.add((off, REF_WIDTH[kind]))
                    if cur is not None:
                        cur.refs.add(name)
        elif t == HUNK_SYMBOL:
            while i + 4 <= n:
                w = struct.unpack('>I', d[i:i + 4])[0]
                i += 4
                if w == 0:
                    break
                i += (w & 0xFFFFFF) * 4 + 4
        elif t == HUNK_DEBUG:
            ln = struct.unpack('>I', d[i:i + 4])[0]
            i += 4 + ln * 4
        elif t == HUNK_END:
            cur = None
        else:
            break
    for m in members:
        if not m.name:
            m.name = m.kind.lower()
    return members


def parse(path):
    """Every member of every HUNK_LIB block in the file."""
    d = open(path, 'rb').read()
    if len(d) >= 4 and struct.unpack('>I', d[0:4])[0] == HUNK_UNIT:
        return _parse_units(d)
    members = []
    pos = 0
    while pos + 8 <= len(d):
        if struct.unpack('>I', d[pos:pos + 4])[0] != HUNK_LIB:
            break
        nbody = struct.unpack('>I', d[pos + 4:pos + 8])[0]
        bstart = pos + 8
        bend = bstart + nbody * 4
        hunks = _body_hunks(d, bstart, bend)

        if struct.unpack('>I', d[bend:bend + 4])[0] != HUNK_INDEX:
            break
        isize = struct.unpack('>I', d[bend + 4:bend + 8])[0]
        p = bend + 8
        strsize = struct.unpack('>H', d[p:p + 2])[0]
        sb = d[p + 2:p + 2 + strsize]

        def name_at(o):
            if o >= len(sb):
                return ''
            e = sb.find(b'\0', o)
            return sb[o:e if e >= 0 else len(sb)].decode('latin1')

        q = p + 2 + strsize
        iend = bend + 8 + isize * 4

        def u16():
            nonlocal q
            v = struct.unpack('>H', d[q:q + 2])[0]
            q += 2
            return v

        while q + 6 <= iend:
            unm = u16()
            first = u16()
            nh = u16()
            if nh == 0 and unm == 0:
                break
            unit = name_at(unm)
            off = first
            for _ in range(nh):
                if q + 8 > iend:
                    break
                hn, hsz, ht = u16(), u16(), u16()
                m = Member()
                m.unit = unit
                m.name = name_at(hn)
                got = hunks.get(off)
                if got:
                    m.kind, m.data, m.relocs = got[0], got[1], got[2]
                nref = u16()
                for _ in range(nref):
                    r = name_at(u16())
                    if r:
                        m.refs.add(r)
                ndef = u16()
                for _ in range(ndef):
                    dn, dv, dt = u16(), u16(), u16()
                    m.defs[name_at(dn)] = dv
                members.append(m)
                off += hsz + 2      # hunk header longwords carry the next offset
            q = q
        pos = iend
    return members


def masked_equal(ref, mem, relocs):
    """True when ref and mem agree outside the fields a relocation patches."""
    if len(ref) != len(mem):
        return False
    skip = set()
    for off, wid in relocs:
        for k in range(off, min(off + wid, len(ref))):
            skip.add(k)
    for k in range(len(ref)):
        if k not in skip and ref[k] != mem[k]:
            return False
    return True


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    members = parse(sys.argv[1])
    if '--symbol' in sys.argv:
        want = sys.argv[sys.argv.index('--symbol') + 1]
        hit = [m for m in members if want in m.defs]
        if not hit:
            print('%s: not defined in this library' % want)
            return 1
        for m in hit:
            print('%s :: %s  %s  %d bytes, %d reloc field(s), symbol at +%d'
                  % (m.unit, m.name, m.kind, len(m.data), len(m.relocs), m.defs[want]))
            print('  defines: %s' % ', '.join(sorted(m.defs)))
            if m.refs:
                print('  refs:    %s' % ', '.join(sorted(m.refs)))
        return 0
    if '--size' in sys.argv:
        n = int(sys.argv[sys.argv.index('--size') + 1])
        for m in members:
            if len(m.data) == n:
                print('%-20s %-10s %5d bytes  %s'
                      % (m.unit, m.name, len(m.data), ', '.join(sorted(m.defs))))
        return 0
    print('%d member hunk(s)' % len(members))
    for m in members:
        if m.defs:
            print('  %-18s %-9s %6d bytes %3d reloc  %s'
                  % (m.unit, m.name, len(m.data), len(m.relocs),
                     ', '.join(sorted(m.defs))))
    return 0


if __name__ == '__main__':
    sys.exit(main())
