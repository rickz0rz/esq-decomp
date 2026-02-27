#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

COMPARE_SCRIPT="src/decomp/scripts/compare_group_af_jmptbl_gcommand_save_brush_result_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/group_af_jmptbl_gcommand_save_brush_result.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/group_af_jmptbl_gcommand_save_brush_result.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

echo "promotion gate: gcc group_af_jmptbl_gcommand_save_brush_result target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/group_af_jmptbl_gcommand_save_brush_result.compare.log" 2>&1
echo "compare ok: group_af_jmptbl_gcommand_save_brush_result (log: ${LOG_DIR}/group_af_jmptbl_gcommand_save_brush_result.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: group_af_jmptbl_gcommand_save_brush_result" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: group_af_jmptbl_gcommand_save_brush_result"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_group_af_jmptbl_gcommand_save_brush_result.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_group_af_jmptbl_gcommand_save_brush_result.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_group_af_jmptbl_gcommand_save_brush_result.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_group_af_jmptbl_gcommand_save_brush_result.log)"

echo "promotion gate passed"
