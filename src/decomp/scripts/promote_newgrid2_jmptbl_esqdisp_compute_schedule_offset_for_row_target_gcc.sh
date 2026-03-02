#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

COMPARE_SCRIPT="src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

echo "promotion gate: gcc newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.compare.log" 2>&1
echo "compare ok: newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row (log: ${LOG_DIR}/newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.log)"

echo "promotion gate passed"
