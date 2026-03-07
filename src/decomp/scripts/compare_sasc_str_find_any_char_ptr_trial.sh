#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="STR_FindAnyCharPtr"

SASC_SRC="unknown7_str_core_helpers.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown7.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_str_find_any_char_ptr.log" 2>&1

awk '$0 ~ /^STR_FindAnyCharPtr:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/str_find_any_char_ptr.original.s"
awk '$0 ~ /^STR_FindAnyCharPtr:$/ {in_func=1} in_func { if ($0 ~ /^STR_SkipClass3Chars:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/str_find_any_char_ptr.sasc.dis.s"

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

normalize <"${OUT_DIR}/str_find_any_char_ptr.original.s" >"${OUT_DIR}/str_find_any_char_ptr.original.norm.s"
normalize <"${OUT_DIR}/str_find_any_char_ptr.sasc.dis.s" >"${OUT_DIR}/str_find_any_char_ptr.sasc.norm.s"

diff -u "${OUT_DIR}/str_find_any_char_ptr.original.norm.s" "${OUT_DIR}/str_find_any_char_ptr.sasc.norm.s" >"${OUT_DIR}/str_find_any_char_ptr.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_str_find_any_char_ptr.awk "${OUT_DIR}/str_find_any_char_ptr.original.norm.s" >"${OUT_DIR}/str_find_any_char_ptr.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_str_find_any_char_ptr.awk "${OUT_DIR}/str_find_any_char_ptr.sasc.norm.s" >"${OUT_DIR}/str_find_any_char_ptr.sasc.semantic.txt"
diff -u "${OUT_DIR}/str_find_any_char_ptr.original.semantic.txt" "${OUT_DIR}/str_find_any_char_ptr.sasc.semantic.txt" >"${OUT_DIR}/str_find_any_char_ptr.semantic.diff" || true

echo "wrote: ${OUT_DIR}/str_find_any_char_ptr.diff"
echo "wrote: ${OUT_DIR}/str_find_any_char_ptr.semantic.diff"
