#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown22_allocate_alloc_and_initialize_iostdreq.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown22.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="ALLOCATE_AllocAndInitializeIOStdReq"
ENTRY_SASC_REGEX="^ALLOCATE_AllocAndInitializeIOStd[A-Za-z0-9_]*:$"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_allocate_alloc_and_initialize_iostdreq.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.s"

awk -v e="^${ENTRY_ORIG}:$" -v e2="$ENTRY_SASC_REGEX" '
  $0 ~ e || $0 ~ e2 {in_func=1}
  in_func {
    if ($0 ~ /^__const:$/) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.dis.s"

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

normalize <"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.s" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.norm.s"
normalize <"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.dis.s" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.norm.s"

diff -u "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.norm.s" "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.norm.s" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_allocate_alloc_and_initialize_iostdreq.awk "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.norm.s" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_allocate_alloc_and_initialize_iostdreq.awk "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.norm.s" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.semantic.txt"
diff -u "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.original.semantic.txt" "${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.sasc.semantic.txt" >"${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.semantic.diff" || true

echo "wrote: ${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.diff"
echo "wrote: ${OUT_DIR}/allocate_alloc_and_initialize_iostdreq.semantic.diff"
