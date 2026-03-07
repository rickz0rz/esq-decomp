#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ENTRY="PARALLEL_CheckReadyStub"

SASC_SRC="unknown42_parallel_ready.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown42.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_parallel_checkready_stub.log" 2>&1

awk '$0 ~ /^PARALLEL_CheckReadyStub:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/parallel_checkready_stub.original.s"
awk '$0 ~ /^PARALLEL_CheckReadyStub:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/parallel_checkready_stub.sasc.dis.s"

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

normalize <"${OUT_DIR}/parallel_checkready_stub.original.s" >"${OUT_DIR}/parallel_checkready_stub.original.norm.s"
normalize <"${OUT_DIR}/parallel_checkready_stub.sasc.dis.s" >"${OUT_DIR}/parallel_checkready_stub.sasc.norm.s"

diff -u "${OUT_DIR}/parallel_checkready_stub.original.norm.s" "${OUT_DIR}/parallel_checkready_stub.sasc.norm.s" >"${OUT_DIR}/parallel_checkready_stub.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_parallel_checkready_stub.awk "${OUT_DIR}/parallel_checkready_stub.original.norm.s" >"${OUT_DIR}/parallel_checkready_stub.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parallel_checkready_stub.awk "${OUT_DIR}/parallel_checkready_stub.sasc.norm.s" >"${OUT_DIR}/parallel_checkready_stub.sasc.semantic.txt"
diff -u "${OUT_DIR}/parallel_checkready_stub.original.semantic.txt" "${OUT_DIR}/parallel_checkready_stub.sasc.semantic.txt" >"${OUT_DIR}/parallel_checkready_stub.semantic.diff" || true

echo "wrote: ${OUT_DIR}/parallel_checkready_stub.diff"
echo "wrote: ${OUT_DIR}/parallel_checkready_stub.semantic.diff"
