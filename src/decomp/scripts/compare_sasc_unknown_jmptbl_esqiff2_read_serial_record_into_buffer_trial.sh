#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown_jmptbl_core_stubs.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.log" 2>&1

awk '$0 ~ /^UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/ || $0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.s"
awk '$0 ~ /^[[:space:]]*UNKNOWN_JMPTBL_ESQIFF2_ReadSeri/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*UNKNOWN_JMPTBL_DISPLIB_DisplayText/ || /^[[:space:]]*UNKNOWN_JMPTBL_DISPLIB_DisplayT/ || $0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.s" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.norm.s"
normalize <"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.dis.s" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.norm.s"

diff -u "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.norm.s" "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.awk "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.norm.s" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.awk "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.original.semantic.txt" "${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.sasc.semantic.txt" >"${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.diff"
echo "wrote: ${OUT_DIR}/unknown_jmptbl_esqiff2_read_serial_record_into_buffer.semantic.diff"
