#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown21_iostdreq_free.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown21.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_iostdreq_free.log" 2>&1

awk '$0 ~ /^IOSTDREQ_Free:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/iostdreq_free.original.s"
awk '$0 ~ /^IOSTDREQ_Free:$/ {in_func=1} in_func { if ($0 ~ /^IOSTDREQ_CleanupSignalAndMsgport:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/iostdreq_free.sasc.dis.s"

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

normalize <"${OUT_DIR}/iostdreq_free.original.s" >"${OUT_DIR}/iostdreq_free.original.norm.s"
normalize <"${OUT_DIR}/iostdreq_free.sasc.dis.s" >"${OUT_DIR}/iostdreq_free.sasc.norm.s"

diff -u "${OUT_DIR}/iostdreq_free.original.norm.s" "${OUT_DIR}/iostdreq_free.sasc.norm.s" >"${OUT_DIR}/iostdreq_free.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_iostdreq_free.awk "${OUT_DIR}/iostdreq_free.original.norm.s" >"${OUT_DIR}/iostdreq_free.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_iostdreq_free.awk "${OUT_DIR}/iostdreq_free.sasc.norm.s" >"${OUT_DIR}/iostdreq_free.sasc.semantic.txt"
diff -u "${OUT_DIR}/iostdreq_free.original.semantic.txt" "${OUT_DIR}/iostdreq_free.sasc.semantic.txt" >"${OUT_DIR}/iostdreq_free.semantic.diff" || true

echo "wrote: ${OUT_DIR}/iostdreq_free.diff"
echo "wrote: ${OUT_DIR}/iostdreq_free.semantic.diff"
