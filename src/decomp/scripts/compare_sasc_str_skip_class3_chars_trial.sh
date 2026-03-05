#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown7_str_core_helpers.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown7.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_str_skip_class3_chars.log" 2>&1

awk '$0 ~ /^STR_SkipClass3Chars:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/str_skip_class3_chars.original.s"
awk '$0 ~ /^STR_SkipClass3Chars:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/str_skip_class3_chars.sasc.dis.s"

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

normalize <"${OUT_DIR}/str_skip_class3_chars.original.s" >"${OUT_DIR}/str_skip_class3_chars.original.norm.s"
normalize <"${OUT_DIR}/str_skip_class3_chars.sasc.dis.s" >"${OUT_DIR}/str_skip_class3_chars.sasc.norm.s"

diff -u "${OUT_DIR}/str_skip_class3_chars.original.norm.s" "${OUT_DIR}/str_skip_class3_chars.sasc.norm.s" >"${OUT_DIR}/str_skip_class3_chars.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_str_skip_class3_chars.awk "${OUT_DIR}/str_skip_class3_chars.original.norm.s" >"${OUT_DIR}/str_skip_class3_chars.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_str_skip_class3_chars.awk "${OUT_DIR}/str_skip_class3_chars.sasc.norm.s" >"${OUT_DIR}/str_skip_class3_chars.sasc.semantic.txt"
diff -u "${OUT_DIR}/str_skip_class3_chars.original.semantic.txt" "${OUT_DIR}/str_skip_class3_chars.sasc.semantic.txt" >"${OUT_DIR}/str_skip_class3_chars.semantic.diff" || true

echo "wrote: ${OUT_DIR}/str_skip_class3_chars.diff"
echo "wrote: ${OUT_DIR}/str_skip_class3_chars.semantic.diff"
