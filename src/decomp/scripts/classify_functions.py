#!/usr/bin/env python3
"""
classify_functions.py -- Phase-0 behavioral classifier.

For every function that has a SAS/C compare lane, slice the ORIGINAL ASM and
bucket it by what it touches, so we know what the vamos differential harness
can test vs. what stays oracle-only:

  HARDWARE  references custom chips ($DFFxxx / $BFExxx) or CIA -> NOT vamos-
            testable (no chipset); oracle-proven only.
  OS_CALL   calls a library via A6 (jsr/jmp d(A6)) -> testable via vamos's
            library-call trapping (call trace is the behavioral signature).
  GLOBAL    touches A4-relative small-data globals -> testable, but the driver
            must stand up an A4 world (harder; Phase-1 generalization).
  PURE      only stack args + data registers -> the easy, fully-testable set.

Also parses the SAS/C restoration's prototype and flags PURE functions whose
params + return are ALL scalar as GENERATOR-READY (the auto-harness can fuzz
them with no pointer/struct marshaling). That set is the first audit batch.

Read-only. Output is a table + a machine-readable list on request.
"""
import glob
import os
import re
import sys
from collections import Counter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SCRIPTS = os.path.join(ROOT, "src", "decomp", "scripts")
SASC_DIR = os.path.join(ROOT, "src", "decomp", "sas_c")

RX = {
    "SASC_SRC": re.compile(r'^SASC_SRC="([^"]+)"'),
    "ORIG_ASM": re.compile(r'^ORIG_ASM="([^"]+)"'),
    "ENTRY_ORIG": re.compile(r'^ENTRY_ORIG="([^"]+)"'),
    "ENTRY": re.compile(r'^ENTRY="([^"]+)"'),
}

# --- classification patterns (applied to the original ASM slice) ---
HW_RX = re.compile(r'\$0*dff[0-9a-f]{3}|\$0*bf[de][0-9a-f]{3}|'
                   r'\bDMACON\b|\bINTENA\b|\bINTREQ\b|\bADKCON\b|\bBLTCON',
                   re.IGNORECASE)
OSCALL_RX = re.compile(r'\b(JSR|JMP)\b[^;]*\(\s*A6\s*\)', re.IGNORECASE)
LVO_RX = re.compile(r'_LVO', re.IGNORECASE)
GLOBAL_RX = re.compile(r'\(\s*A4\s*\)', re.IGNORECASE)
# any call/tail-call out to another routine (Bcc/DBcc internal branches are fine)
CALL_RX = re.compile(r'^\s*(JSR|BSR|JMP)\b', re.IGNORECASE | re.MULTILINE)

# scalar C types (all-scalar signature => generator-ready)
SCALAR_RX = re.compile(
    r'^(void|u?byte|u?word|u?long|u?int|u?char|u?short|'
    r'ubyte|uword|ulong|bool|boolean|register)$', re.IGNORECASE)


def parse_meta(path):
    d = {}
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            for k, rx in RX.items():
                m = rx.match(line)
                if m:
                    d[k] = m.group(1)
    if "ENTRY_ORIG" not in d and "ENTRY" in d:
        d["ENTRY_ORIG"] = d["ENTRY"]
    return d


def slice_original(orig_path, entry):
    if not os.path.exists(orig_path):
        return []
    with open(orig_path, encoding="utf-8", errors="replace") as fh:
        lines = fh.read().splitlines()
    out, started = [], False
    entry_rx = re.compile(r'^_?' + re.escape(entry) + r':?$')
    for s in lines:
        if not started:
            if entry_rx.match(s.strip()):
                started = True
            continue
        if re.match(r'^;!=+', s):
            break
        out.append(s)
    return out


REGISTERS = {f"A{i}" for i in range(8)} | {f"D{i}" for i in range(8)} | {
    "SP", "PC", "USP", "SSP", "SR", "CCR", "FP"}
MNEM_SUFFIX = {"B", "W", "L", "S", "Q"}  # size/short suffixes (post-dot)


def has_external_ref(lines, entry):
    """True if any operand references a symbol that is not a register, a
    locally-defined label, or a number -> an external data/global/func dep."""
    defined = {entry, f"_{entry}"}
    for s in lines:
        m = re.match(r'^\s*([.\w]+)\s*:', s)
        if m:
            defined.add(m.group(1).lstrip("."))
    for s in lines:
        code = re.sub(r';.*$', '', s).strip()
        if not code or code.endswith(":"):
            continue
        parts = code.split(None, 1)
        if len(parts) < 2:
            continue
        operands = parts[1]
        for tok in re.findall(r'[A-Za-z_][A-Za-z0-9_]*', operands):
            if tok.upper() in REGISTERS:
                continue
            if tok in defined or tok.lstrip("_") in defined:
                continue
            if len(tok) == 1 and tok.upper() in MNEM_SUFFIX:
                continue
            return True
    return False


def classify_slice(lines, entry):
    text = "\n".join(lines)
    if HW_RX.search(text):
        return "HARDWARE", False
    if OSCALL_RX.search(text) or LVO_RX.search(text):
        return "OS_CALL", False
    if GLOBAL_RX.search(text):
        return "GLOBAL", False
    # PURE = no chipset/OS/A4. A true isolated leaf additionally makes no calls
    # and references no external symbols (data tables, other globals).
    has_calls = bool(CALL_RX.search(text))
    ext = has_external_ref(lines, entry)
    return "PURE", (not has_calls and not ext)


def parse_c_signature(sasc_src, entry):
    """Return (ret_type, [param_types]) for `entry` in the .c file, or None."""
    path = os.path.join(SASC_DIR, sasc_src)
    if not os.path.exists(path):
        return None
    with open(path, encoding="utf-8", errors="replace") as fh:
        src = fh.read()
    # find a definition: <ret> [__stdargs] ENTRY ( params ) {
    rx = re.compile(
        r'([A-Za-z_][\w ]*?)\s+(?:__stdargs\s+|__regargs\s+|__asm\s+)?'
        + re.escape(entry) + r'\s*\(([^)]*)\)\s*\{', re.MULTILINE)
    m = rx.search(src)
    if not m:
        return None
    ret = m.group(1).strip().split()[-1]
    params_raw = m.group(2).strip()
    if params_raw in ("", "void"):
        return (ret, [])
    params = []
    for p in params_raw.split(","):
        p = p.strip()
        params.append(p)
    return (ret, params)


def is_scalar_type(decl):
    """decl like 'ULONG c' or 'const char *s' -> scalar? (no *, scalar base)."""
    if "*" in decl or "[" in decl:
        return False
    toks = [t for t in re.split(r'\s+', decl) if t and t not in ("const", "register")]
    if not toks:
        return False
    base = toks[0]
    return bool(SCALAR_RX.match(base))


def main():
    emit_list = "--list" in sys.argv
    list_bucket = None
    for a in sys.argv:
        if a.startswith("--bucket="):
            list_bucket = a.split("=", 1)[1]

    scripts = sorted(glob.glob(os.path.join(SCRIPTS, "compare_sasc_*_trial.sh")))
    buckets = Counter()
    gen_ready = []
    seen = set()
    rows = []

    for sp in scripts:
        d = parse_meta(sp)
        if not all(k in d for k in ("SASC_SRC", "ORIG_ASM", "ENTRY_ORIG")):
            continue
        entry = d["ENTRY_ORIG"]
        key = (d["ORIG_ASM"], entry)
        if key in seen:
            continue
        seen.add(key)
        sl = slice_original(os.path.join(ROOT, d["ORIG_ASM"]), entry)
        if not sl:
            buckets["NO_SLICE"] += 1
            continue
        cls, is_leaf = classify_slice(sl, entry)
        buckets[cls] += 1
        ready = False
        # *_labels.c sources are internal mid-function label fragments of a
        # larger routine (e.g. PARSE_ReadSignedLong_*), not independently
        # callable functions -> exclude from the leaf audit.
        is_label_fragment = d["SASC_SRC"].endswith("_labels.c")
        if (cls == "PURE" and is_leaf and not entry.endswith("_Return")
                and not is_label_fragment):
            sig = parse_c_signature(d["SASC_SRC"], entry)
            if sig is not None:
                ret, params = sig
                all_scalar = is_scalar_type(ret + " x") and all(
                    is_scalar_type(p) for p in params)
                # meaningful differential test needs an input to fuzz AND an
                # observable return value
                testable = (ret.lower() != "void") and len(params) >= 1
                if all_scalar and testable:
                    ready = True
                    gen_ready.append((entry, d["SASC_SRC"], d["ORIG_ASM"], ret, params))
        rows.append((cls, ready, entry, d["ORIG_ASM"], d["SASC_SRC"]))

    if emit_list:
        for entry, src, asm, ret, params in gen_ready:
            print(f"{entry}\t{src}\t{asm}\t{ret}\t{'|'.join(params)}")
        return
    if list_bucket:
        for cls, ready, entry, asm, src in rows:
            if cls == list_bucket:
                print(f"{entry}\t{asm}\t{src}")
        return

    total = sum(buckets.values())
    print("=" * 66)
    print("FUNCTION CLASSIFIER (original-ASM slice analysis)")
    print("=" * 66)
    for k in ("PURE", "GLOBAL", "OS_CALL", "HARDWARE", "NO_SLICE"):
        v = buckets.get(k, 0)
        pct = 100.0 * v / total if total else 0
        note = {
            "PURE": "fully vamos-testable (easy)",
            "GLOBAL": "testable; needs A4 world",
            "OS_CALL": "testable via call-trace",
            "HARDWARE": "oracle-only (no chipset)",
            "NO_SLICE": "slice not found",
        }[k]
        print(f"  {k:<9} {v:4d}  ({pct:4.1f}%)   {note}")
    print(f"  {'TOTAL':<9} {total:4d}")
    print(f"\n  GENERATOR-READY (PURE + all-scalar signature): {len(gen_ready)}")
    print("  -> first audit batch for the auto-harness")
    print("\n  sample generator-ready:")
    for entry, src, asm, ret, params in gen_ready[:12]:
        print(f"    {entry:<40} {ret}({', '.join(params) or 'void'})")


if __name__ == "__main__":
    main()
