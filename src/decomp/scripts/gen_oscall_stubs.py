#!/usr/bin/env python3
"""
gen_oscall_stubs.py -- generate callable library-call stubs so the restorations'
_LVOxxx(base, args...) calls become real Amiga library calls (JSR offset(A6))
instead of jumping to the offset constant (which crashes).

Data sources (both in-tree / in the SAS/C install):
  - src/lvo-offsets.s                       : _LVOxxx = <negative offset>
  - SAS/C .../include/pragmas/*_pragmas.h    : #pragma {syscall|libcall} [Base]
        Name <hexoffset> <regstring>

Decoded pragma regstring (verified against 9 known functions):
  regstring = [argN][arg{N-1}]...[arg1][0][count]   (hex nibbles, args reversed)
  nibble 0-7 = D0-D7, 8-F = A0-A7 ; last digit = number of args.

Stub ABI (base-first): the restoration passes the library base as the FIRST C
arg, then the logical args:  _LVOxxx(base, a1, a2, ...).
  __LVOxxx:  MOVE.L 4(A7),A6 ; base
             MOVE.L 8(A7),<r1> ; a1  (12(A7)->r2, ...)
             JSR    _LVOxxx(A6)
             RTS
Emits the stubs .s plus a report of which functions/files still need caller
normalization (no-base or skeleton call sites).
"""
import glob
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SASC = os.path.join(ROOT, "src", "decomp", "sas_c")
PRAGMA_DIR = "/Users/RJ/Downloads/SAS-C-hdd/sc/include/pragmas"
REGNAME = [f"D{i}" for i in range(8)] + [f"A{i}" for i in range(8)]


def lvo_offsets():
    off = {}
    for line in open(os.path.join(ROOT, "src", "lvo-offsets.s"),
                     encoding="utf-8", errors="replace"):
        m = re.match(r'^(_LVO[A-Za-z0-9]+)\s*=\s*(-?\w+)', line)
        if m:
            off[m.group(1)] = m.group(2)
    return off


def pragma_regs():
    """map plain FuncName -> (offset_hex, regstring) from all pragma headers."""
    out = {}
    for p in glob.glob(os.path.join(PRAGMA_DIR, "*_pragmas.h")):
        for line in open(p, encoding="utf-8", errors="replace"):
            m = re.match(r'#pragma\s+(?:syscall|libcall)\s+(?:\w+\s+)?'
                         r'(\w+)\s+([0-9a-fA-F]+)\s+([0-9a-fA-F]+)\s*$', line)
            if m:
                out.setdefault(m.group(1), (m.group(2), m.group(3)))
    return out


def decode_regs(regstring):
    """-> list of register names for arg1..argN (order as called)."""
    count = int(regstring[-1], 16)
    if count == 0:
        return []
    argdigits = regstring[:count]          # [argN ... arg1]
    return [REGNAME[int(argdigits[count - 1 - i], 16)] for i in range(count)]


def used_lvo_funcs():
    funcs = set()
    for p in glob.glob(os.path.join(SASC, "*.c")):
        src = open(p, encoding="utf-8", errors="replace").read()
        for m in re.finditer(r'\b(_LVO[A-Za-z0-9]+)\s*\(', src):
            funcs.add(m.group(1))
    return sorted(funcs)


def main():
    off = lvo_offsets()
    prag = pragma_regs()
    funcs = used_lvo_funcs()
    stubs = []
    missing = []
    for f in funcs:
        plain = f[4:]                      # strip _LVO
        if f not in off or plain not in prag:
            missing.append((f, f not in off, plain not in prag))
            continue
        _, regstring = prag[plain]
        regs = decode_regs(regstring)
        stubs.append((f, off[f], regs))

    out = os.path.join(ROOT, "build/decomp/phase3/oscall_stubs.s")
    with open(out, "w") as fh:
        fh.write("    SECTION text,CODE\n")
        fh.write('    include "lvo-offsets.s"\n')
        for f, offset, regs in stubs:
            fh.write(f"    XDEF _{f}\n")           # C call target is _<_LVOxxx>
        for f, offset, regs in stubs:
            fh.write(f"_{f}:\n")                    # e.g. __LVOOpenLibrary
            fh.write("    MOVE.L  4(A7),A6\n")       # base
            for i, r in enumerate(regs):
                fh.write(f"    MOVE.L  {8 + 4*i}(A7),{r}\n")
            fh.write(f"    JSR     {f}(A6)\n")       # JSR _LVOxxx(A6) = -off(A6)
            fh.write("    RTS\n")
        fh.write("    END\n")

    print(f"generated {len(stubs)} stubs -> {out}")
    if missing:
        print(f"NO pragma/offset for {len(missing)}: "
              + ", ".join(m[0] for m in missing))
    # sample
    for f, offset, regs in stubs[:8]:
        print(f"  {f} off={offset} regs={regs}")


if __name__ == "__main__":
    main()
