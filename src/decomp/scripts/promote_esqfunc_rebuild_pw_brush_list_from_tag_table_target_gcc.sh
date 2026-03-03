#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_esqfunc_rebuild_pw_brush_list_from_tag_table_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/esqfunc_rebuild_pw_brush_list_from_tag_table.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/esqfunc_rebuild_pw_brush_list_from_tag_table.generated_slice.semantic.txt"

mkdir -p "$LOG_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

echo "promotion gate: gcc esqfunc_rebuild_pw_brush_list_from_tag_table target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/esqfunc_rebuild_pw_brush_list_from_tag_table.compare.log" 2>&1
echo "compare ok: esqfunc_rebuild_pw_brush_list_from_tag_table (log: ${LOG_DIR}/esqfunc_rebuild_pw_brush_list_from_tag_table.compare.log)"

if ! cmp -s "$ORIG_SEM" "$GEN_SEM"; then
    echo "semantic mismatch: esqfunc_rebuild_pw_brush_list_from_tag_table" >&2
    diff -u "$ORIG_SEM" "$GEN_SEM" || true
    exit 1
fi
echo "semantic ok: esqfunc_rebuild_pw_brush_list_from_tag_table"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_esqfunc_rebuild_pw_brush_list_from_tag_table.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_esqfunc_rebuild_pw_brush_list_from_tag_table.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_esqfunc_rebuild_pw_brush_list_from_tag_table.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_esqfunc_rebuild_pw_brush_list_from_tag_table.log)"

echo "promotion gate passed"
