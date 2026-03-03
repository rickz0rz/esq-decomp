#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/esqdisp_get_entry_pointer_by_mode.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/esqdisp_get_entry_pointer_by_mode.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/esqdisp_get_entry_pointer_by_mode.compare.log" 2>&1
cmp -s "$ORIG_SEM" "$GEN_SEM" || { diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; }
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_esqdisp_get_entry_pointer_by_mode.log" 2>&1
bash ./test-hash.sh >"${LOG_DIR}/test-hash_esqdisp_get_entry_pointer_by_mode.log" 2>&1
echo "promotion gate passed"
