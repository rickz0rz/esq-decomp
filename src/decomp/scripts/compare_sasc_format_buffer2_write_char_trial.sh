#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown27_format_buffer2.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown27.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="FORMAT_Buffer2WriteChar"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_format_buffer2_write_char.log" 2>&1

awk '$0 ~ /^FORMAT_Buffer2WriteChar:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/format_buffer2_write_char.original.s"
awk '$0 ~ /^FORMAT_Buffer2WriteChar:$/ {in_func=1} in_func { if ($0 ~ /^FORMAT_FormatToBuffer2:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/format_buffer2_write_char.sasc.dis.s"

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

normalize <"${OUT_DIR}/format_buffer2_write_char.original.s" >"${OUT_DIR}/format_buffer2_write_char.original.norm.s"
normalize <"${OUT_DIR}/format_buffer2_write_char.sasc.dis.s" >"${OUT_DIR}/format_buffer2_write_char.sasc.norm.s"

diff -u "${OUT_DIR}/format_buffer2_write_char.original.norm.s" "${OUT_DIR}/format_buffer2_write_char.sasc.norm.s" >"${OUT_DIR}/format_buffer2_write_char.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_format_buffer2_write_char.awk "${OUT_DIR}/format_buffer2_write_char.original.norm.s" >"${OUT_DIR}/format_buffer2_write_char.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_format_buffer2_write_char.awk "${OUT_DIR}/format_buffer2_write_char.sasc.norm.s" >"${OUT_DIR}/format_buffer2_write_char.sasc.semantic.txt"
diff -u "${OUT_DIR}/format_buffer2_write_char.original.semantic.txt" "${OUT_DIR}/format_buffer2_write_char.sasc.semantic.txt" >"${OUT_DIR}/format_buffer2_write_char.semantic.diff" || true

echo "wrote: ${OUT_DIR}/format_buffer2_write_char.diff"
echo "wrote: ${OUT_DIR}/format_buffer2_write_char.semantic.diff"
