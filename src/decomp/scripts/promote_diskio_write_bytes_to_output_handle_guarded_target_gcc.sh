#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_diskio_write_bytes_to_output_handle_guarded_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/diskio_write_bytes_to_output_handle_guarded.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/diskio_write_bytes_to_output_handle_guarded.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/diskio_write_bytes_to_output_handle_guarded.compare.log" 2>&1
echo "compare ok: diskio_write_bytes_to_output_handle_guarded"
if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then echo "semantic mismatch: diskio_write_bytes_to_output_handle_guarded" >&2; diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; fi
echo "semantic ok: diskio_write_bytes_to_output_handle_guarded"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_diskio_write_bytes_to_output_handle_guarded.log" 2>&1
echo "decomp-build ok"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_diskio_write_bytes_to_output_handle_guarded.log" 2>&1
echo "test-hash ok"
echo "promotion gate passed"
