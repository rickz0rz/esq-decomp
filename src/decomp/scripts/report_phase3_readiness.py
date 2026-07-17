#!/usr/bin/env python3
"""
report_phase3_readiness.py -- inventory the scaffolding a whole-program SAS/C
link (Phase 3) must provide.

Scans every restored SAS/C .c file, collects:
  - functions DEFINED by the corpus
  - symbols REFERENCED via `extern ...` declarations

Any referenced extern NOT defined by the corpus is a scaffolding gap. We bucket
gaps into:
  DATA    defined as a label in src/data/*.s  -> provide a data segment
  OSLIB   an AmigaOS library call / base       -> provided by amiga.lib / stubs
  OTHER   unresolved elsewhere                  -> needs investigation

Read-only, static (no vamos).
"""
import glob
import os
import re
from collections import defaultdict

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SASC = os.path.join(ROOT, "src", "decomp", "sas_c")
DATA = os.path.join(ROOT, "src", "data")

OSLIB_HINTS = re.compile(
    r'^(Open|Close|Alloc|Free|Wait|Signal|Do|Send|Get|Put|Find|Read|Write|'
    r'Seek|Lock|UnLock|Examine|Delay|Move|Text|SetAPen|SetBPen|RectFill|'
    r'BltBitMap|WritePixel|AllocMem|FreeMem|AllocSignal|FindTask|SystemTagList|'
    r'RawDoFmt|CreatePort|DeletePort|typeof)', re.IGNORECASE)


def load_data_symbols():
    """labels from src/data + hardware regs + LVO offsets + Prevue.asm equates
    (A4 globals) — everything a whole-program link resolves from the data/equate
    side rather than from the restored C corpus."""
    syms = set()
    paths = glob.glob(os.path.join(DATA, "*.s"))
    paths += [os.path.join(ROOT, "src", "hardware-addresses.s"),
              os.path.join(ROOT, "src", "lvo-offsets.s"),
              os.path.join(ROOT, "src", "Prevue.asm")]
    for path in paths:
        if not os.path.exists(path):
            continue
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = re.match(r'^([A-Za-z_]\w*)\s*:', line)          # label
                if m:
                    syms.add(m.group(1))
                m = re.match(r'^([A-Za-z_]\w*)\s*=', line)          # equate
                if m:
                    syms.add(m.group(1))
    return syms


def main():
    data_syms = load_data_symbols()
    defined = set()
    referenced = defaultdict(list)   # symbol -> [files]
    files = sorted(glob.glob(os.path.join(SASC, "*.c")))
    def_rx = re.compile(
        r'^[A-Za-z_][\w \t\*]*?\b([A-Za-z_]\w*)\s*\([^;{]*\)\s*\{', re.MULTILINE)
    extern_rx = re.compile(
        r'\bextern\b[^;]*?\b([A-Za-z_]\w*)\s*(?:\[|\(|;|,)')

    for path in files:
        src = open(path, encoding="utf-8", errors="replace").read()
        # strip comments crudely
        src = re.sub(r'/\*.*?\*/', '', src, flags=re.DOTALL)
        src = re.sub(r'//[^\n]*', '', src)
        for m in def_rx.finditer(src):
            defined.add(m.group(1))
        for line in src.splitlines():
            if 'extern' in line:
                for m in extern_rx.finditer(line):
                    referenced[m.group(1)].append(os.path.basename(path))

    gaps = {s: fs for s, fs in referenced.items() if s not in defined}
    buckets = defaultdict(list)
    for s in gaps:
        if s in data_syms:
            buckets["DATA"].append(s)
        elif OSLIB_HINTS.match(s):
            buckets["OSLIB"].append(s)
        else:
            buckets["OTHER"].append(s)

    print("=" * 66)
    print("PHASE-3 WHOLE-PROGRAM LINK READINESS")
    print("=" * 66)
    print(f"restored .c files scanned : {len(files)}")
    print(f"functions defined         : {len(defined)}")
    print(f"distinct externs referenced: {len(referenced)}")
    print(f"UNRESOLVED externs (gaps) : {len(gaps)}\n")
    for b in ("DATA", "OSLIB", "OTHER"):
        items = sorted(buckets[b])
        note = {"DATA": "-> provide from src/data segment",
                "OSLIB": "-> amiga.lib / OS stubs",
                "OTHER": "-> needs investigation (other fns/globals)"}[b]
        print(f"  {b:<6} {len(items):4d}   {note}")
    print("\n  OTHER sample (top scaffolding unknowns):")
    for s in sorted(buckets["OTHER"])[:25]:
        print(f"    {s}   (in {gaps[s][0]}{'...' if len(gaps[s])>1 else ''})")


if __name__ == "__main__":
    main()
