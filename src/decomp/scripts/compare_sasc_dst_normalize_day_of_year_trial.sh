#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="dst_normalize_day_of_year.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/j/dst2.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="DST_NormalizeDayOfYear"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_dst_normalize_day_of_year.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/dst_normalize_day_of_year.original.s"

awk -v e="^[[:space:]]*${ENTRY_ORIG}:" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^[[:space:]]*__const:$/) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/dst_normalize_day_of_year.sasc.dis.s"

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

normalize <"${OUT_DIR}/dst_normalize_day_of_year.original.s" >"${OUT_DIR}/dst_normalize_day_of_year.original.norm.s"
normalize <"${OUT_DIR}/dst_normalize_day_of_year.sasc.dis.s" >"${OUT_DIR}/dst_normalize_day_of_year.sasc.norm.s"

diff -u "${OUT_DIR}/dst_normalize_day_of_year.original.norm.s" "${OUT_DIR}/dst_normalize_day_of_year.sasc.norm.s" >"${OUT_DIR}/dst_normalize_day_of_year.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_dst_normalize_day_of_year.awk "${OUT_DIR}/dst_normalize_day_of_year.original.norm.s" >"${OUT_DIR}/dst_normalize_day_of_year.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_dst_normalize_day_of_year.awk "${OUT_DIR}/dst_normalize_day_of_year.sasc.norm.s" >"${OUT_DIR}/dst_normalize_day_of_year.sasc.semantic.txt"
diff -u "${OUT_DIR}/dst_normalize_day_of_year.original.semantic.txt" "${OUT_DIR}/dst_normalize_day_of_year.sasc.semantic.txt" >"${OUT_DIR}/dst_normalize_day_of_year.semantic.diff" || true

echo "wrote: ${OUT_DIR}/dst_normalize_day_of_year.diff"
echo "wrote: ${OUT_DIR}/dst_normalize_day_of_year.semantic.diff"
