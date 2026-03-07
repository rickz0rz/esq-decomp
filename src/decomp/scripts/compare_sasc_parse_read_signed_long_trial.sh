#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="PARSE_ReadSignedLong"

SASC_SRC="unknown10_parse_read_signed_long.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown10.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_parse_read_signed_long.log" 2>&1

awk '$0 ~ /^PARSE_ReadSignedLong:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/parse_read_signed_long.original.s"
awk '$0 ~ /^PARSE_ReadSignedLong:$/ {in_func=1} in_func { if ($0 ~ /^PARSE_ReadSignedLong_NoBranch:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/parse_read_signed_long.sasc.dis.s"

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

normalize <"${OUT_DIR}/parse_read_signed_long.original.s" >"${OUT_DIR}/parse_read_signed_long.original.norm.s"
normalize <"${OUT_DIR}/parse_read_signed_long.sasc.dis.s" >"${OUT_DIR}/parse_read_signed_long.sasc.norm.s"

diff -u "${OUT_DIR}/parse_read_signed_long.original.norm.s" "${OUT_DIR}/parse_read_signed_long.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long.awk "${OUT_DIR}/parse_read_signed_long.original.norm.s" >"${OUT_DIR}/parse_read_signed_long.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long.awk "${OUT_DIR}/parse_read_signed_long.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long.sasc.semantic.txt"
diff -u "${OUT_DIR}/parse_read_signed_long.original.semantic.txt" "${OUT_DIR}/parse_read_signed_long.sasc.semantic.txt" >"${OUT_DIR}/parse_read_signed_long.semantic.diff" || true

echo "wrote: ${OUT_DIR}/parse_read_signed_long.diff"
echo "wrote: ${OUT_DIR}/parse_read_signed_long.semantic.diff"
