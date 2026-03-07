#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown30_exec_call_vector_348.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown30.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="EXEC_CallVector_348"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_exec_call_vector_348.log" 2>&1

awk '$0 ~ /^EXEC_CallVector_348:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/exec_call_vector_348.original.s"
awk '$0 ~ /^EXEC_CallVector_348:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/exec_call_vector_348.sasc.dis.s"

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

normalize <"${OUT_DIR}/exec_call_vector_348.original.s" >"${OUT_DIR}/exec_call_vector_348.original.norm.s"
normalize <"${OUT_DIR}/exec_call_vector_348.sasc.dis.s" >"${OUT_DIR}/exec_call_vector_348.sasc.norm.s"

diff -u "${OUT_DIR}/exec_call_vector_348.original.norm.s" "${OUT_DIR}/exec_call_vector_348.sasc.norm.s" >"${OUT_DIR}/exec_call_vector_348.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_exec_call_vector_348.awk "${OUT_DIR}/exec_call_vector_348.original.norm.s" >"${OUT_DIR}/exec_call_vector_348.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_exec_call_vector_348.awk "${OUT_DIR}/exec_call_vector_348.sasc.norm.s" >"${OUT_DIR}/exec_call_vector_348.sasc.semantic.txt"
diff -u "${OUT_DIR}/exec_call_vector_348.original.semantic.txt" "${OUT_DIR}/exec_call_vector_348.sasc.semantic.txt" >"${OUT_DIR}/exec_call_vector_348.semantic.diff" || true

echo "wrote: ${OUT_DIR}/exec_call_vector_348.diff"
echo "wrote: ${OUT_DIR}/exec_call_vector_348.semantic.diff"
