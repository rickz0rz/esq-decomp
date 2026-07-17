#!/bin/bash
#
# compile_all_sasc_far.sh -- Phase-3 step 2: compile every restored SAS/C .c to
# an object with DATA=FAR (absolute global addressing, links against the vasm
# data segment) and IDLEN=64 (full identifier significance -> no truncation
# collisions). Resumable: skips sources whose .o already exists and is newer.
# Logs per-file ok/fail to build/decomp/phase3/compile.log.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
source /Users/rj/Downloads/vamos/bin/activate 2>/dev/null

ESQ_VOL="$ROOT/src/decomp/sas_c"
OBJ="src/decomp/sas_c/_farobj"; mkdir -p "$OBJ"
LOG="build/decomp/phase3/compile.log"; mkdir -p build/decomp/phase3
VOLS="$(mktemp -d build/decomp/vamos_vols.XXXXXX)"
trap 'rmdir "$VOLS/ram" 2>/dev/null || true; rmdir "$VOLS" 2>/dev/null || true' EXIT
# NOTE: do NOT pass `--cwd esq:` here. Doing so makes the emulated `sc` CPU-crash
# on a handful of sources (the old "vamos-uncompilable" set). Referencing the
# source as `esq:<file>` with no --cwd compiles all of them clean. See
# _missing_stubs.s header.
run() { vamos -m 10240 --vols-base-dir "$VOLS" --volume esq:"$ESQ_VOL" "$@" </dev/null; }

: > "$LOG"
ok=0; fail=0; skip=0; i=0
# the exclude list (build/decomp/phase3/exclude_objs.txt) is the single source of
# truth for "do not link this object" -- duplicate restorations and .c files whose
# symbol is instead provided by a hand-written stub (e.g. the *_jmptbl_* wrappers
# served by jmptbl_stubs.asm). Skip COMPILING those too, so they can't reappear in
# _farobj and break the link with multiply-defined symbols.
EXCL="build/decomp/phase3/exclude_objs.txt"; touch "$EXCL"
is_excluded() { grep -qx "$1" "$EXCL"; }
# real restorations only: exclude POC/test/fixture files
# (bash 3.2 on macOS has no mapfile -> portable array fill)
SRCS=()
while IFS= read -r line; do SRCS+=("$line"); done < <(ls src/decomp/sas_c/*.c | xargs -n1 basename | grep -vE '^_poc|^test|^_' | sort)
total=${#SRCS[@]}
echo "compiling $total restorations (DATA=FAR IDLEN=64)" | tee -a "$LOG"

# ---- prune stale objects so the incremental build can't ship duplicates ----
# Remove any _farobj/*.o that (a) is on the exclude list, or (b) has no matching
# source .c (orphan from a renamed/removed source) and isn't a hand-built stub/
# glue object. Keeps incremental speed (no full rebuild) while staying clean.
KEEP_RE='^(_missing_stubs|_zexcept|datasegment|esq_fullc_main|oscall_stubs|.*jmptbl_stubs_asm|.*_stubs)$'
pruned=0
for o in "$OBJ"/*.o; do
    [ -e "$o" ] || continue
    b="$(basename "$o" .o)"
    if is_excluded "$b" || { [ ! -f "src/decomp/sas_c/$b.c" ] && ! echo "$b" | grep -qE "$KEEP_RE"; }; then
        rm -f "$o"; pruned=$((pruned+1)); echo "  prune stale: $b.o" >> "$LOG"
    fi
done
[ "$pruned" -gt 0 ] && echo "pruned $pruned stale/excluded object(s) from $OBJ" | tee -a "$LOG"

for f in "${SRCS[@]}"; do
    i=$((i+1))
    base="${f%.c}"
    # never compile an excluded object (its symbol is provided elsewhere)
    if is_excluded "$base"; then skip=$((skip+1)); continue; fi
    if [ -f "$OBJ/$base.o" ] && [ "$OBJ/$base.o" -nt "src/decomp/sas_c/$f" ]; then
        skip=$((skip+1)); continue
    fi
    # compile in place, then move the .o into _farobj/.
    # Retry on transient vamos ram-volume setup failures (env flake, not a code
    # error) so a hiccup never silently leaves a stale .o linked into the binary.
    compiled=0
    for try in 1 2 3 4 5; do
        run sc DATA=FAR IDLEN=64 NOSTACKCHECK NOLINK "esq:$f" >>"$LOG" 2>&1
        if [ -f "src/decomp/sas_c/$base.o" ]; then
            mv "src/decomp/sas_c/$base.o" "$OBJ/$base.o"; compiled=1; break
        fi
        # only retry the vamos volume/path flake; a real compile error won't have it
        grep -q 'path setup failed\|Error settign up volume\|Error setting up volume' "$LOG" || break
    done
    if [ "$compiled" = 1 ]; then ok=$((ok+1)); else echo "FAIL $f" >> "$LOG"; fail=$((fail+1)); fi
    if [ $((i % 50)) -eq 0 ]; then echo "  [$i/$total] ok=$ok fail=$fail skip=$skip"; fi
done
echo "DONE: ok=$ok fail=$fail skip=$skip total=$total" | tee -a "$LOG"
