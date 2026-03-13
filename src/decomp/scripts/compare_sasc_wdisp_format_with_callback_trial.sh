#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="wdisp_format_with_callback.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown28.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="WDISP_FormatWithCallback"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_wdisp_format_with_callback.log" 2>&1

awk '$0 ~ /^WDISP_FormatWithCallback:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/wdisp_format_with_callback.original.s"
awk '$0 ~ /^WDISP_FormatWithCallback:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/wdisp_format_with_callback.sasc.dis.s"

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

normalize <"${OUT_DIR}/wdisp_format_with_callback.original.s" >"${OUT_DIR}/wdisp_format_with_callback.original.norm.s"
normalize <"${OUT_DIR}/wdisp_format_with_callback.sasc.dis.s" >"${OUT_DIR}/wdisp_format_with_callback.sasc.norm.s"

diff -u "${OUT_DIR}/wdisp_format_with_callback.original.norm.s" "${OUT_DIR}/wdisp_format_with_callback.sasc.norm.s" >"${OUT_DIR}/wdisp_format_with_callback.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_wdisp_format_with_callback.awk "${OUT_DIR}/wdisp_format_with_callback.original.norm.s" >"${OUT_DIR}/wdisp_format_with_callback.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_wdisp_format_with_callback.awk "${OUT_DIR}/wdisp_format_with_callback.sasc.norm.s" >"${OUT_DIR}/wdisp_format_with_callback.sasc.semantic.txt"
diff -u "${OUT_DIR}/wdisp_format_with_callback.original.semantic.txt" "${OUT_DIR}/wdisp_format_with_callback.sasc.semantic.txt" >"${OUT_DIR}/wdisp_format_with_callback.semantic.diff" || true

echo "wrote: ${OUT_DIR}/wdisp_format_with_callback.diff"
echo "wrote: ${OUT_DIR}/wdisp_format_with_callback.semantic.diff"
