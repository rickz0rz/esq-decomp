#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown42_parallel_hw_and_rawdofmt.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown42.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_parallel_writecharhw.log" 2>&1

awk '$0 ~ /^PARALLEL_WriteCharHw:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/parallel_writecharhw.original.s"
awk '$0 ~ /^PARALLEL_WriteCharHw:$/ {in_func=1} in_func { if ($0 ~ /^PARALLEL_RawDoFmt:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/parallel_writecharhw.sasc.dis.s"

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

normalize <"${OUT_DIR}/parallel_writecharhw.original.s" >"${OUT_DIR}/parallel_writecharhw.original.norm.s"
normalize <"${OUT_DIR}/parallel_writecharhw.sasc.dis.s" >"${OUT_DIR}/parallel_writecharhw.sasc.norm.s"

diff -u "${OUT_DIR}/parallel_writecharhw.original.norm.s" "${OUT_DIR}/parallel_writecharhw.sasc.norm.s" >"${OUT_DIR}/parallel_writecharhw.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_parallel_writecharhw.awk "${OUT_DIR}/parallel_writecharhw.original.norm.s" >"${OUT_DIR}/parallel_writecharhw.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parallel_writecharhw.awk "${OUT_DIR}/parallel_writecharhw.sasc.norm.s" >"${OUT_DIR}/parallel_writecharhw.sasc.semantic.txt"
diff -u "${OUT_DIR}/parallel_writecharhw.original.semantic.txt" "${OUT_DIR}/parallel_writecharhw.sasc.semantic.txt" >"${OUT_DIR}/parallel_writecharhw.semantic.diff" || true

echo "wrote: ${OUT_DIR}/parallel_writecharhw.diff"
echo "wrote: ${OUT_DIR}/parallel_writecharhw.semantic.diff"
