#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown18_dos_seek_with_error_state.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown18.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="DOS_SeekWithErrorState"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_dos_seek_with_error_state.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/dos_seek_with_error_state.original.s"

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^__const:$/) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/dos_seek_with_error_state.sasc.dis.s"

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

normalize <"${OUT_DIR}/dos_seek_with_error_state.original.s" >"${OUT_DIR}/dos_seek_with_error_state.original.norm.s"
normalize <"${OUT_DIR}/dos_seek_with_error_state.sasc.dis.s" >"${OUT_DIR}/dos_seek_with_error_state.sasc.norm.s"

diff -u "${OUT_DIR}/dos_seek_with_error_state.original.norm.s" "${OUT_DIR}/dos_seek_with_error_state.sasc.norm.s" >"${OUT_DIR}/dos_seek_with_error_state.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_dos_seek_with_error_state.awk "${OUT_DIR}/dos_seek_with_error_state.original.norm.s" >"${OUT_DIR}/dos_seek_with_error_state.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_dos_seek_with_error_state.awk "${OUT_DIR}/dos_seek_with_error_state.sasc.norm.s" >"${OUT_DIR}/dos_seek_with_error_state.sasc.semantic.txt"
diff -u "${OUT_DIR}/dos_seek_with_error_state.original.semantic.txt" "${OUT_DIR}/dos_seek_with_error_state.sasc.semantic.txt" >"${OUT_DIR}/dos_seek_with_error_state.semantic.diff" || true

echo "wrote: ${OUT_DIR}/dos_seek_with_error_state.diff"
echo "wrote: ${OUT_DIR}/dos_seek_with_error_state.semantic.diff"
