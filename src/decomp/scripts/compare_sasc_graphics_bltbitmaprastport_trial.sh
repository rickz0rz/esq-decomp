#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown39_graphics_bltbitmaprastport.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown39.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_graphics_bltbitmaprastport.log" 2>&1

awk '$0 ~ /^GRAPHICS_BltBitMapRastPort:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/graphics_bltbitmaprastport.original.s"
awk '$0 ~ /^GRAPHICS_BltBitMapRastPort:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/graphics_bltbitmaprastport.sasc.dis.s"

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

normalize <"${OUT_DIR}/graphics_bltbitmaprastport.original.s" >"${OUT_DIR}/graphics_bltbitmaprastport.original.norm.s"
normalize <"${OUT_DIR}/graphics_bltbitmaprastport.sasc.dis.s" >"${OUT_DIR}/graphics_bltbitmaprastport.sasc.norm.s"

diff -u "${OUT_DIR}/graphics_bltbitmaprastport.original.norm.s" "${OUT_DIR}/graphics_bltbitmaprastport.sasc.norm.s" >"${OUT_DIR}/graphics_bltbitmaprastport.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_graphics_bltbitmaprastport.awk "${OUT_DIR}/graphics_bltbitmaprastport.original.norm.s" >"${OUT_DIR}/graphics_bltbitmaprastport.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_graphics_bltbitmaprastport.awk "${OUT_DIR}/graphics_bltbitmaprastport.sasc.norm.s" >"${OUT_DIR}/graphics_bltbitmaprastport.sasc.semantic.txt"
diff -u "${OUT_DIR}/graphics_bltbitmaprastport.original.semantic.txt" "${OUT_DIR}/graphics_bltbitmaprastport.sasc.semantic.txt" >"${OUT_DIR}/graphics_bltbitmaprastport.semantic.diff" || true

echo "wrote: ${OUT_DIR}/graphics_bltbitmaprastport.diff"
echo "wrote: ${OUT_DIR}/graphics_bltbitmaprastport.semantic.diff"
