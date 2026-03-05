#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="dst_format_banner_datetime.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/j/dst2.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_dst_format_banner_datetime.log" 2>&1

awk '$0 ~ /^DST_FormatBannerDateTime:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/dst_format_banner_datetime.original.s"
awk '$0 ~ /^[[:space:]]*DST_FormatBannerDateTime:/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/dst_format_banner_datetime.sasc.dis.s"

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

normalize <"${OUT_DIR}/dst_format_banner_datetime.original.s" >"${OUT_DIR}/dst_format_banner_datetime.original.norm.s"
normalize <"${OUT_DIR}/dst_format_banner_datetime.sasc.dis.s" >"${OUT_DIR}/dst_format_banner_datetime.sasc.norm.s"

diff -u "${OUT_DIR}/dst_format_banner_datetime.original.norm.s" "${OUT_DIR}/dst_format_banner_datetime.sasc.norm.s" >"${OUT_DIR}/dst_format_banner_datetime.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_dst_format_banner_datetime.awk "${OUT_DIR}/dst_format_banner_datetime.original.norm.s" >"${OUT_DIR}/dst_format_banner_datetime.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_dst_format_banner_datetime.awk "${OUT_DIR}/dst_format_banner_datetime.sasc.norm.s" >"${OUT_DIR}/dst_format_banner_datetime.sasc.semantic.txt"
diff -u "${OUT_DIR}/dst_format_banner_datetime.original.semantic.txt" "${OUT_DIR}/dst_format_banner_datetime.sasc.semantic.txt" >"${OUT_DIR}/dst_format_banner_datetime.semantic.diff" || true

echo "wrote: ${OUT_DIR}/dst_format_banner_datetime.diff"
echo "wrote: ${OUT_DIR}/dst_format_banner_datetime.semantic.diff"
