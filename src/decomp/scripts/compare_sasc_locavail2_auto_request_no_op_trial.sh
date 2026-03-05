#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="locavail2_auto_request_no_op.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/z/locavail2.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="locavail2_auto_request_no_op"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk '$0 ~ /^LOCAVAIL2_AutoRequestNoOp:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' \
    "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"

awk '$0 ~ /^LOCAVAIL2_AutoRequestNoOp:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' \
    "$SASC_DIS" >"${OUT_DIR}/${BASE}.sasc.dis.s"

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

normalize <"${OUT_DIR}/${BASE}.original.s" >"${OUT_DIR}/${BASE}.original.norm.s"
normalize <"${OUT_DIR}/${BASE}.sasc.dis.s" >"${OUT_DIR}/${BASE}.sasc.norm.s"

diff -u "${OUT_DIR}/${BASE}.original.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_locavail2_auto_request_no_op.awk \
    "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_locavail2_auto_request_no_op.awk \
    "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"

diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
