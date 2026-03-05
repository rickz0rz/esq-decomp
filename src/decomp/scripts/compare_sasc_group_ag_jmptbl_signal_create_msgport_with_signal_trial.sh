#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="group_ag_jmptbl_signal_struct_stubs.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/g/xjump.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_group_ag_jmptbl_signal_create_msgport_with_signal.log" 2>&1

awk '$0 ~ /^GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.s"
awk '$0 ~ /^[[:space:]]*GROUP_AG_JMPTBL_SIGNAL_Create/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*GROUP_AG_JMPTBL_STRUCT_Free/ || $0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.dis.s"

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

normalize <"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.s" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.norm.s"
normalize <"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.dis.s" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.norm.s"

diff -u "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.norm.s" "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.norm.s" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_signal_create_msgport_with_signal.awk "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.norm.s" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_group_ag_jmptbl_signal_create_msgport_with_signal.awk "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.norm.s" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.semantic.txt"
diff -u "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.original.semantic.txt" "${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.sasc.semantic.txt" >"${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.semantic.diff" || true

echo "wrote: ${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.diff"
echo "wrote: ${OUT_DIR}/group_ag_jmptbl_signal_create_msgport_with_signal.semantic.diff"
