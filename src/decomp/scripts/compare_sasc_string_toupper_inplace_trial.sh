#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="STRING_ToUpperInPlace"

SASC_SRC="unknown4_string_toupper_inplace.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown4.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_string_toupper_inplace.log" 2>&1

awk '$0 ~ /^STRING_ToUpperInPlace:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/string_toupper_inplace.original.s"
awk '$0 ~ /^STRING_ToUpperInPlace:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/string_toupper_inplace.sasc.dis.s"

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

normalize <"${OUT_DIR}/string_toupper_inplace.original.s" >"${OUT_DIR}/string_toupper_inplace.original.norm.s"
normalize <"${OUT_DIR}/string_toupper_inplace.sasc.dis.s" >"${OUT_DIR}/string_toupper_inplace.sasc.norm.s"

diff -u "${OUT_DIR}/string_toupper_inplace.original.norm.s" "${OUT_DIR}/string_toupper_inplace.sasc.norm.s" >"${OUT_DIR}/string_toupper_inplace.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper_inplace.awk "${OUT_DIR}/string_toupper_inplace.original.norm.s" >"${OUT_DIR}/string_toupper_inplace.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper_inplace.awk "${OUT_DIR}/string_toupper_inplace.sasc.norm.s" >"${OUT_DIR}/string_toupper_inplace.sasc.semantic.txt"
diff -u "${OUT_DIR}/string_toupper_inplace.original.semantic.txt" "${OUT_DIR}/string_toupper_inplace.sasc.semantic.txt" >"${OUT_DIR}/string_toupper_inplace.semantic.diff" || true

echo "wrote: ${OUT_DIR}/string_toupper_inplace.diff"
echo "wrote: ${OUT_DIR}/string_toupper_inplace.semantic.diff"
