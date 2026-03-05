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

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown_jmptbl_esq_generate_xor_checksum_byte.log" 2>&1

awk '$0 ~ /^UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte:$/ {in_func=1} in_func { if ($0 ~ /^;------------------------------------------------------------------------------/ || $0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.s"
awk '$0 ~ /^[[:space:]]*UNKNOWN_JMPTBL_ESQ_Generate/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*ESQPROTO_JMPTBL_ESQPARS_Replace/ || /^[[:space:]]*ESQPROTO_JMPTBL_ESQPARS_Replac/ || $0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.s" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.norm.s"
normalize <"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.dis.s" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.norm.s"

diff -u "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.norm.s" "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esq_generate_xor_checksum_byte.awk "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.norm.s" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown_jmptbl_esq_generate_xor_checksum_byte.awk "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.norm.s" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.original.semantic.txt" "${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.sasc.semantic.txt" >"${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.diff"
echo "wrote: ${OUT_DIR}/unknown_jmptbl_esq_generate_xor_checksum_byte.semantic.diff"
