#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown27_format_buffer2.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown27.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_format_to_buffer2.log" 2>&1

awk '$0 ~ /^FORMAT_FormatToBuffer2:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/format_to_buffer2.original.s"
awk '$0 ~ /^FORMAT_FormatToBuffer2:$/ {in_func=1} in_func { if ($0 ~ /^FORMAT_ParseFormatSpec:$/ || $0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/format_to_buffer2.sasc.dis.s"

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

normalize <"${OUT_DIR}/format_to_buffer2.original.s" >"${OUT_DIR}/format_to_buffer2.original.norm.s"
normalize <"${OUT_DIR}/format_to_buffer2.sasc.dis.s" >"${OUT_DIR}/format_to_buffer2.sasc.norm.s"

diff -u "${OUT_DIR}/format_to_buffer2.original.norm.s" "${OUT_DIR}/format_to_buffer2.sasc.norm.s" >"${OUT_DIR}/format_to_buffer2.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_format_to_buffer2.awk "${OUT_DIR}/format_to_buffer2.original.norm.s" >"${OUT_DIR}/format_to_buffer2.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_format_to_buffer2.awk "${OUT_DIR}/format_to_buffer2.sasc.norm.s" >"${OUT_DIR}/format_to_buffer2.sasc.semantic.txt"
diff -u "${OUT_DIR}/format_to_buffer2.original.semantic.txt" "${OUT_DIR}/format_to_buffer2.sasc.semantic.txt" >"${OUT_DIR}/format_to_buffer2.semantic.diff" || true

echo "wrote: ${OUT_DIR}/format_to_buffer2.diff"
echo "wrote: ${OUT_DIR}/format_to_buffer2.semantic.diff"
