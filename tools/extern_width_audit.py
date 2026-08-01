#!/usr/bin/env python3
"""Compare the WIDTH of every C extern against the width the original uses.

    python3 tools/extern_width_audit.py          # the manifest
    python3 tools/extern_width_audit.py --all    # every restoration

`data_shape_audit.py` answers a different question: whether a symbol IS the data
or POINTS AT it. It cannot see width at all. A C file that declares a word-wide
global as `char` compiles clean, links clean, and reads the WRONG HALF of the
value -- on a 68000 the byte at offset 0 is the HIGH half, so a global holding
142 reads as 0.

That is not hypothetical. `script_prime_banner_transition_from_hex_code.c`
declared `CONFIG_BannerCopperHeadByte` as `unsigned char` where eleven other
restorations declare it `short`. It read 0 for 142 and primed every banner
transition toward character 0. In the maximum-C build the guide body stopped
repainting after the ESC menu closed, and no byte check could see it: the
emitted size was smaller by 2 and the file was already recorded `behavioural`.

The rule this checks: if the original ever touches a symbol with `.W` or `.L`,
a C declaration one byte wide reads the wrong bytes. Narrower ASSEMBLY access is
fine and common -- `MOVE.B` on a word global is an ordinary cast to char -- so
only the C-narrower-than-assembly direction is reported.

The data section is not the authority here. `CONFIG_BannerCopperHeadByte` is
written `DC.B 0 / DC.B 142`, which looks like two bytes and is one word. What the
CODE does decides it.
"""
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ASM_DIRS = ('src/modules', 'src/data')

# C scalar types that are one byte wide.
BYTE_TYPES = ('char', 'unsigned char', 'signed char', 'UBYTE', 'BYTE')
WORD_TYPES = ('short', 'unsigned short', 'UWORD', 'WORD')

DECL = re.compile(
    r'^\s*extern\s+((?:unsigned\s+|signed\s+)?[A-Za-z_]\w*)\s+([A-Za-z_]\w*)\s*;')

# An operand-sized instruction touching an absolute symbol.
ACCESS = re.compile(r'^\s*([A-Z][A-Z0-9]*)\.([BWL])\s+(.*)$')

# Instructions that take an ADDRESS, not a value. `LEA _X,A0` says nothing about
# how wide _X is, and counting it reported a byte global as long-wide.
ADDR_OPS = ('LEA', 'PEA')

# Symbols whose two halves are genuinely addressed apart, or where a byte view is
# deliberate and proven. Each entry needs a reason.
BENIGN = {
    # Interleaved RGB triples: three views one byte apart into the same array.
    'WDISP_PaletteTriplesRBase', 'WDISP_PaletteTriplesGBase',
    'WDISP_PaletteTriplesBBase',
    'KYBD_CustomPaletteTriplesRBase', 'KYBD_CustomPaletteTriplesGBase',
    'KYBD_CustomPaletteTriplesBBase',
    # DC.W, and ESQ_SetCopperEffectParams writes it MOVE.W. The MOVE.L belongs
    # to ESQ_UpdateCopperListsFromParams in another module, which reads the word
    # and the two bytes after it as one packed long on purpose. Only reported
    # under --all, where a file outside the manifest falls back to program-wide
    # widths.
    'HIGHLIGHT_CopperEffectSeed',
}


def asm_widths(module=None):
    """Map symbol -> set of operand sizes the original uses on it.

    With `module`, read only that source module. A C file must agree with how
    the function IT replaces addresses a global, not with how the rest of the
    program does. `HIGHLIGHT_CopperEffectSeed` is the case that forces this: it
    is a word, and one unrelated routine reads it with MOVE.L across into the
    next symbol on purpose.
    """
    out = {}
    walk = ([(os.path.dirname(os.path.join(ROOT, module)), None,
              [os.path.basename(module)])] if module else None)
    for d in ASM_DIRS:
        for root, _, files in (walk or os.walk(os.path.join(ROOT, d))):
            for fn in files:
                if not fn.endswith('.s'):
                    continue
                p = os.path.join(root, fn)
                if not os.path.exists(p):
                    continue
                for line in open(p, errors='ignore'):
                    line = line.split(';')[0]
                    m = ACCESS.match(line)
                    if not m:
                        continue
                    op, size, operands = m.group(1), m.group(2), m.group(3)
                    if op in ADDR_OPS:
                        continue
                    for field in operands.split(','):
                        field = field.strip()
                        # `#_X` is the address of X as a literal, not a load of X.
                        # `(d16,An)` and `x(An)` are frame or struct access.
                        if field.startswith('#'):
                            continue
                        m2 = re.fullmatch(r'_([A-Za-z]\w*)', field)
                        if m2:
                            out.setdefault(m2.group(1), set()).add(size)
    return out


def manifest_modules():
    """Map C file -> the source module it replaces, from the manifest."""
    out = {}
    p = os.path.join(ROOT, 'src/c/replacements-all.txt')
    if os.path.exists(p):
        for line in open(p):
            parts = line.split('#')[0].split()
            if len(parts) >= 2:
                out['src/' + parts[1]] = 'src/' + parts[0]
    return out


def c_files(all_files, mods):
    if all_files:
        d = os.path.join(ROOT, 'src/c')
        return sorted(os.path.join('src/c', f)
                      for f in os.listdir(d) if f.endswith('.c'))
    return sorted(mods)


def main():
    mods = manifest_modules()
    program_wide = asm_widths()
    per_module = {}
    bad = []
    for rel in c_files('--all' in sys.argv, mods):
        path = os.path.join(ROOT, rel)
        if not os.path.exists(path):
            continue
        body = open(path, errors='ignore').read()
        mod = mods.get(rel)
        if mod and os.path.exists(os.path.join(ROOT, mod)):
            if mod not in per_module:
                per_module[mod] = asm_widths(mod)
            widths = per_module[mod]
        else:
            widths = program_wide
        for line in body.splitlines():
            m = DECL.match(line)
            if not m:
                continue
            ctype, name = ' '.join(m.group(1).split()), m.group(2)
            if name in BENIGN:
                continue
            # Every use is `&NAME`: the declared type never reaches the emitted
            # code, because the address of a symbol does not depend on its width.
            uses = re.findall(r'(.?)\b%s\b' % re.escape(name), body)
            if uses and all(prefix == '&' for prefix in uses[1:]):
                continue
            sizes = widths.get(name)
            if not sizes:
                continue
            if ctype in BYTE_TYPES and ('W' in sizes or 'L' in sizes):
                bad.append((rel, name, ctype, ''.join(sorted(sizes))))
            elif ctype in WORD_TYPES and 'L' in sizes:
                bad.append((rel, name, ctype, ''.join(sorted(sizes))))

    for rel, name, ctype, sizes in bad:
        print('%-56s %-38s C=%-14s asm=.%s' % (rel, name, ctype, sizes))
    if bad:
        print('\n%d extern(s) narrower in C than the original addresses them.'
              % len(bad))
        print('A byte view of a word global reads the HIGH half, which is'
              ' usually 0.')
    else:
        print('extern_width_audit: clean')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
