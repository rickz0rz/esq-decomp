#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_esqshared4_clear_banner_work_raster_with_ones_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/esqshared4_clear_banner_work_raster_with_ones.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/esqshared4_clear_banner_work_raster_with_ones.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

echo "promotion gate: gcc esqshared4_clear_banner_work_raster_with_ones target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/esqshared4_clear_banner_work_raster_with_ones.compare.log" 2>&1
echo "compare ok: esqshared4_clear_banner_work_raster_with_ones (log: ${LOG_DIR}/esqshared4_clear_banner_work_raster_with_ones.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: esqshared4_clear_banner_work_raster_with_ones" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: esqshared4_clear_banner_work_raster_with_ones"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_esqshared4_clear_banner_work_raster_with_ones.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_esqshared4_clear_banner_work_raster_with_ones.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_esqshared4_clear_banner_work_raster_with_ones.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_esqshared4_clear_banner_work_raster_with_ones.log)"

echo "promotion gate passed"
