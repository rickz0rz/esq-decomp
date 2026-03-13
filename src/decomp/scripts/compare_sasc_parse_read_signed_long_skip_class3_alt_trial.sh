#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="PARSE_ReadSignedLongSkipClass3_Alt"

SASC_SRC="parse_read_signed_long_skip_class3_alt.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown24.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_parse_read_signed_long_skip_class3_alt.log" 2>&1

awk '$0 ~ /^PARSE_ReadSignedLongSkipClass3_Alt:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.s"
awk '$0 ~ /^PARSE_ReadSignedLongSkipClass3(_Alt|_A):$/ {in_func=1} in_func { if ($0 ~ /^__const:$/ || $0 ~ /^XREF / || $0 ~ /^XDEF / || $0 ~ /^END$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^PARSE_ReadSignedLongSkipClass3_A:$/PARSE_ReadSignedLongSkipClass3_Alt:/' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^const:$/d' \
    -e '/^strings:$/d' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.norm.s"
normalize <"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.dis.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.norm.s"

diff -u "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.norm.s" "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3_alt.awk "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parse_read_signed_long_skip_class3_alt.awk "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.norm.s" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.semantic.txt"
diff -u "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.original.semantic.txt" "${OUT_DIR}/parse_read_signed_long_skip_class3_alt.sasc.semantic.txt" >"${OUT_DIR}/parse_read_signed_long_skip_class3_alt.semantic.diff" || true

echo "wrote: ${OUT_DIR}/parse_read_signed_long_skip_class3_alt.diff"
echo "wrote: ${OUT_DIR}/parse_read_signed_long_skip_class3_alt.semantic.diff"
