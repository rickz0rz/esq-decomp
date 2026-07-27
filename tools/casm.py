#!/usr/bin/env python3
"""Side-by-side disassembly of a restoration against its reference, with the
byte delta itemised per differing hunk.

    python3 tools/casm.py <file.c> <FunctionLabel> [extra sc options]

`cdiff.sh` reports *where* two byte strings differ; it cannot say what the
difference costs, because once the lengths diverge every later region is
misaligned. This aligns the two instruction streams instead, so each hunk comes
with its own ref/got byte counts -- which is exactly the itemisation AGENTS.md
asks for when a restoration does not land on the original's size.

Alignment is done on instruction *shape* (mnemonic plus operand kinds), not on
exact text, so a register-allocation difference lines up as one hunk rather than
desynchronising the rest of the function. Absolute addresses and PC-relative
displacements are blanked for the same reason -- they are relocated fields and
carry no information about codegen.

Needs capstone with M68K support:

    python3 -m venv /tmp/.capvenv && /tmp/.capvenv/bin/pip install capstone
    /tmp/.capvenv/bin/python tools/casm.py ...
"""
import difflib
import os
import re
import subprocess
import sys

try:
    import capstone
except ImportError:
    sys.exit(__doc__.strip().rsplit('\n\n', 1)[-1] +
             '\n\ncapstone not importable from this interpreter.')

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def refbytes(label):
    out = subprocess.run([sys.executable, os.path.join(ROOT, 'tools', 'refbytes.py'), label],
                         capture_output=True, text=True).stdout
    m = re.search(r'^bytes: (\S+)', out, re.M)
    if not m:
        sys.exit(f'no reference bytes for {label}')
    return bytes.fromhex(m.group(1))


def gotbytes(cfile, label, opts):
    out = subprocess.run([os.path.join(ROOT, 'tools', 'cmatch.sh'), cfile, label] + opts,
                         capture_output=True, text=True).stdout
    if 'COMPILE FAILED' in out:
        sys.exit(out)
    m = re.search(r'^\s*got (\S+)', out, re.M)
    if m:
        return bytes.fromhex(m.group(1))
    m = re.search(r'^MATCH', out, re.M)
    if m:                       # identical, so the reference is also the output
        return refbytes(label)
    sys.exit(out or 'no output from cmatch.sh')


def disasm(code):
    md = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_M68K_000)
    rows, off = [], 0
    for insn in md.disasm(code, 0):
        rows.append((insn.address, insn.size, insn.mnemonic, insn.op_str,
                     code[insn.address:insn.address + insn.size].hex()))
        off = insn.address + insn.size
    if off < len(code):          # trailing bytes capstone would not decode
        rows.append((off, len(code) - off, '.byte', code[off:].hex(), code[off:].hex()))
    return rows


# Operand text with the parts that cannot be compared removed: absolute
# addresses and branch/PC displacements are relocated or layout-dependent.
def shape(mnemonic, ops):
    s = re.sub(r'\$[0-9a-f]+', '#', ops)
    s = re.sub(r'\b[ad]\d\b', 'r', s)
    return mnemonic + ' ' + s


def main():
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    cfile, label, opts = sys.argv[1], sys.argv[2], sys.argv[3:]
    ref, got = refbytes(label), gotbytes(cfile, label, opts)
    # cmatch strips alignment padding only when it makes the lengths agree; do
    # not strip here, but do call it out so the totals are not misread.
    pad = got[-2:].hex() in ('4e71', '0000') and len(got) % 4 == 0

    rrows, grows = disasm(ref), disasm(got)
    rkeys = [shape(m, o) for _, _, m, o, _ in rrows]
    gkeys = [shape(m, o) for _, _, m, o, _ in grows]

    print(f'{label}:  ref {len(ref)}  got {len(got)}  ({len(got) - len(ref):+d})'
          + ('   [got includes 2 bytes of alignment padding]' if pad else ''))
    print()

    total = 0
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, rkeys, gkeys, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        rb = sum(r[1] for r in rrows[i1:i2])
        gb = sum(g[1] for g in grows[j1:j2])
        total += gb - rb
        print(f'@ ref 0x{rrows[i1][0] if i1 < len(rrows) else len(ref):04x}'
              f'   ref {rb:3d}  got {gb:3d}   {gb - rb:+d}   (running {total:+d})')
        for a, s, m, o, h in rrows[i1:i2]:
            print(f'    ref  {h:<12} {m} {o}')
        for a, s, m, o, h in grows[j1:j2]:
            print(f'    got  {h:<12} {m} {o}')
        print()

    print(f'itemised total {total:+d}'
          + ('  -- MATCHES the byte delta' if total == len(got) - len(ref)
             else f'  -- byte delta is {len(got) - len(ref):+d}, so something is unattributed'))


if __name__ == '__main__':
    main()
