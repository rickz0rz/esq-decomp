#!/usr/bin/env python3
"""Compare every C restoration's PARAMETER COUNT against the argument slots the
original assembly actually reads.

    python3 tools/check_c_signatures.py            # audit all restorations
    python3 tools/check_c_signatures.py ed         # only files matching a prefix

WHY THIS IS WORTH AUTOMATING

A wrong parameter count is invisible to every existing check. The bytes still
compare sanely (cmatch looks at the emitted body, not the convention), both byte
gates stay green, a6_audit only looks at library bases, and the linker cannot
know how many arguments a function wants. But it is a direct cause of the failure
mode that has been hunting this project: the callee reads a slot the caller never
pushed, gets whatever was on the stack, and if that value is used as a pointer or
a branch target the program jumps somewhere arbitrary. That is exactly the shape
of the ESC-menu guru -- a wild jump whose landing site moves with image layout.

HOW THE EXPECTED COUNT IS DERIVED

Two frame conventions appear in this program:

  LINK.W A5,#-n   arguments start at 8(A5), one longword slot each. A byte read
                  at 11(A5) or a word at 14(A5) still belongs to the slot at
                  12(A5), so offsets are rounded down to the slot boundary.

  MOVEM.L r,-(A7) with no LINK: NOT CHECKED, deliberately. In a frameless
                  function the arguments are also at positive d(A7) -- but so are
                  the slots it writes for its OWN callees' arguments
                  (MOVE.L D0,64(A7) and friends). The two are indistinguishable
                  from the disassembly, and treating both as arguments reported
                  18 parameters for a function that takes none. A7-frame
                  functions are counted as unresolved rather than guessed at.

The highest slot touched gives the count. That is a LOWER BOUND, not the truth:
a function may legitimately ignore a trailing argument, and several here do (see
bitmap_process_ilbm_image.c, whose second parameter is never read). So:

  C params  <  slots read   is a REAL BUG -- the callee reads past what C declares
  C params  >  slots read   is only a warning; a declared-but-unused tail
                            parameter is common and often deliberate

Only the first class is reported as an error and sets the exit status.

TWO IDIOMS THIS MUST NOT MISREAD, both learned by it crying wolf:

  VARARGS. `LEA 16(A5),A0` takes the ADDRESS of the slot after the last named
  argument and passes it on -- a printf-style argument-list pointer, not a read
  of an argument. disptext_build_layout_for_source.c is the example: the original
  is (src, fmt, ...) and the C correctly spells the list pointer `&fmt + 1`, so a
  2-parameter signature is right even though slot 2 is touched. An LEA of the
  slot just past the highest MOVE-read slot is therefore treated as varargs and
  excluded.

  A7-ADDRESSED ARGUMENTS IN A FRAMED FUNCTION. A function can have LINK.W A5 and
  still read its arguments off A7 -- _DISPLIB_DisplayTextAtPosition reads
  28/32/36/40(A7) after LINK plus a 4-register MOVEM. Those reads are invisible
  to the A5 scan, so such functions report 0 slots and land in the warning list.
  That is why the warning direction is advisory only and the error direction is
  the sound one.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')

REG_COUNT = {'d': 8, 'a': 8}


def movem_regs(operand):
    """Number of registers in a MOVEM list like 'D2-D7/A2-A3'."""
    n = 0
    for part in operand.split('/'):
        part = part.strip()
        m = re.fullmatch(r'([DA])(\d)-([DA])(\d)', part, re.I)
        if m and m.group(1).upper() == m.group(3).upper():
            n += int(m.group(4)) - int(m.group(2)) + 1
        elif re.fullmatch(r'[DA]\d', part, re.I):
            n += 1
    return n


def ref_asm(label):
    """Reference disassembly, trying both the bare and underscored label.

    Many RESTORES: headers still name the pre-rename label (ED1_DrawStatusLine1
    where the module now defines _ED1_DrawStatusLine1), so a single lookup silently
    skips most of the corpus. Try both spellings.
    """
    for cand in (label, '_' + label.lstrip('_'), label.lstrip('_')):
        try:
            out = subprocess.run([sys.executable, os.path.join(ROOT, 'tools', 'refbytes.py'), cand],
                                 capture_output=True, text=True, timeout=120).stdout
        except Exception:
            continue
        if out.strip() and 'label not found' not in out:
            return out
    return None


def ref_slots(label):
    """Highest argument slot index the reference reads, or None if undetermined."""
    out = ref_asm(label)
    if out is None:
        return None

    if not re.search(r'LINK\.W\s+A5,#', out):
        return None            # frameless: see the module docstring
    read_top, lea_offs = -1, set()
    for line in out.splitlines():
        for m in re.finditer(r'(-?\d+)\(A5(?:,[^)]*)?\)', line):
            d = int(m.group(1))
            if d < 8:
                continue                   # negative offsets are locals
            if re.search(r'\bLEA\b', line):
                lea_offs.add(d)            # candidate varargs list pointer
            else:
                read_top = max(read_top, d)
    # An LEA of the slot immediately past the last real read is a varargs list
    # pointer, not an argument read. Drop it; keep any other LEA.
    if read_top >= 8:
        lea_offs.discard(read_top + 4)
    for d in lea_offs:
        read_top = max(read_top, d)
    return 0 if read_top < 8 else (read_top - 8) // 4 + 1


def c_params(path, fname):
    src = open(path, errors='replace').read()
    src = re.sub(r'/\*.*?\*/', '', src, flags=re.S)
    m = re.search(r'\b' + re.escape(fname) + r'\s*\(([^)]*)\)\s*\{', src)
    if not m:
        return None
    args = m.group(1).strip()
    if args in ('', 'void'):
        return 0
    return len([a for a in args.split(',') if a.strip()])


def main():
    only = sys.argv[1] if len(sys.argv) > 1 else ''
    bad, warn, checked, skipped = [], [], 0, 0
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c') or (only and not fn.startswith(only)):
            continue
        path = os.path.join(CDIR, fn)
        head = open(path, errors='replace').read(4000)
        m = re.search(r'RESTORES:\s*(\S+)', head)
        if not m:
            continue
        label = m.group(1)
        cname = label.lstrip('_')
        want = ref_slots(label)
        got = c_params(path, cname)
        if want is None or got is None:
            skipped += 1
            continue
        checked += 1
        if got < want:
            bad.append((fn, label, want, got))
        elif got > want:
            warn.append((fn, label, want, got))

    if bad:
        print('*** C DECLARES FEWER PARAMETERS THAN THE ORIGINAL READS ***')
        print('The callee reads a stack slot the caller never pushed.\n')
        for fn, label, want, got in bad:
            print(f'  {fn:52s} {label:46s} reads {want} slots, C declares {got}')
        print()
    if warn:
        print(f'({len(warn)} file(s) declare MORE parameters than the reference reads --')
        print(' a trailing unused argument, which is common and often deliberate:)')
        for fn, label, want, got in warn:
            print(f'  {fn:52s} reads {want}, declares {got}')
        print()
    print(f'checked {checked}, skipped {skipped} (label or signature not parseable), '
          f'{len(bad)} error(s), {len(warn)} warning(s)')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
