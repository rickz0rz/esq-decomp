#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_esqiff_render_weather_status_brush_slice_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/esqiff_render_weather_status_brush_slice.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/esqiff_render_weather_status_brush_slice.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

echo "promotion gate: gcc esqiff_render_weather_status_brush_slice target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/esqiff_render_weather_status_brush_slice.compare.log" 2>&1
echo "compare ok: esqiff_render_weather_status_brush_slice (log: ${LOG_DIR}/esqiff_render_weather_status_brush_slice.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: esqiff_render_weather_status_brush_slice" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: esqiff_render_weather_status_brush_slice"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_esqiff_render_weather_status_brush_slice.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_esqiff_render_weather_status_brush_slice.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_esqiff_render_weather_status_brush_slice.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_esqiff_render_weather_status_brush_slice.log)"

echo "promotion gate passed"
