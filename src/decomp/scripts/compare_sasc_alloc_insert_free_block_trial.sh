#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown33_string_find_substring.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown33.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_alloc_insert_free_block.log" 2>&1

awk '$0 ~ /^ALLOC_InsertFreeBlock:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/alloc_insert_free_block.original.s"
awk '$0 ~ /^ALLOC_InsertFreeBlock:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/alloc_insert_free_block.sasc.dis.s"

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

normalize <"${OUT_DIR}/alloc_insert_free_block.original.s" >"${OUT_DIR}/alloc_insert_free_block.original.norm.s"
normalize <"${OUT_DIR}/alloc_insert_free_block.sasc.dis.s" >"${OUT_DIR}/alloc_insert_free_block.sasc.norm.s"

diff -u "${OUT_DIR}/alloc_insert_free_block.original.norm.s" "${OUT_DIR}/alloc_insert_free_block.sasc.norm.s" >"${OUT_DIR}/alloc_insert_free_block.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_alloc_insert_free_block.awk "${OUT_DIR}/alloc_insert_free_block.original.norm.s" >"${OUT_DIR}/alloc_insert_free_block.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_alloc_insert_free_block.awk "${OUT_DIR}/alloc_insert_free_block.sasc.norm.s" >"${OUT_DIR}/alloc_insert_free_block.sasc.semantic.txt"
diff -u "${OUT_DIR}/alloc_insert_free_block.original.semantic.txt" "${OUT_DIR}/alloc_insert_free_block.sasc.semantic.txt" >"${OUT_DIR}/alloc_insert_free_block.semantic.diff" || true

echo "wrote: ${OUT_DIR}/alloc_insert_free_block.diff"
echo "wrote: ${OUT_DIR}/alloc_insert_free_block.semantic.diff"
