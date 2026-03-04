#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown3_string_toupper_char.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown3.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_string_toupper_char.log" 2>&1

awk '$0 ~ /^STRING_ToUpperChar:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/string_toupper_char.original.s"
awk '$0 ~ /^STRING_ToUpperChar:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/string_toupper_char.sasc.dis.s"

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

normalize <"${OUT_DIR}/string_toupper_char.original.s" >"${OUT_DIR}/string_toupper_char.original.norm.s"
normalize <"${OUT_DIR}/string_toupper_char.sasc.dis.s" >"${OUT_DIR}/string_toupper_char.sasc.norm.s"

diff -u "${OUT_DIR}/string_toupper_char.original.norm.s" "${OUT_DIR}/string_toupper_char.sasc.norm.s" >"${OUT_DIR}/string_toupper_char.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper_char.awk "${OUT_DIR}/string_toupper_char.original.norm.s" >"${OUT_DIR}/string_toupper_char.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper_char.awk "${OUT_DIR}/string_toupper_char.sasc.norm.s" >"${OUT_DIR}/string_toupper_char.sasc.semantic.txt"
diff -u "${OUT_DIR}/string_toupper_char.original.semantic.txt" "${OUT_DIR}/string_toupper_char.sasc.semantic.txt" >"${OUT_DIR}/string_toupper_char.semantic.diff" || true

echo "wrote: ${OUT_DIR}/string_toupper_char.diff"
echo "wrote: ${OUT_DIR}/string_toupper_char.semantic.diff"
