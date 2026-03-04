#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown34_pair.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown34.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown34_pair.log" 2>&1

# Original slices
awk '$0 ~ /^LIST_InitHeader:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/list_init.original.s"
awk '$0 ~ /^MEM_Move:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/mem_move.original.s"

# SAS/C disassembly slices
awk '$0 ~ /^LIST_InitHeader:$/ {in_func=1} in_func { if ($0 ~ /^MEM_Move:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/list_init.sasc.dis.s"
awk '$0 ~ /^MEM_Move:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/mem_move.sasc.dis.s"

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

normalize <"${OUT_DIR}/list_init.original.s" >"${OUT_DIR}/list_init.original.norm.s"
normalize <"${OUT_DIR}/list_init.sasc.dis.s" >"${OUT_DIR}/list_init.sasc.norm.s"
normalize <"${OUT_DIR}/mem_move.original.s" >"${OUT_DIR}/mem_move.original.norm.s"
normalize <"${OUT_DIR}/mem_move.sasc.dis.s" >"${OUT_DIR}/mem_move.sasc.norm.s"

diff -u "${OUT_DIR}/list_init.original.norm.s" "${OUT_DIR}/list_init.sasc.norm.s" >"${OUT_DIR}/list_init.diff" || true
diff -u "${OUT_DIR}/mem_move.original.norm.s" "${OUT_DIR}/mem_move.sasc.norm.s" >"${OUT_DIR}/mem_move.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_list_init.awk "${OUT_DIR}/list_init.original.norm.s" >"${OUT_DIR}/list_init.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_list_init.awk "${OUT_DIR}/list_init.sasc.norm.s" >"${OUT_DIR}/list_init.sasc.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_mem_move.awk "${OUT_DIR}/mem_move.original.norm.s" >"${OUT_DIR}/mem_move.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_mem_move.awk "${OUT_DIR}/mem_move.sasc.norm.s" >"${OUT_DIR}/mem_move.sasc.semantic.txt"

diff -u "${OUT_DIR}/list_init.original.semantic.txt" "${OUT_DIR}/list_init.sasc.semantic.txt" >"${OUT_DIR}/list_init.semantic.diff" || true
diff -u "${OUT_DIR}/mem_move.original.semantic.txt" "${OUT_DIR}/mem_move.sasc.semantic.txt" >"${OUT_DIR}/mem_move.semantic.diff" || true

echo "wrote: ${OUT_DIR}/list_init.diff"
echo "wrote: ${OUT_DIR}/mem_move.diff"
echo "wrote: ${OUT_DIR}/list_init.semantic.diff"
echo "wrote: ${OUT_DIR}/mem_move.semantic.diff"
