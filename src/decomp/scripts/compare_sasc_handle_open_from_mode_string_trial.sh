#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown14_handle_open_from_mode_string.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown14.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_handle_open_from_mode_string.log" 2>&1

awk '$0 ~ /^HANDLE_OpenFromModeString:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/handle_open_from_mode_string.original.s"
awk '$0 ~ /^HANDLE_OpenFromModeString:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/handle_open_from_mode_string.sasc.dis.s"

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

normalize <"${OUT_DIR}/handle_open_from_mode_string.original.s" >"${OUT_DIR}/handle_open_from_mode_string.original.norm.s"
normalize <"${OUT_DIR}/handle_open_from_mode_string.sasc.dis.s" >"${OUT_DIR}/handle_open_from_mode_string.sasc.norm.s"

diff -u "${OUT_DIR}/handle_open_from_mode_string.original.norm.s" "${OUT_DIR}/handle_open_from_mode_string.sasc.norm.s" >"${OUT_DIR}/handle_open_from_mode_string.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_handle_open_from_mode_string.awk "${OUT_DIR}/handle_open_from_mode_string.original.norm.s" >"${OUT_DIR}/handle_open_from_mode_string.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_handle_open_from_mode_string.awk "${OUT_DIR}/handle_open_from_mode_string.sasc.norm.s" >"${OUT_DIR}/handle_open_from_mode_string.sasc.semantic.txt"
diff -u "${OUT_DIR}/handle_open_from_mode_string.original.semantic.txt" "${OUT_DIR}/handle_open_from_mode_string.sasc.semantic.txt" >"${OUT_DIR}/handle_open_from_mode_string.semantic.diff" || true

echo "wrote: ${OUT_DIR}/handle_open_from_mode_string.diff"
echo "wrote: ${OUT_DIR}/handle_open_from_mode_string.semantic.diff"
