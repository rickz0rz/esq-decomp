#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_displib_reset_line_tables_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/displib_reset_line_tables.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/displib_reset_line_tables.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

echo "promotion gate: gcc displib_reset_line_tables target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/displib_reset_line_tables.compare.log" 2>&1
echo "compare ok: displib_reset_line_tables (log: ${LOG_DIR}/displib_reset_line_tables.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: displib_reset_line_tables" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: displib_reset_line_tables"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_displib_reset_line_tables.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_displib_reset_line_tables.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_displib_reset_line_tables.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_displib_reset_line_tables.log)"

echo "promotion gate passed"
