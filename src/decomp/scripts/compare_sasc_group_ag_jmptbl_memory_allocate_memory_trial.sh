#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="group_ag_jmptbl_memory_allocate_memory.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/g/xjump.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="GROUP_AG_JMPTBL_MEMORY_AllocateMemory"
TARGET="MEMORY_AllocateMemory"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_group_ag_jmptbl_memory_allocate_memory.log" 2>&1

awk '$0 ~ /^GROUP_AG_JMPTBL_MEMORY_AllocateMemory:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.s"
awk '$0 ~ /^[[:space:]]*GROUP_AG_JMPTBL_MEMORY_Allocat/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.dis.s"

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

normalize <"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.s" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.norm.s"
normalize <"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.dis.s" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.norm.s"

diff -u "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.norm.s" "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.norm.s" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_memory_allocate_memory.awk "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.norm.s" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_memory_allocate_memory.awk "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.norm.s" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.semantic.txt"
diff -u "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.original.semantic.txt" "${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.sasc.semantic.txt" >"${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.semantic.diff" || true

echo "wrote: ${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.diff"
echo "wrote: ${OUT_DIR}/group_ag_jmptbl_memory_allocate_memory.semantic.diff"
