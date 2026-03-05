#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer.c"
SASC_DIS="src/decomp/sas_c/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/x/xjump.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer"
ENTRY_ORIG="GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer"
ENTRY_SASC="GROUP_AX_JMPTBL_FORMAT_RawDoFmtW"
TARGET="FORMAT_RawDoFmtWithScratchBuffer"

mkdir -p "$OUT_DIR"
./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '$0 ~ e {inf=1} inf { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"
awk -v e="^${ENTRY_SASC}:$" '$0 ~ e {inf=1} inf { if ($0 ~ /^XREF / || $0 ~ /^XDEF / || $0 ~ /^ END$/ || $0 ~ /^END$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/${BASE}.sasc.dis.s"

normalize() {
  sed -E -e 's/;.*$//' -e 's/^[[:space:]]+//' -e 's/[[:space:]]+/ /g' -e 's/[[:space:]]+$//' \
         -e '/^$/d' -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' -e '/^const:$/d' -e '/^strings:$/d' -e '/^$/d'
}

normalize <"${OUT_DIR}/${BASE}.original.s" >"${OUT_DIR}/${BASE}.original.norm.s"
normalize <"${OUT_DIR}/${BASE}.sasc.dis.s" >"${OUT_DIR}/${BASE}.sasc.norm.s"
diff -u "${OUT_DIR}/${BASE}.original.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.diff" || true

awk -v TARGET="$TARGET" -f src/decomp/scripts/semantic_filter_sasc_jmptbl_stub.awk "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -v TARGET="$TARGET" -f src/decomp/scripts/semantic_filter_sasc_jmptbl_stub.awk "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
