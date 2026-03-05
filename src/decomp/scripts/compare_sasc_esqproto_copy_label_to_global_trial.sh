#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown_esqproto_copy_label_to_global.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_esqproto_copy_label_to_global.log" 2>&1

awk '$0 ~ /^ESQPROTO_CopyLabelToGlobal:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/esqproto_copy_label_to_global.original.s"
awk '$0 ~ /^[[:space:]]*ESQPROTO_CopyLabelToGlobal:/ {in_func=1} in_func { if ($0 ~ /^[[:space:]]*__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/esqproto_copy_label_to_global.sasc.dis.s"

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

normalize <"${OUT_DIR}/esqproto_copy_label_to_global.original.s" >"${OUT_DIR}/esqproto_copy_label_to_global.original.norm.s"
normalize <"${OUT_DIR}/esqproto_copy_label_to_global.sasc.dis.s" >"${OUT_DIR}/esqproto_copy_label_to_global.sasc.norm.s"

diff -u "${OUT_DIR}/esqproto_copy_label_to_global.original.norm.s" "${OUT_DIR}/esqproto_copy_label_to_global.sasc.norm.s" >"${OUT_DIR}/esqproto_copy_label_to_global.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_esqproto_copy_label_to_global.awk "${OUT_DIR}/esqproto_copy_label_to_global.original.norm.s" >"${OUT_DIR}/esqproto_copy_label_to_global.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_esqproto_copy_label_to_global.awk "${OUT_DIR}/esqproto_copy_label_to_global.sasc.norm.s" >"${OUT_DIR}/esqproto_copy_label_to_global.sasc.semantic.txt"
diff -u "${OUT_DIR}/esqproto_copy_label_to_global.original.semantic.txt" "${OUT_DIR}/esqproto_copy_label_to_global.sasc.semantic.txt" >"${OUT_DIR}/esqproto_copy_label_to_global.semantic.diff" || true

echo "wrote: ${OUT_DIR}/esqproto_copy_label_to_global.diff"
echo "wrote: ${OUT_DIR}/esqproto_copy_label_to_global.semantic.diff"
