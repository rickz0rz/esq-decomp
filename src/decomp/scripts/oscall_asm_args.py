#!/usr/bin/env python3
"""
oscall_asm_args.py <FUNC>  -- show each JSR _LVOxxx(A6) in a function's ORIGINAL
ASM with its arguments resolved to symbolic (parameter-relative) expressions, so
the restored C call args can be written faithfully.

Traces a simple register model through the sliced ASM:
  - prologue MOVEM.L saved regs; MOVE(A).L off(A7),reg -> reg = param@off
  - MOVE(A).L src,dst ; MOVEQ/MOVE.L #imm,reg ; ADDQ/SUBQ #k,reg ; MOVEA.L Glob,A6
For each library call, prints the arg registers (from the SAS/C pragma reg spec)
and their traced values. Unknown values print as the raw source.
"""
import glob
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
PRAGMA_DIR = "/Users/RJ/Downloads/SAS-C-hdd/sc/include/pragmas"
REGNAME = [f"D{i}" for i in range(8)] + [f"A{i}" for i in range(8)]


def pragma_regs():
    out = {}
    for p in glob.glob(os.path.join(PRAGMA_DIR, "*_pragmas.h")):
        for line in open(p, encoding="utf-8", errors="replace"):
            m = re.match(r'#pragma\s+(?:syscall|libcall)\s+(?:\w+\s+)?'
                         r'(\w+)\s+[0-9a-fA-F]+\s+([0-9a-fA-F]+)\s*$', line)
            if m:
                out.setdefault(m.group(1), m.group(2))
    return out


def decode(regstring):
    c = int(regstring[-1], 16)
    if c == 0:
        return []
    d = regstring[:c]
    return [REGNAME[int(d[c - 1 - i], 16)] for i in range(c)]


def find_slice(func):
    for p in glob.glob(os.path.join(ROOT, "src/modules/**/*.s"), recursive=True):
        txt = open(p, encoding="utf-8", errors="replace").read()
        if re.search(r'^' + re.escape(func) + r':', txt, re.M):
            out, started = [], False
            for ln in txt.splitlines():
                if not started:
                    if re.match(r'^' + re.escape(func) + r':', ln):
                        started = True
                    else:
                        continue
                if re.match(r'^;!=+', ln):
                    break
                out.append(ln)
            return p, out
    return None, []


def main():
    func = sys.argv[1]
    prag = pragma_regs()
    path, body = find_slice(func)
    if not body:
        print(f"no ASM slice for {func}"); return
    print(f"# {func}  ({os.path.relpath(path, ROOT)})")
    reg = {}                      # reg -> symbolic value string
    for raw in body:
        s = re.sub(r';.*$', '', raw).strip()
        if not s:
            continue
        m = re.match(r'MOVE[A]?\.[LWB]\s+(\S+),(A\d|D\d)$', s)
        if m:
            src, dst = m.group(1), m.group(2)
            v = None
            mm = re.match(r'(\d+)\(A7\)$', src)
            if mm:
                v = f"@{src}"                       # param at stack offset
            elif re.match(r'#', src):
                v = src[1:]
            elif src in reg:
                v = reg[src]
            elif re.match(r'[A-Za-z_]\w*$', src):
                v = src                              # a global symbol
            else:
                v = src
            reg[dst] = v
            continue
        m = re.match(r'MOVEQ(?:\.L)?\s+#(\S+),(D\d)$', s)
        if m:
            reg[m.group(2)] = m.group(1); continue
        m = re.match(r'(ADDQ|SUBQ|ADD|SUB)\.[LWB]\s+#(\w+),(A\d|D\d)$', s)
        if m:
            op, k, r = m.group(1), m.group(2), m.group(3)
            base = reg.get(r, r)
            sign = '+' if op.startswith('ADD') else '-'
            reg[r] = f"({base} {sign} {k})"
            continue
        m = re.match(r'LEA\s+(\S+),(A\d)$', s)
        if m:
            reg[m.group(2)] = f"&{m.group(1)}"; continue
        m = re.match(r'JSR\s+(_LVO[A-Za-z0-9]+)\(A6\)$', s)
        if m:
            fn = m.group(1)
            regs = decode(prag.get(fn[4:], "0")) if fn[4:] in prag else ["?"]
            args = [reg.get(r, "?") + f"[{r}]" for r in regs]
            base = reg.get("A6", "?")
            print(f"  {fn}(base={base}; " + ", ".join(args) + ")")
    # show which stack offsets were used (param mapping hint)
    offs = sorted(set(re.findall(r'@(\d+)\(A7\)', "\n".join(
        f"{v}" for v in reg.values() if isinstance(v, str)))))
    if offs:
        print("  # param stack offsets seen: " + ", ".join(offs + ["(after MOVEM save)"]))


if __name__ == "__main__":
    main()
