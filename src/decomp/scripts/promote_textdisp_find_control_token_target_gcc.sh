#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

COMPARE_SCRIPT="src/decomp/scripts/compare_textdisp_find_control_token_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/textdisp_find_control_token.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/textdisp_find_control_token.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

echo "promotion gate: gcc textdisp_find_control_token target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/textdisp_find_control_token.compare.log" 2>&1
echo "compare ok: textdisp_find_control_token (log: ${LOG_DIR}/textdisp_find_control_token.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: textdisp_find_control_token" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: textdisp_find_control_token"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_textdisp_find_control_token.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_textdisp_find_control_token.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_textdisp_find_control_token.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_textdisp_find_control_token.log)"

echo "promotion gate passed"
