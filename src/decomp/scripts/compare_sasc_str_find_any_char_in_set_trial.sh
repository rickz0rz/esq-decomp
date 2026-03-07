#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="STR_FindAnyCharInSet"

SASC_SRC="unknown7_str_core_helpers.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown7.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_str_find_any_char_in_set.log" 2>&1

awk '$0 ~ /^STR_FindAnyCharInSet:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/str_find_any_char_in_set.original.s"
awk '$0 ~ /^STR_FindAnyCharInSet:$/ {in_func=1} in_func { if ($0 ~ /^STR_FindAnyCharPtr:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/str_find_any_char_in_set.sasc.dis.s"

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

normalize <"${OUT_DIR}/str_find_any_char_in_set.original.s" >"${OUT_DIR}/str_find_any_char_in_set.original.norm.s"
normalize <"${OUT_DIR}/str_find_any_char_in_set.sasc.dis.s" >"${OUT_DIR}/str_find_any_char_in_set.sasc.norm.s"

diff -u "${OUT_DIR}/str_find_any_char_in_set.original.norm.s" "${OUT_DIR}/str_find_any_char_in_set.sasc.norm.s" >"${OUT_DIR}/str_find_any_char_in_set.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_str_find_any_char_in_set.awk "${OUT_DIR}/str_find_any_char_in_set.original.norm.s" >"${OUT_DIR}/str_find_any_char_in_set.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_str_find_any_char_in_set.awk "${OUT_DIR}/str_find_any_char_in_set.sasc.norm.s" >"${OUT_DIR}/str_find_any_char_in_set.sasc.semantic.txt"
diff -u "${OUT_DIR}/str_find_any_char_in_set.original.semantic.txt" "${OUT_DIR}/str_find_any_char_in_set.sasc.semantic.txt" >"${OUT_DIR}/str_find_any_char_in_set.semantic.diff" || true

echo "wrote: ${OUT_DIR}/str_find_any_char_in_set.diff"
echo "wrote: ${OUT_DIR}/str_find_any_char_in_set.semantic.diff"
