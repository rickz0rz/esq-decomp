#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_diskio_draw_transfer_error_message_if_diagnostics_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/diskio_draw_transfer_error_message_if_diagnostics.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/diskio_draw_transfer_error_message_if_diagnostics.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/diskio_draw_transfer_error_message_if_diagnostics.compare.log" 2>&1
echo "compare ok: diskio_draw_transfer_error_message_if_diagnostics"
if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then echo "semantic mismatch: diskio_draw_transfer_error_message_if_diagnostics" >&2; diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; fi
echo "semantic ok: diskio_draw_transfer_error_message_if_diagnostics"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_diskio_draw_transfer_error_message_if_diagnostics.log" 2>&1
echo "decomp-build ok"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_diskio_draw_transfer_error_message_if_diagnostics.log" 2>&1
echo "test-hash ok"
echo "promotion gate passed"
