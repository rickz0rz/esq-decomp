#!/bin/bash
#
# run_global_diff.sh -- A4-global differential audit runner.
#
# For each fixture dir src/decomp/sas_c/_gtest/<ENTRY>/ containing:
#   globals.s   __MERGED near-data storage for the touched globals, XDEF'd as
#               BOTH `Name` (for the ASM slice's `Global_X(A4)` ref) and `_Name`
#               (for the SAS/C C ref) at the same address (writable: DS.L/DS.B).
#   slice.s     original ASM slice, XDEF _TESTFN, XREF each global.
#   impl.c      the restored C function only, renamed TESTFN, __stdargs.
#   driver.c    seeds the globals + a test buffer, calls TESTFN over fixed
#               inputs, prints return + global state + a buffer digest.
# it links the C side (driver+impl+globals) and the ASM side (driver+slice+
# globals) into two executables, runs both, and diffs. Identical => the restored
# C is behaviorally equivalent to the original for its global side effects too.
#
# Why this works: writable globals in SECTION __MERGED are near-data; SAS/C's
# C refs (A4-relative, near) and the ASM slice's Global_X(A4) refs resolve to
# the SAME storage, and SAS/C's startup sets A4. No absolute datasegment needed.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
source /Users/rj/Downloads/vamos/bin/activate 2>/dev/null

ESQ_VOL="$ROOT/src/decomp/sas_c"
GT="src/decomp/sas_c/_gtest"
OUT="build/decomp"; mkdir -p "$OUT"
REPORT="$OUT/global_diff_report.txt"
VOLS="$(mktemp -d "$OUT/vamos_vols.XXXXXX")"
trap 'rmdir "$VOLS/ram" 2>/dev/null || true; rmdir "$VOLS" 2>/dev/null || true' EXIT
run()    { vamos -m 8192 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@" >/dev/null 2>&1 </dev/null; }
runout() { vamos -m 8192 --max-cycles 20000000 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@" 2>/dev/null </dev/null; }

: > "$REPORT"
pass=0; diverge=0; failed=0
echo "A4-global differential audit  ($(date))" | tee -a "$REPORT"
echo "================================================================" | tee -a "$REPORT"

for d in "$GT"/*/; do
    E="$(basename "$d")"
    [ -f "$d/slice.s" ] && [ -f "$d/impl.c" ] && [ -f "$d/driver.c" ] && [ -f "$d/globals.s" ] || continue
    cwd="esq:_gtest/$E"
    rm -f "$d"/*.o "$d/c_side" "$d/asm_side" "$d/driver"

    # Two addressing modes. Functions that reach globals A4-relative
    # (Global_X(A4)) need near-data: globals.s in SECTION __MERGED, C compiled
    # default (near). Functions that use ABSOLUTE addressing (LEA symbol,An) need
    # globals.s in a plain SECTION data,DATA and the C compiled DATA=FAR so both
    # sides resolve the symbol to the same absolute address. Detect by section.
    if grep -q '__MERGED' "$d/globals.s"; then SCFLAGS="LINK"; else SCFLAGS="DATA=FAR IDLEN=64 LINK"; fi

    run --cwd "$cwd" asm slice.s
    run --cwd "$cwd" asm globals.s
    run --cwd "$cwd" sc $SCFLAGS driver.c impl.c globals.o
    [ -f "$d/driver" ] && mv "$d/driver" "$d/c_side"
    run --cwd "$cwd" sc $SCFLAGS driver.c slice.o globals.o
    [ -f "$d/driver" ] && mv "$d/driver" "$d/asm_side"

    if [ ! -x "$d/c_side" ] || [ ! -x "$d/asm_side" ]; then
        echo "BUILD-FAIL  $E" | tee -a "$REPORT"; failed=$((failed+1)); continue
    fi
    runout --cwd "$cwd" asm_side > "$d/asm.out"
    runout --cwd "$cwd" c_side   > "$d/c.out"
    if [ ! -s "$d/asm.out" ] || [ ! -s "$d/c.out" ]; then
        echo "RUN-FAIL    $E" | tee -a "$REPORT"; failed=$((failed+1)); continue
    fi
    if diff -q "$d/asm.out" "$d/c.out" >/dev/null; then
        echo "PASS        $E   (identical on all vectors)" | tee -a "$REPORT"; pass=$((pass+1))
    else
        echo "DIVERGE     $E" | tee -a "$REPORT"
        paste -d'|' "$d/asm.out" "$d/c.out" | awk -F'|' '$1!=$2{print "                ASM["$1"]  C["$2"]"}' | head -6 | tee -a "$REPORT"
        diverge=$((diverge+1))
    fi
done
echo "================================================================" | tee -a "$REPORT"
echo "SUMMARY: pass=$pass  diverge=$diverge  failed=$failed" | tee -a "$REPORT"
