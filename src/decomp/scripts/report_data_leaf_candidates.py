#!/usr/bin/env python3
"""
report_data_leaf_candidates.py -- find the NEXT harness tier.

A "data-leaf" is a function that makes no calls and touches no A4/OS/chipset,
but references one or more DATA symbols by absolute address (e.g. a lookup
table like WDISP_CharClassTable). These become differentially testable once the
referenced data object is linked into the harness on both sides.

For each candidate we report the required external symbols and, where possible,
which src/data/*.s file defines them (so the harness knows what to link).

Read-only.
"""
import glob
import os
import re
import sys

sys.path.insert(0, os.path.dirname(__file__))
import classify_functions as C  # reuse parsing/slicing/classification

ROOT = C.ROOT
DATA_DIR = os.path.join(ROOT, "src", "data")


def load_data_symbols():
    """map symbol -> defining file, for labels defined under src/data."""
    sym2file = {}
    for path in glob.glob(os.path.join(DATA_DIR, "*.s")):
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                m = re.match(r'^([A-Za-z_][A-Za-z0-9_]*)\s*:', line)
                if m:
                    sym2file.setdefault(m.group(1), os.path.relpath(path, ROOT))
    return sym2file


def external_symbols(lines, entry):
    """all operand identifiers that are not registers/local-labels/numbers."""
    defined = {entry, f"_{entry}"}
    for s in lines:
        m = re.match(r'^\s*([.\w]+)\s*:', s)
        if m:
            defined.add(m.group(1).lstrip("."))
    ext = set()
    for s in lines:
        code = re.sub(r';.*$', '', s).strip()
        if not code or code.endswith(":"):
            continue
        parts = code.split(None, 1)
        if len(parts) < 2:
            continue
        for tok in re.findall(r'[A-Za-z_][A-Za-z0-9_]*', parts[1]):
            if tok.upper() in C.REGISTERS:
                continue
            if tok in defined or tok.lstrip("_") in defined:
                continue
            if len(tok) == 1 and tok.upper() in C.MNEM_SUFFIX:
                continue
            ext.add(tok)
    return ext


def main():
    sym2file = load_data_symbols()
    scripts = sorted(glob.glob(os.path.join(C.SCRIPTS, "compare_sasc_*_trial.sh")))
    seen = set()
    data_leaves = []
    needs_nondata = 0
    for sp in scripts:
        d = C.parse_meta(sp)
        if not all(k in d for k in ("SASC_SRC", "ORIG_ASM", "ENTRY_ORIG")):
            continue
        entry = d["ENTRY_ORIG"]
        key = (d["ORIG_ASM"], entry)
        if key in seen:
            continue
        seen.add(key)
        sl = C.slice_original(os.path.join(ROOT, d["ORIG_ASM"]), entry)
        if not sl:
            continue
        cls, is_leaf = C.classify_slice(sl, entry)
        if cls != "PURE" or is_leaf:
            continue  # only PURE-non-leaf (has external refs, no A4/OS/HW)
        if C.CALL_RX.search("\n".join(sl)):
            continue  # skip anything that calls out
        ext = external_symbols(sl, entry)
        data_syms = {s for s in ext if s in sym2file}
        if ext and ext == data_syms:
            files = sorted({sym2file[s] for s in data_syms})
            sig = C.parse_c_signature(d["SASC_SRC"], entry)
            data_leaves.append((entry, sorted(data_syms), files, sig))
        elif ext - data_syms:
            needs_nondata += 1

    print("=" * 66)
    print("DATA-LEAF CANDIDATES (pure compute + reads src/data table)")
    print("=" * 66)
    print(f"count: {len(data_leaves)}   "
          f"(non-data external refs, skipped: {needs_nondata})\n")
    # group by data file for batching
    for entry, syms, files, sig in data_leaves[:40]:
        sigs = ""
        if sig:
            sigs = f"  {sig[0]}({', '.join(sig[1]) or 'void'})"
        print(f"  {entry:<42} <- {', '.join(files)}{sigs}")
    if len(data_leaves) > 40:
        print(f"  ... +{len(data_leaves)-40} more")


if __name__ == "__main__":
    main()
