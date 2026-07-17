#!/bin/bash
#
# link_full_program.sh -- Phase-3 step 3: slink all DATA=FAR restoration objects
# + the data segment + amiga.lib + SAS/C startup into ESQ_fullc, and report any
# unresolved symbols (the definitive scaffolding-gap list).
#
# Prereq: compile_all_sasc_far.sh (objects in src/decomp/sas_c/_farobj/) and
# build_data_segment.sh (datasegment.o).
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
source /Users/rj/Downloads/vamos/bin/activate 2>/dev/null

ESQ_VOL="$ROOT/src/decomp/sas_c"
OBJ="src/decomp/sas_c/_farobj"
OUTDIR="build/decomp/phase3"; mkdir -p "$OUTDIR"
VOLS="$(mktemp -d "$OUTDIR/vamos_vols.XXXXXX")"
trap 'rmdir "$VOLS/ram" 2>/dev/null || true; rmdir "$VOLS" 2>/dev/null || true' EXIT
run() { vamos -m 8192 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" --cwd esq:_farobj "$@" </dev/null; }

# stage the data segment + compiled entry into the object dir
cp "$OUTDIR/datasegment.o" "$OBJ/datasegment.o"
run --cwd esq: sc DATA=FAR IDLEN=64 NOLINK esq_fullc_main.c >/dev/null 2>&1
mv "src/decomp/sas_c/esq_fullc_main.o" "$OBJ/esq_fullc_main.o" 2>/dev/null || true

# build a slink WITH file: startup, entry, all restorations, data; then libs
# Exclude a curated list of fully-redundant duplicate objects (verified via
# dumpobj to define only symbols also defined elsewhere). See
# build/decomp/phase3/exclude_objs.txt. Excluding whole objects is safe only for
# these verified pure-duplicate files.
EXCL="$OUTDIR/exclude_objs.txt"; touch "$EXCL"
WITHF="$OBJ/esq_fullc.with"
{
  echo "FROM lib:c.o esq_fullc_main.o"
  for o in "$OBJ"/*.o; do
    b="$(basename "$o" .o)"
    case "$b" in esq_fullc_main|datasegment) continue;; esac
    grep -qx "$b" "$EXCL" && continue
    echo "     $b.o"
  done
  echo "     datasegment.o"
  echo "TO esq:ESQ_fullc"
  echo "LIB lib:sc.lib lib:amiga.lib"
  echo "MAP esq:ESQ_fullc.map,SFH"
} > "$WITHF"

echo "objects to link: $(ls "$OBJ"/*.o | wc -l)"
echo "=== slink ==="
run slink WITH esq_fullc.with 2>&1 | tee "$OUTDIR/link.log" | \
  grep -iE 'error|unresolved|undefined|complete|symbol' | head -40
echo "=== unresolved symbol summary ==="
grep -iE 'unresolved|undefined' "$OUTDIR/link.log" | sed -E 's/.*symbol //I' | sort -u | head -40
[ -f "src/decomp/sas_c/ESQ_fullc" ] && echo "*** ESQ_fullc BUILT ($(stat -f%z src/decomp/sas_c/ESQ_fullc) bytes) ***"

# integrity guard: multiply-defined symbols make slink abort with a TRUNCATED
# binary. Exit non-zero so callers (and manual deploys) never ship it.
muldef=$(grep -ci 'multiply defined' "$OUTDIR/link.log" 2>/dev/null); muldef=${muldef:-0}
sz=$(stat -f%z src/decomp/sas_c/ESQ_fullc 2>/dev/null || echo 0)
if [ "$muldef" -gt 0 ] || [ "$sz" -lt 400000 ]; then
    echo "!!! LINK BROKEN: multiply-defined=$muldef  size=$sz (expected ~490 KB). Do NOT deploy." >&2
    exit 1
fi
