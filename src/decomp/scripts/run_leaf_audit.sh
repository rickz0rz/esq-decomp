#!/bin/bash
#
# run_leaf_audit.sh -- build + run + diff the leaf-scalar audit batch generated
# by gen_leaf_diff.py. For each function it links the RESTORED C and the
# ORIGINAL ASM slice into two vamos executables, runs both over the shared fuzz
# table, and diffs. Emits build/decomp/leaf_audit_report.txt.
#
# Uses --cwd esq:_audit/<E> so SAS/C outputs land in the function's dir.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
source /Users/rj/Downloads/vamos/bin/activate 2>/dev/null

ESQ_VOL="$ROOT/src/decomp/sas_c"
AUDIT="src/decomp/sas_c/_audit"
OUT="build/decomp"; mkdir -p "$OUT"
REPORT="$OUT/leaf_audit_report.txt"
VOLS="$(mktemp -d "$OUT/vamos_vols.XXXXXX")"
trap 'rmdir "$VOLS/ram" 2>/dev/null || true; rmdir "$VOLS" 2>/dev/null || true' EXIT
# NOTE: </dev/null on every vamos call — otherwise vamos reads the loop's
# stdin (the manifest) and silently eats the remaining functions.
# builds (asm/sc LINK) need many cycles -> no cap.
run() { vamos -m 8192 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@" >/dev/null 2>&1 </dev/null; }
# program runs are capped so a fuzz input that triggers an infinite loop
# (e.g. step=0 in a normalize-by-step) is killed instead of hanging the audit.
# Both sides hit the cap identically, so truncated output still compares fairly.
run_out() { vamos -m 8192 --max-cycles 20000000 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@" 2>/dev/null </dev/null; }

: > "$REPORT"
pass=0; diverge=0; failed=0
echo "leaf-scalar differential audit  ($(date))" | tee -a "$REPORT"
echo "================================================================" | tee -a "$REPORT"

while IFS= read -r E; do
    [ -z "$E" ] && continue
    d="$AUDIT/$E"
    cwd="esq:_audit/$E"
    rm -f "$d/slice.o" "$d/c_side" "$d/asm_side" "$d/driver" "$d/driver.o" "$d/impl.o"

    run --cwd "$cwd" asm slice.s
    run --cwd "$cwd" sc LINK driver.c impl.c
    [ -f "$d/driver" ] && mv "$d/driver" "$d/c_side"
    run --cwd "$cwd" sc LINK driver.c slice.o
    [ -f "$d/driver" ] && mv "$d/driver" "$d/asm_side"

    if [ ! -x "$d/c_side" ] || [ ! -x "$d/asm_side" ]; then
        echo "BUILD-FAIL  $E" | tee -a "$REPORT"; failed=$((failed+1)); continue
    fi

    run_out --cwd "$cwd" asm_side > "$d/asm.out"
    run_out --cwd "$cwd" c_side   > "$d/c.out"

    if [ ! -s "$d/asm.out" ] || [ ! -s "$d/c.out" ]; then
        echo "RUN-FAIL    $E" | tee -a "$REPORT"; failed=$((failed+1)); continue
    fi

    if diff -q "$d/asm.out" "$d/c.out" >/dev/null; then
        echo "PASS        $E   (identical on all vectors)" | tee -a "$REPORT"
        pass=$((pass+1))
    else
        n=$(diff <(cat "$d/asm.out") <(cat "$d/c.out") | grep -c '^<')
        echo "DIVERGE     $E   ($n vectors differ)" | tee -a "$REPORT"
        paste -d'|' "$d/asm.out" "$d/c.out" | awk -F'|' '$1!=$2{print "                ASM["$1"]  C["$2"]"}' | head -6 | tee -a "$REPORT"
        diverge=$((diverge+1))
    fi
done < "$AUDIT/manifest.tsv"

echo "================================================================" | tee -a "$REPORT"
echo "SUMMARY: pass=$pass  diverge=$diverge  failed=$failed" | tee -a "$REPORT"
