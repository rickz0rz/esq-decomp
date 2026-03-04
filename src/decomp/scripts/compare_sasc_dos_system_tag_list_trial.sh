#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown40_dos_system_tag_list.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown40.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_dos_system_tag_list.log" 2>&1

awk '$0 ~ /^DOS_SystemTagList:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/dos_system_tag_list.original.s"
awk '$0 ~ /^DOS_SystemTagList:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/dos_system_tag_list.sasc.dis.s"

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

normalize <"${OUT_DIR}/dos_system_tag_list.original.s" >"${OUT_DIR}/dos_system_tag_list.original.norm.s"
normalize <"${OUT_DIR}/dos_system_tag_list.sasc.dis.s" >"${OUT_DIR}/dos_system_tag_list.sasc.norm.s"

diff -u "${OUT_DIR}/dos_system_tag_list.original.norm.s" "${OUT_DIR}/dos_system_tag_list.sasc.norm.s" >"${OUT_DIR}/dos_system_tag_list.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_dos_system_tag_list.awk "${OUT_DIR}/dos_system_tag_list.original.norm.s" >"${OUT_DIR}/dos_system_tag_list.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_dos_system_tag_list.awk "${OUT_DIR}/dos_system_tag_list.sasc.norm.s" >"${OUT_DIR}/dos_system_tag_list.sasc.semantic.txt"
diff -u "${OUT_DIR}/dos_system_tag_list.original.semantic.txt" "${OUT_DIR}/dos_system_tag_list.sasc.semantic.txt" >"${OUT_DIR}/dos_system_tag_list.semantic.diff" || true

echo "wrote: ${OUT_DIR}/dos_system_tag_list.diff"
echo "wrote: ${OUT_DIR}/dos_system_tag_list.semantic.diff"
