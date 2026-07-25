#!/usr/bin/env python3
"""Emit a hunk object that exports absolute symbols.

    python3 tools/mkabsdefs.py out.o _VPOSR=0xDFF004 _CIAB_PRA=0xBFD000

C restorations reach hardware registers as ordinary externs, because writing
`*(volatile UWORD *)0xDFF004` makes SAS/C emit MOVEA.L #imm,An + MOVE.W (An),Dn
instead of the absolute MOVE.W (xxx).L,Dn the stock binary uses.

Something must then define those symbols, and nothing else can:
  - vasm silently drops `XDEF` of an absolute equate. Verified against EQU, `=`
    and PUBLIC: all three produce an object with no external-definition hunk.
  - `vlink -D` only takes effect while processing a linker script (-T), and
    supplying a script would replace the default layout.

So this writes the object by hand. Symbols are emitted as EXT_ABS, which the
linker resolves by value without generating a relocation -- matching the stock
binary, where the hardware address is baked into the instruction.

The values are asserted against hardware-addresses.s in src/modules/c-exports.s,
so the two cannot drift apart silently.
"""
import struct, sys

HUNK_UNIT, HUNK_NAME, HUNK_CODE, HUNK_EXT, HUNK_END = 0x3E7, 0x3E8, 0x3E9, 0x3EF, 0x3F2
EXT_ABS = 2


def hunk_string(s):
    """Longword-count prefix followed by the NUL-padded name."""
    b = s.encode('ascii')
    pad = (-len(b)) % 4
    return struct.pack('>I', (len(b) + pad) // 4) + b + b'\0' * pad


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    out, defs = sys.argv[1], sys.argv[2:]

    o = struct.pack('>I', HUNK_UNIT) + hunk_string('absdefs')
    o += struct.pack('>I', HUNK_NAME) + hunk_string('S_0')
    o += struct.pack('>I', HUNK_CODE) + struct.pack('>I', 0)    # empty section
    o += struct.pack('>I', HUNK_EXT)
    for d in defs:
        name, _, value = d.partition('=')
        v = int(value, 0)
        nb = name.encode('ascii')
        pad = (-len(nb)) % 4
        o += struct.pack('>I', (EXT_ABS << 24) | ((len(nb) + pad) // 4))
        o += nb + b'\0' * pad
        o += struct.pack('>I', v & 0xFFFFFFFF)
    o += struct.pack('>I', 0)                                   # end of ext block
    o += struct.pack('>I', HUNK_END)

    open(out, 'wb').write(o)
    print(f'  absdefs: {", ".join(defs)} -> {out}')


if __name__ == '__main__':
    main()
