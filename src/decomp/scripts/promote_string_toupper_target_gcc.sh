#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

TOUPPER_COMPARE_SCRIPT="src/decomp/scripts/compare_string_toupper_trial_gcc.sh"
TOUPPER_ORIG_SEM="${OUT_DIR}/string_toupper.original_slice.semantic.txt"
TOUPPER_GEN_SEM="${OUT_DIR}/string_toupper.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

echo "promotion gate: gcc string_toupper target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$TOUPPER_COMPARE_SCRIPT" >"${LOG_DIR}/string_toupper.compare.log" 2>&1
echo "compare ok: string_toupper (log: ${LOG_DIR}/string_toupper.compare.log)"

if ! cmp -s "$TOUPPER_ORIG_SEM" "$TOUPPER_GEN_SEM"; then
    echo "semantic mismatch: string_toupper" >&2
    diff -u "$TOUPPER_ORIG_SEM" "$TOUPPER_GEN_SEM" || true
    exit 1
fi
echo "semantic ok: string_toupper"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_toupper.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_toupper.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_toupper.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_toupper.log)"

echo "promotion gate passed"
