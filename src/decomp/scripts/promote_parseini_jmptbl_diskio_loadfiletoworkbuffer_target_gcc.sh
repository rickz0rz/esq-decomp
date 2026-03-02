#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"
COMPARE_SCRIPT="src/decomp/scripts/compare_parseini_jmptbl_diskio_loadfiletoworkbuffer_trial_gcc.sh"
ORIG_SEM="${OUT_DIR}/parseini_jmptbl_diskio_loadfiletoworkbuffer.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/parseini_jmptbl_diskio_loadfiletoworkbuffer.generated_slice.semantic.txt"
mkdir -p "$LOG_DIR"
CROSS_CC="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}" GCC_CFLAGS="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}" bash "$COMPARE_SCRIPT" >"${LOG_DIR}/parseini_jmptbl_diskio_loadfiletoworkbuffer.compare.log" 2>&1
cmp -s "$ORIG_SEM" "$GEN_SEM"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_parseini_jmptbl_diskio_loadfiletoworkbuffer.log" 2>&1
bash ./test-hash.sh >"${LOG_DIR}/test-hash_parseini_jmptbl_diskio_loadfiletoworkbuffer.log" 2>&1
