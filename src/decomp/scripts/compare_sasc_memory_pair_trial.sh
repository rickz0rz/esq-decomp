#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="test_memory_pair.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/memory.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_memory_pair.log" 2>&1

# Extract original function slices.
awk '$0 ~ /^MEMORY_AllocateMemory:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/ && seen++) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/memory_allocate.original.s"
awk '$0 ~ /^MEMORY_DeallocateMemory:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/memory_deallocate.original.s"

# Extract SAS/C disassembly slices.
awk '$0 ~ /^MEMORY_AllocateMemory:$/ {in_func=1} in_func { if ($0 ~ /^MEMORY_DeallocateMemory:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/memory_allocate.sasc.dis.s"
awk '$0 ~ /^MEMORY_DeallocateMemory:$/ {in_func=1} in_func { if ($0 ~ /^ +XREF /) exit; print }' "$SASC_DIS" >"${OUT_DIR}/memory_deallocate.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^_+//' \
    -e 's/\$ffffff3a\(A6\)/_LVOALLOCMEM(A6)/I' \
    -e 's/\$ffffff2e\(A6\)/_LVOFREEMEM(A6)/I' \
    -e 's/MOVE\.L AbsExecBase\(A4\),A6/MOVEA.L AbsExecBase,A6/I' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/memory_allocate.original.s" >"${OUT_DIR}/memory_allocate.original.norm.s"
normalize <"${OUT_DIR}/memory_allocate.sasc.dis.s" >"${OUT_DIR}/memory_allocate.sasc.norm.s"
normalize <"${OUT_DIR}/memory_deallocate.original.s" >"${OUT_DIR}/memory_deallocate.original.norm.s"
normalize <"${OUT_DIR}/memory_deallocate.sasc.dis.s" >"${OUT_DIR}/memory_deallocate.sasc.norm.s"

diff -u "${OUT_DIR}/memory_allocate.original.norm.s" "${OUT_DIR}/memory_allocate.sasc.norm.s" >"${OUT_DIR}/memory_allocate.diff" || true
diff -u "${OUT_DIR}/memory_deallocate.original.norm.s" "${OUT_DIR}/memory_deallocate.sasc.norm.s" >"${OUT_DIR}/memory_deallocate.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_memory_allocate.awk "${OUT_DIR}/memory_allocate.original.norm.s" >"${OUT_DIR}/memory_allocate.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_memory_allocate.awk "${OUT_DIR}/memory_allocate.sasc.norm.s" >"${OUT_DIR}/memory_allocate.sasc.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_memory_deallocate.awk "${OUT_DIR}/memory_deallocate.original.norm.s" >"${OUT_DIR}/memory_deallocate.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_memory_deallocate.awk "${OUT_DIR}/memory_deallocate.sasc.norm.s" >"${OUT_DIR}/memory_deallocate.sasc.semantic.txt"

diff -u "${OUT_DIR}/memory_allocate.original.semantic.txt" "${OUT_DIR}/memory_allocate.sasc.semantic.txt" >"${OUT_DIR}/memory_allocate.semantic.diff" || true
diff -u "${OUT_DIR}/memory_deallocate.original.semantic.txt" "${OUT_DIR}/memory_deallocate.sasc.semantic.txt" >"${OUT_DIR}/memory_deallocate.semantic.diff" || true
cat "${OUT_DIR}/memory_allocate.semantic.diff" "${OUT_DIR}/memory_deallocate.semantic.diff" >"${OUT_DIR}/memory_pair.semantic.diff"

echo "wrote: ${OUT_DIR}/memory_allocate.diff"
echo "wrote: ${OUT_DIR}/memory_deallocate.diff"
echo "wrote: ${OUT_DIR}/memory_allocate.semantic.diff"
echo "wrote: ${OUT_DIR}/memory_deallocate.semantic.diff"
echo "wrote: ${OUT_DIR}/memory_pair.semantic.diff"

# Quick behavioral checkpoints.
rg -n "_LVOALLOCMEM\(A6\)|ADD\.L D7,Global_MEM_BYTES_ALLOCATED|ADDQ\.L #1,Global_MEM_ALLOC_COUNT" "${OUT_DIR}/memory_allocate.sasc.norm.s" || true
rg -n "_LVOFREEMEM\(A6\)|SUB\.L D7,Global_MEM_BYTES_ALLOCATED|ADDQ\.L #1,Global_MEM_DEALLOC_COUNT|MOVE\.L A5,A1|MOVE\.L D7,D0" "${OUT_DIR}/memory_deallocate.sasc.norm.s" || true
