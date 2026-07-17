#!/usr/bin/env python3
"""
report_incomplete_oscalls.py -- work queue for the OS-call restoration.

A restored _LVOxxx() callsite is INCOMPLETE if its argument count is below the
function's true arity (= 1 base + N library args, N from the SAS/C pragma). Lists
the .c files with incomplete callsites, worst first, so they can be restored from
the original ASM.

  report_incomplete_oscalls.py            # summary table (files, counts)
  report_incomplete_oscalls.py <file.c>   # per-callsite detail for one file
"""
import glob
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SASC = os.path.join(ROOT, "src", "decomp", "sas_c")
PRAGMA_DIR = "/Users/RJ/Downloads/SAS-C-hdd/sc/include/pragmas"


def true_arities():
    """_LVOxxx -> base+argcount (from pragma regstring last hex digit)."""
    ar = {}
    for p in glob.glob(os.path.join(PRAGMA_DIR, "*_pragmas.h")):
        for line in open(p, encoding="utf-8", errors="replace"):
            m = re.match(r'#pragma\s+(?:syscall|libcall)\s+(?:\w+\s+)?'
                         r'(\w+)\s+[0-9a-fA-F]+\s+([0-9a-fA-F]+)\s*$', line)
            if m:
                ar["_LVO" + m.group(1)] = 1 + int(m.group(2)[-1], 16)
    return ar


def callsites(src):
    """yield (func, argcount, rawargs) for each _LVOxxx( ... ) call/decl."""
    for m in re.finditer(r'\b(_LVO[A-Za-z0-9]+)\s*\(([^)]*)\)', src):
        a = m.group(2).strip()
        n = 0 if a in ("", "void") else a.count(',') + 1
        yield m.group(1), n, a


def main():
    ar = true_arities()
    if len(sys.argv) > 1:
        p = os.path.join(SASC, os.path.basename(sys.argv[1]))
        src = open(p, encoding="utf-8", errors="replace").read()
        print(f"== {os.path.basename(p)} ==")
        for f, n, raw in callsites(src):
            t = ar.get(f, "?")
            flag = "INCOMPLETE" if isinstance(t, int) and n < t else "ok"
            print(f"  {f}({raw})  arity={n} true={t}  {flag}")
        return

    rows = []
    for p in sorted(glob.glob(os.path.join(SASC, "*.c"))):
        src = open(p, encoding="utf-8", errors="replace").read()
        inc = 0
        for f, n, raw in callsites(src):
            t = ar.get(f)
            if t is not None and n < t:
                inc += 1
        if inc:
            rows.append((inc, os.path.basename(p)))
    rows.sort(reverse=True)
    total = sum(r[0] for r in rows)
    print(f"files with incomplete OS callsites: {len(rows)}   "
          f"total incomplete callsites: {total}\n")
    for inc, name in rows[:60]:
        print(f"  {inc:3d}  {name}")
    if len(rows) > 60:
        print(f"  ... +{len(rows)-60} more files")


if __name__ == "__main__":
    main()
