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

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_string_find_substring.log" 2>&1

awk '$0 ~ /^STRING_FindSubstring:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) {sep++; if (sep==2) exit} print }' "$ORIG_ASM" >"${OUT_DIR}/string_find_substring.original.s"
awk '$0 ~ /^STRING_FindSubstring:$/ {in_func=1} in_func { if ($0 ~ /^ALLOC_InsertFreeBlock:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/string_find_substring.sasc.dis.s"

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

normalize <"${OUT_DIR}/string_find_substring.original.s" >"${OUT_DIR}/string_find_substring.original.norm.s"
normalize <"${OUT_DIR}/string_find_substring.sasc.dis.s" >"${OUT_DIR}/string_find_substring.sasc.norm.s"

diff -u "${OUT_DIR}/string_find_substring.original.norm.s" "${OUT_DIR}/string_find_substring.sasc.norm.s" >"${OUT_DIR}/string_find_substring.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_string_find_substring.awk "${OUT_DIR}/string_find_substring.original.norm.s" >"${OUT_DIR}/string_find_substring.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_string_find_substring.awk "${OUT_DIR}/string_find_substring.sasc.norm.s" >"${OUT_DIR}/string_find_substring.sasc.semantic.txt"
diff -u "${OUT_DIR}/string_find_substring.original.semantic.txt" "${OUT_DIR}/string_find_substring.sasc.semantic.txt" >"${OUT_DIR}/string_find_substring.semantic.diff" || true

echo "wrote: ${OUT_DIR}/string_find_substring.diff"
echo "wrote: ${OUT_DIR}/string_find_substring.semantic.diff"
