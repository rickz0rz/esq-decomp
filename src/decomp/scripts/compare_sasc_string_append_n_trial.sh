#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown5_string_append_n.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown5.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_string_append_n.log" 2>&1

awk '$0 ~ /^STRING_AppendN:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/string_append_n.original.s"
awk '$0 ~ /^STRING_AppendN:$/ {in_func=1} in_func { if ($0 ~ /^STRING_CompareNoCase:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/string_append_n.sasc.dis.s"

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

normalize <"${OUT_DIR}/string_append_n.original.s" >"${OUT_DIR}/string_append_n.original.norm.s"
normalize <"${OUT_DIR}/string_append_n.sasc.dis.s" >"${OUT_DIR}/string_append_n.sasc.norm.s"

diff -u "${OUT_DIR}/string_append_n.original.norm.s" "${OUT_DIR}/string_append_n.sasc.norm.s" >"${OUT_DIR}/string_append_n.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_string_append_n.awk "${OUT_DIR}/string_append_n.original.norm.s" >"${OUT_DIR}/string_append_n.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_string_append_n.awk "${OUT_DIR}/string_append_n.sasc.norm.s" >"${OUT_DIR}/string_append_n.sasc.semantic.txt"
diff -u "${OUT_DIR}/string_append_n.original.semantic.txt" "${OUT_DIR}/string_append_n.sasc.semantic.txt" >"${OUT_DIR}/string_append_n.semantic.diff" || true

echo "wrote: ${OUT_DIR}/string_append_n.diff"
echo "wrote: ${OUT_DIR}/string_append_n.semantic.diff"
