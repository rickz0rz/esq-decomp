#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown_esqproto_verify_checksum_and_parse_record.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="ESQPROTO_VerifyChecksumAndParseRecord"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_esqproto_verify_checksum_and_parse_record.log" 2>&1

awk '$0 ~ /^ESQPROTO_VerifyChecksumAndParseRecord:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.s"
awk '$0 ~ /^[[:space:]]*ESQPROTO_VerifyChecksumAndParseR:/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.dis.s"

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

normalize <"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.s" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.norm.s"
normalize <"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.dis.s" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.norm.s"

diff -u "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.norm.s" "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.norm.s" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_esqproto_verify_checksum_and_parse_record.awk "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.norm.s" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_esqproto_verify_checksum_and_parse_record.awk "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.norm.s" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.semantic.txt"
diff -u "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.original.semantic.txt" "${OUT_DIR}/esqproto_verify_checksum_and_parse_record.sasc.semantic.txt" >"${OUT_DIR}/esqproto_verify_checksum_and_parse_record.semantic.diff" || true

echo "wrote: ${OUT_DIR}/esqproto_verify_checksum_and_parse_record.diff"
echo "wrote: ${OUT_DIR}/esqproto_verify_checksum_and_parse_record.semantic.diff"
