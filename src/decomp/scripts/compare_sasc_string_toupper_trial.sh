#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="string_to_upper_char.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown3.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_string_toupper.log" 2>&1

awk '$0 ~ /^STRING_ToUpperChar:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/string_toupper.original.s"
awk '$0 ~ /^STRING_ToUpperChar:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/string_toupper.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/string_toupper.original.s" >"${OUT_DIR}/string_toupper.original.norm.s"
normalize <"${OUT_DIR}/string_toupper.sasc.dis.s" >"${OUT_DIR}/string_toupper.sasc.norm.s"

diff -u "${OUT_DIR}/string_toupper.original.norm.s" "${OUT_DIR}/string_toupper.sasc.norm.s" >"${OUT_DIR}/string_toupper.diff" || true
awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper.awk "${OUT_DIR}/string_toupper.original.norm.s" >"${OUT_DIR}/string_toupper.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_string_toupper.awk "${OUT_DIR}/string_toupper.sasc.norm.s" >"${OUT_DIR}/string_toupper.sasc.semantic.txt"
diff -u "${OUT_DIR}/string_toupper.original.semantic.txt" "${OUT_DIR}/string_toupper.sasc.semantic.txt" >"${OUT_DIR}/string_toupper.semantic.diff" || true

echo "wrote: ${OUT_DIR}/string_toupper.diff"
echo "wrote: ${OUT_DIR}/string_toupper.semantic.diff"
rg -n "CMPI\.B #'a',D0|CMPI\.B #'z',D0|SUBI\.B #\$20,D0|RTS" "${OUT_DIR}/string_toupper.sasc.norm.s" || true
