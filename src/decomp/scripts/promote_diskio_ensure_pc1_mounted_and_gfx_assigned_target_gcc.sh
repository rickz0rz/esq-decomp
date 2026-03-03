#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_diskio_ensure_pc1_mounted_and_gfx_assigned_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/diskio_ensure_pc1_mounted_and_gfx_assigned.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/diskio_ensure_pc1_mounted_and_gfx_assigned.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/diskio_ensure_pc1_mounted_and_gfx_assigned.compare.log" 2>&1
echo "compare ok: diskio_ensure_pc1_mounted_and_gfx_assigned"
if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then echo "semantic mismatch: diskio_ensure_pc1_mounted_and_gfx_assigned" >&2; diff -u "$ORIG_SEM" "$GEN_SEM" || true; exit 1; fi
echo "semantic ok: diskio_ensure_pc1_mounted_and_gfx_assigned"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_diskio_ensure_pc1_mounted_and_gfx_assigned.log" 2>&1
echo "decomp-build ok"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_diskio_ensure_pc1_mounted_and_gfx_assigned.log" 2>&1
echo "test-hash ok"
echo "promotion gate passed"
