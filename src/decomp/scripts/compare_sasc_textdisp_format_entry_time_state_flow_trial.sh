#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/sasc_trial"
BASE="textdisp_format_entry_time_state_flow"

mkdir -p "$OUT_DIR"

bash src/decomp/scripts/compare_sasc_textdisp_format_entry_time_trial.sh >"${OUT_DIR}/compare_${BASE}.log" 2>&1

cp "${OUT_DIR}/textdisp_format_entry_time.original.norm.s" "${OUT_DIR}/${BASE}.original.norm.s"
cp "${OUT_DIR}/textdisp_format_entry_time.sasc.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s"
cp "${OUT_DIR}/textdisp_format_entry_time.diff" "${OUT_DIR}/${BASE}.diff"

awk -f src/decomp/scripts/semantic_filter_sasc_textdisp_format_entry_time_state_flow.awk \
    "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_textdisp_format_entry_time_state_flow.awk \
    "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
