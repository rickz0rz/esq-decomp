#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown_jmptbl_core_stubs.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown_jmptbl_displib_display_text_at_position.log" 2>&1

awk '$0 ~ /^UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/ || $0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.s"
awk '$0 ~ /^[[:space:]]*UNKNOWN_JMPTBL_DISPLIB_DisplayTe/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*UNKNOWN_JMPTBL_ESQ_WildcardMatch/ || /^[[:space:]]*UNKNOWN_JMPTBL_ESQ_WildcardMat/ || $0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.s" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.norm.s"
normalize <"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.dis.s" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.norm.s"

diff -u "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.norm.s" "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_displib_display_text_at_position.awk "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.norm.s" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_displib_display_text_at_position.awk "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.original.semantic.txt" "${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.sasc.semantic.txt" >"${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.diff"
echo "wrote: ${OUT_DIR}/unknown_jmptbl_displib_display_text_at_position.semantic.diff"
