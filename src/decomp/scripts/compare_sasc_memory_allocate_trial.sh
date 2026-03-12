#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="memory_allocate.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/memory.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY="MEMORY_AllocateMemory"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_memory_allocate.log" 2>&1

awk -v e="^${ENTRY}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;------------------------------------------------------------------------------/ && seen++) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/memory_allocate.original.s"

awk -v e="^${ENTRY}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^__const:$/) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/memory_allocate.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^_+//' \
    -e 's/\$ffffff3a\(A6\)/_LVOALLOCMEM(A6)/I' \
    -e 's/MOVE\.L AbsExecBase\(A4\),A6/MOVEA.L AbsExecBase,A6/I' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^const:$/d' \
    -e '/^strings:$/d' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/memory_allocate.original.s" >"${OUT_DIR}/memory_allocate.original.norm.s"
normalize <"${OUT_DIR}/memory_allocate.sasc.dis.s" >"${OUT_DIR}/memory_allocate.sasc.norm.s"

diff -u "${OUT_DIR}/memory_allocate.original.norm.s" "${OUT_DIR}/memory_allocate.sasc.norm.s" >"${OUT_DIR}/memory_allocate.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_memory_allocate.awk "${OUT_DIR}/memory_allocate.original.norm.s" >"${OUT_DIR}/memory_allocate.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_memory_allocate.awk "${OUT_DIR}/memory_allocate.sasc.norm.s" >"${OUT_DIR}/memory_allocate.sasc.semantic.txt"
diff -u "${OUT_DIR}/memory_allocate.original.semantic.txt" "${OUT_DIR}/memory_allocate.sasc.semantic.txt" >"${OUT_DIR}/memory_allocate.semantic.diff" || true

echo "wrote: ${OUT_DIR}/memory_allocate.diff"
echo "wrote: ${OUT_DIR}/memory_allocate.semantic.diff"

rg -n "_LVOALLOCMEM\(A6\)|ADD\.L D7,Global_MEM_BYTES_ALLOCATED|ADDQ\.L #1,Global_MEM_ALLOC_COUNT" "${OUT_DIR}/memory_allocate.sasc.norm.s" || true
