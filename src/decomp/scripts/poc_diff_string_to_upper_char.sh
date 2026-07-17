#!/bin/bash
#
# Phase-1 PROOF OF CONCEPT — differential vamos execution harness.
#
# Runs the ORIGINAL ASM slice and the RESTORED C for STRING_ToUpperChar under
# vamos with identical inputs and diffs the outputs. Demonstrates that a
# behavioral test catches a divergence (high-byte preservation) that the
# static normalized-ASM "green" lane passed as equivalent.
#
# This is the template for generalizing the harness (task #5). Hard-won
# integration gotchas encoded below:
#   1. SAS/C C symbols are UNDERSCORE-PREFIXED (_Name). A hand-asm reference
#      object MUST `XDEF _Name` or the C driver's call binds to garbage and
#      crashes (InvalidCPUStateError).
#   2. Original hand-asm helpers are STACK-based (arg at 4(A7)); the driver
#      extern and the C impl are declared __stdargs to force the matching ABI.
#   3. Assemble the original slice with SAS/C `asm` (slink-native hunk), not
#      vasm, to avoid object-format friction with slink.
#   4. vamos needs `-m 8192` (8 MiB). 16 MiB overflows the 24-bit address bus.
#   5. `sc LINK` names the output after the first source's basename; there is
#      no PROGRAM= option — rename between the two builds.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
source /Users/rj/Downloads/vamos/bin/activate 2>/dev/null

ESQ_VOL="$ROOT/src/decomp/sas_c"
D="src/decomp/sas_c"
OUT="build/decomp"; mkdir -p "$OUT"
VOLS="$(mktemp -d "$OUT/vamos_vols.XXXXXX")"
trap 'rmdir "$VOLS/ram" 2>/dev/null || true; rmdir "$VOLS" 2>/dev/null || true' EXIT
run() { vamos -m 8192 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@"; }

echo "== assemble original slice (SAS/C asm, _-prefixed XDEF) =="
run asm esq:_poc_orig2.s 2>&1 | grep -iE 'error' || true

echo "== build C side (driver + __stdargs restored impl) =="
rm -f "$D/_poc_driver"
run sc LINK esq:_poc_driver.c esq:_poc_impl.c 2>&1 | grep -iE 'error|complete' || true
mv "$D/_poc_driver" "$D/_poc_c"

echo "== build ASM side (driver + original slice obj) =="
rm -f "$D/_poc_driver"
run sc LINK esq:_poc_driver.c esq:_poc_orig2.o 2>&1 | grep -iE 'error|complete' || true
mv "$D/_poc_driver" "$D/_poc_asm"

echo "== run both under vamos =="
run esq:_poc_asm 2>/dev/null > "$OUT/_poc_asm.out"
run esq:_poc_c   2>/dev/null > "$OUT/_poc_c.out"

echo "== differential result =="
paste -d'~' "$OUT/_poc_asm.out" "$OUT/_poc_c.out" | awk -F'~' '
  {split($1,a," ");split($2,b," ");gi=substr(a[1],4);ao=substr(a[2],5);co=substr(b[2],5);
   if(ao!=co){printf "  in=%s  ASM->%s  C->%s  <== DIVERGES\n",gi,ao,co;d++}
   else printf "  in=%s  both->%s\n",gi,ao}
  END{print "";
      if(d) printf "  RESULT: %d/12 diverge — restored C NOT behaviorally equivalent\n",d;
      else  print "  RESULT: identical on all 12 vectors"}'
