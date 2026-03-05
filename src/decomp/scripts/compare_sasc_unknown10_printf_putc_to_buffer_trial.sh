#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown10_printf_putc_to_buffer.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown10.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown10_printf_putc_to_buffer.log" 2>&1

awk '$0 ~ /^UNKNOWN10_PrintfPutcToBuffer:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.original.s"
awk '$0 ~ /^UNKNOWN10_PrintfPutcToBuffer:$/ {in_func=1} in_func { if ($0 ~ /^WDISP_SPrintf:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown10_printf_putc_to_buffer.original.s" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.original.norm.s"
normalize <"${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.dis.s" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.norm.s"

diff -u "${OUT_DIR}/unknown10_printf_putc_to_buffer.original.norm.s" "${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.norm.s" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown10_printf_putc_to_buffer.awk "${OUT_DIR}/unknown10_printf_putc_to_buffer.original.norm.s" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown10_printf_putc_to_buffer.awk "${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.norm.s" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown10_printf_putc_to_buffer.original.semantic.txt" "${OUT_DIR}/unknown10_printf_putc_to_buffer.sasc.semantic.txt" >"${OUT_DIR}/unknown10_printf_putc_to_buffer.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown10_printf_putc_to_buffer.diff"
echo "wrote: ${OUT_DIR}/unknown10_printf_putc_to_buffer.semantic.diff"
