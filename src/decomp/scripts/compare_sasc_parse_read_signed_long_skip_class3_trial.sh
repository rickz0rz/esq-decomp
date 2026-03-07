#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="PARSE_ReadSignedLongSkipClass3"

SASC_SRC="unknown24_parse_read_signed_long_skip_class3.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown24.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_parse_read_signed_long_skip_class3.log" 2>&1

awk '$0 ~ /^PARSE_ReadSignedLongSkipClass3:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/parse_read_signed_long_skip_class3.original.s"
awk '$0 ~ /^PARSE_ReadSignedLongSkipClass3:$/ {in_func=1} in_func { if ($0 ~ /^PARSE_ReadSignedLongSkipClass3_Alt:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.dis.s"

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

normalize <"${OUT_DIR}/parse_read_signed_long_skip_class3.original.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3.original.norm.s"
normalize <"${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.dis.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.norm.s"

diff -u "${OUT_DIR}/parse_read_signed_long_skip_class3.original.norm.s" "${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3.awk "${OUT_DIR}/parse_read_signed_long_skip_class3.original.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3.awk "${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.semantic.txt"
diff -u "${OUT_DIR}/parse_read_signed_long_skip_class3.original.semantic.txt" "${OUT_DIR}/parse_read_signed_long_skip_class3.sasc.semantic.txt" >"${OUT_DIR}/parse_read_signed_long_skip_class3.semantic.diff" || true

echo "wrote: ${OUT_DIR}/parse_read_signed_long_skip_class3.diff"
echo "wrote: ${OUT_DIR}/parse_read_signed_long_skip_class3.semantic.diff"
