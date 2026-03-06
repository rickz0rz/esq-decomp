#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown21_dos_open_new_file_if_missing.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown21.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="DOS_OpenNewFileIfMissing"
NEXT_ENTRY_SASC="DOS_DeleteAndRecreateFile"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_dos_open_new_file_if_missing.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/dos_open_new_file_if_missing.original.s"

awk -v e="^${ENTRY_ORIG}:$" -v n="^${NEXT_ENTRY_SASC}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ n) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/dos_open_new_file_if_missing.sasc.dis.s"

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

normalize <"${OUT_DIR}/dos_open_new_file_if_missing.original.s" >"${OUT_DIR}/dos_open_new_file_if_missing.original.norm.s"
normalize <"${OUT_DIR}/dos_open_new_file_if_missing.sasc.dis.s" >"${OUT_DIR}/dos_open_new_file_if_missing.sasc.norm.s"

diff -u "${OUT_DIR}/dos_open_new_file_if_missing.original.norm.s" "${OUT_DIR}/dos_open_new_file_if_missing.sasc.norm.s" >"${OUT_DIR}/dos_open_new_file_if_missing.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_dos_open_new_file_if_missing.awk "${OUT_DIR}/dos_open_new_file_if_missing.original.norm.s" >"${OUT_DIR}/dos_open_new_file_if_missing.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_dos_open_new_file_if_missing.awk "${OUT_DIR}/dos_open_new_file_if_missing.sasc.norm.s" >"${OUT_DIR}/dos_open_new_file_if_missing.sasc.semantic.txt"
diff -u "${OUT_DIR}/dos_open_new_file_if_missing.original.semantic.txt" "${OUT_DIR}/dos_open_new_file_if_missing.sasc.semantic.txt" >"${OUT_DIR}/dos_open_new_file_if_missing.semantic.diff" || true

echo "wrote: ${OUT_DIR}/dos_open_new_file_if_missing.diff"
echo "wrote: ${OUT_DIR}/dos_open_new_file_if_missing.semantic.diff"
