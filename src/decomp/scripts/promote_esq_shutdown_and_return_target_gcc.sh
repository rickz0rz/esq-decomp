#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_esq_shutdown_and_return_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/esq_shutdown_and_return.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/esq_shutdown_and_return.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}" GCC_CFLAGS="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/esq_shutdown_and_return.compare.log" 2>&1
cmp -s "$ORIG_SEM" "$GEN_SEM"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_esq_shutdown_and_return.log" 2>&1
bash ./test-hash.sh >"${LOG_DIR}/test-hash_esq_shutdown_and_return.log" 2>&1
