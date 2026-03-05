#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown24_memlist_alloc_free.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown24.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_memlist_alloc_tracked.log" 2>&1

awk '$0 ~ /^MEMLIST_AllocTracked:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/memlist_alloc_tracked.original.s"
awk '$0 ~ /^MEMLIST_AllocTracked:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/memlist_alloc_tracked.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^const:$/d' \
    -e '/^strings:$/d' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/memlist_alloc_tracked.original.s" >"${OUT_DIR}/memlist_alloc_tracked.original.norm.s"
normalize <"${OUT_DIR}/memlist_alloc_tracked.sasc.dis.s" >"${OUT_DIR}/memlist_alloc_tracked.sasc.norm.s"

diff -u "${OUT_DIR}/memlist_alloc_tracked.original.norm.s" "${OUT_DIR}/memlist_alloc_tracked.sasc.norm.s" >"${OUT_DIR}/memlist_alloc_tracked.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_memlist_alloc_tracked.awk "${OUT_DIR}/memlist_alloc_tracked.original.norm.s" >"${OUT_DIR}/memlist_alloc_tracked.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_memlist_alloc_tracked.awk "${OUT_DIR}/memlist_alloc_tracked.sasc.norm.s" >"${OUT_DIR}/memlist_alloc_tracked.sasc.semantic.txt"
diff -u "${OUT_DIR}/memlist_alloc_tracked.original.semantic.txt" "${OUT_DIR}/memlist_alloc_tracked.sasc.semantic.txt" >"${OUT_DIR}/memlist_alloc_tracked.semantic.diff" || true

echo "wrote: ${OUT_DIR}/memlist_alloc_tracked.diff"
echo "wrote: ${OUT_DIR}/memlist_alloc_tracked.semantic.diff"
