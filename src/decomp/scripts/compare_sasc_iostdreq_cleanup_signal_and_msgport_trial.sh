#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown21_iostdreq_cleanup_signal_and_msgport.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown21.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_iostdreq_cleanup_signal_and_msgport.log" 2>&1

awk '$0 ~ /^IOSTDREQ_CleanupSignalAndMsgport:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.s"
awk '$0 ~ /^IOSTDREQ_CleanupSignalAndMsgport:$/ {in_func=1} in_func { if ($0 ~ /^DOS_OpenNewFileIfMissing:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.dis.s"

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

normalize <"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.s" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.norm.s"
normalize <"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.dis.s" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.norm.s"

diff -u "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.norm.s" "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.norm.s" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_iostdreq_cleanup_signal_and_msgport.awk "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.norm.s" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_iostdreq_cleanup_signal_and_msgport.awk "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.norm.s" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.semantic.txt"
diff -u "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.original.semantic.txt" "${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.sasc.semantic.txt" >"${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.semantic.diff" || true

echo "wrote: ${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.diff"
echo "wrote: ${OUT_DIR}/iostdreq_cleanup_signal_and_msgport.semantic.diff"
