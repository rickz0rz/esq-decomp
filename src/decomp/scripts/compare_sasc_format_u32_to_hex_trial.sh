#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown10_format_u32_to_hex_string.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown10.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_format_u32_to_hex.log" 2>&1

awk '$0 ~ /^FORMAT_U32ToHexString:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/format_u32_to_hex.original.s"
awk '$0 ~ /^FORMAT_U32ToHexString:$/ {in_func=1} in_func { if ($0 ~ /^PARSE_ReadSignedLong:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/format_u32_to_hex.sasc.dis.s"

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

normalize <"${OUT_DIR}/format_u32_to_hex.original.s" >"${OUT_DIR}/format_u32_to_hex.original.norm.s"
normalize <"${OUT_DIR}/format_u32_to_hex.sasc.dis.s" >"${OUT_DIR}/format_u32_to_hex.sasc.norm.s"

diff -u "${OUT_DIR}/format_u32_to_hex.original.norm.s" "${OUT_DIR}/format_u32_to_hex.sasc.norm.s" >"${OUT_DIR}/format_u32_to_hex.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_format_u32_to_hex.awk "${OUT_DIR}/format_u32_to_hex.original.norm.s" >"${OUT_DIR}/format_u32_to_hex.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_format_u32_to_hex.awk "${OUT_DIR}/format_u32_to_hex.sasc.norm.s" >"${OUT_DIR}/format_u32_to_hex.sasc.semantic.txt"
diff -u "${OUT_DIR}/format_u32_to_hex.original.semantic.txt" "${OUT_DIR}/format_u32_to_hex.sasc.semantic.txt" >"${OUT_DIR}/format_u32_to_hex.semantic.diff" || true

echo "wrote: ${OUT_DIR}/format_u32_to_hex.diff"
echo "wrote: ${OUT_DIR}/format_u32_to_hex.semantic.diff"
