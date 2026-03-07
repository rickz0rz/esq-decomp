#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown29_esq_parse_command_line_and_run.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown29.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="ESQ_ParseCommandLineAndRun"
ENTRY_CANONICAL="ESQ_MainInitAndRun"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_esq_parse_command_line_and_run.log" 2>&1

awk '$0 ~ /^ESQ_ParseCommandLineAndRun:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/esq_parse_command_line_and_run.original.s"
awk '$0 ~ /^ESQ_ParseCommandLineAndRun:$/ || $0 ~ /^ESQ_ParseCommandLineAndRu:$/ {in_func=1} in_func { if ($0 ~ /^UNKNOWN29_JMPTBL_ESQ_MainInitAndRun:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/esq_parse_command_line_and_run.sasc.dis.s"

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

normalize <"${OUT_DIR}/esq_parse_command_line_and_run.original.s" >"${OUT_DIR}/esq_parse_command_line_and_run.original.norm.s"
normalize <"${OUT_DIR}/esq_parse_command_line_and_run.sasc.dis.s" >"${OUT_DIR}/esq_parse_command_line_and_run.sasc.norm.s"

diff -u "${OUT_DIR}/esq_parse_command_line_and_run.original.norm.s" "${OUT_DIR}/esq_parse_command_line_and_run.sasc.norm.s" >"${OUT_DIR}/esq_parse_command_line_and_run.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_esq_parse_command_line_and_run.awk "${OUT_DIR}/esq_parse_command_line_and_run.original.norm.s" >"${OUT_DIR}/esq_parse_command_line_and_run.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_esq_parse_command_line_and_run.awk "${OUT_DIR}/esq_parse_command_line_and_run.sasc.norm.s" >"${OUT_DIR}/esq_parse_command_line_and_run.sasc.semantic.txt"
diff -u "${OUT_DIR}/esq_parse_command_line_and_run.original.semantic.txt" "${OUT_DIR}/esq_parse_command_line_and_run.sasc.semantic.txt" >"${OUT_DIR}/esq_parse_command_line_and_run.semantic.diff" || true

echo "wrote: ${OUT_DIR}/esq_parse_command_line_and_run.diff"
echo "wrote: ${OUT_DIR}/esq_parse_command_line_and_run.semantic.diff"
