#!/usr/bin/env python3
"""Emit a hunk object that marks an output section CHIP, and adds no bytes.

    python3 tools/mkchipflag.py out.o S_1

`src/Prevue.asm` declares the data section `SECTION S_1,DATA,CHIP`, so the DATA
hunk carries MEMF_CHIP and the custom chips can DMA from it. The copper lists
and the bitplanes live there.

A C object cannot say that. SAS/C emits a plain `data` hunk with no memory
attribute, so a build that replaces DATA modules with C loses the flag: all 50
data modules are C today, nothing contributes CHIP, and the DATA hunk links as
MEMF_ANY. The program then loads its data into fast RAM on any machine that has
fast RAM, and the display reads nothing.

Nothing in the toolchain reports this. Both byte gates ignore a C build, and the
link succeeds -- `hunkcmp.py` is the only thing that sees it, as `mem: 1 vs 0`.

vlink merges input sections by name and ORs their memory attributes, so one
input section named S_1 with the CHIP bit is enough. Two ways to supply it were
measured and only this one is free:

  - An assembly stub `SECTION S_1,DATA,CHIP` with no content: vasm drops the
    empty section and emits a size-0 CODE hunk instead, which does nothing.
  - The same stub with a `DC.W 0` in it: the flag arrives, and so do the bytes.
    On the DATA side bytes are not inert -- growth moves every symbol after the
    insertion point. See AGENTS.md, "ONLY convert a module that is
    LAYOUT-NEUTRAL".

So this writes the object by hand, the way tools/mkabsdefs.py does: a HUNK_DATA
of length ZERO with the CHIP bit set in its type longword. Measured: the linked
output is byte-identical with and without it, and the size-table entry goes
0x00000001 -> 0x40000001.

Appending it to a build whose data is still assembly is a no-op, because CHIP
OR CHIP is CHIP. That is why the build passes it unconditionally rather than
guessing whether the current manifest needs it.
"""
import struct
import sys

HUNK_UNIT, HUNK_NAME, HUNK_DATA, HUNK_END = 0x3E7, 0x3E8, 0x3EA, 0x3F2
MEMF_CHIP = 0x40000000


def hunk_string(s):
    """Longword-count prefix followed by the NUL-padded name."""
    b = s.encode('ascii')
    pad = (-len(b)) % 4
    return struct.pack('>I', (len(b) + pad) // 4) + b + b'\0' * pad


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    out, section = sys.argv[1], sys.argv[2]

    o = struct.pack('>I', HUNK_UNIT) + hunk_string('chipflag')
    o += struct.pack('>I', HUNK_NAME) + hunk_string(section)
    # Length 0: the section exists so its attribute merges, and contributes
    # nothing to the image.
    o += struct.pack('>I', HUNK_DATA | MEMF_CHIP) + struct.pack('>I', 0)
    o += struct.pack('>I', HUNK_END)

    with open(out, 'wb') as f:
        f.write(o)


if __name__ == '__main__':
    main()
