#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/sasc_trial"
BASE="diskio1_format_time_slot_mask_flags_state_flow"

mkdir -p "$OUT_DIR"

bash src/decomp/scripts/compare_sasc_diskio1_format_time_slot_mask_flags_trial.sh >"${OUT_DIR}/compare_${BASE}.log" 2>&1

cp "${OUT_DIR}/diskio1_format_time_slot_mask_flags.original.norm.s" "${OUT_DIR}/${BASE}.original.norm.s"
cp "${OUT_DIR}/diskio1_format_time_slot_mask_flags.sasc.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s"
cp "${OUT_DIR}/diskio1_format_time_slot_mask_flags.diff" "${OUT_DIR}/${BASE}.diff"

awk -f src/decomp/scripts/semantic_filter_sasc_diskio1_format_time_slot_mask_flags_state_flow.awk \
    "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_diskio1_format_time_slot_mask_flags_state_flow.awk \
    "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
