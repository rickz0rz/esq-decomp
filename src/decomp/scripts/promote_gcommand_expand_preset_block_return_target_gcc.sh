#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_gcommand_expand_preset_block_return_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/gcommand_expand_preset_block_return.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/gcommand_expand_preset_block_return.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/gcommand_expand_preset_block_return.compare.log" 2>&1
echo "compare ok: gcommand_expand_preset_block_return"
if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then echo "semantic mismatch: gcommand_expand_preset_block_return" >&2; diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; fi
echo "semantic ok: gcommand_expand_preset_block_return"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_gcommand_expand_preset_block_return.log" 2>&1
echo "decomp-build ok"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_gcommand_expand_preset_block_return.log" 2>&1
echo "test-hash ok"
echo "promotion gate passed"
