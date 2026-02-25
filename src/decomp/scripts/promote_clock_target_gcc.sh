#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CROSS_CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS_VALUE="${GCC_CFLAGS:--O0 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/c_trial_gcc"
LOG_DIR="${OUT_DIR}/promotion_logs"

CLOCK_COMPARE_SCRIPT="src/decomp/scripts/compare_clock_convert_trial_gcc.sh"

CLOCK_ORIG_NORM="${OUT_DIR}/clock_convert.original_slice.norm.s"
CLOCK_GEN_NORM="${OUT_DIR}/clock_convert.generated_slice.norm.s"
CLOCK_ORIG_CANON="${OUT_DIR}/clock_convert.original_slice.canon.s"
CLOCK_GEN_CANON="${OUT_DIR}/clock_convert.generated_slice.canon.s"

mkdir -p "$LOG_DIR"

echo "promotion gate: gcc clock target"
echo "compiler: ${CROSS_CC_BIN}"
echo "gcc flags: ${GCC_CFLAGS_VALUE}"

CROSS_CC="$CROSS_CC_BIN" GCC_CFLAGS="$GCC_CFLAGS_VALUE" bash "$CLOCK_COMPARE_SCRIPT" >"${LOG_DIR}/clock_convert.compare.log" 2>&1
echo "compare ok: clock_convert (log: ${LOG_DIR}/clock_convert.compare.log)"

sed \
    -e 's/\r$//' \
    -e '/^$/d' \
    "$CLOCK_ORIG_NORM" \
    | awk '
{
    line = toupper($0)
    gsub(/[[:space:]]+/, " ", line)
    sub(/^ /, "", line)
    sub(/ $/, "", line)
    if (line != "") {
        print line
    }
}' > "$CLOCK_ORIG_CANON"

sed \
    -e 's/\r$//' \
    -e '/^$/d' \
    "$CLOCK_GEN_NORM" \
    | awk '
{
    line = toupper($0)
    gsub(/[[:space:]]+/, " ", line)
    sub(/^ /, "", line)
    sub(/ $/, "", line)
    if (line != "") {
        print line
    }
}' > "$CLOCK_GEN_CANON"

if ! cmp -s "$CLOCK_ORIG_CANON" "$CLOCK_GEN_CANON"; then
    echo "normalized canonical mismatch: clock_convert" >&2
    diff -u "$CLOCK_ORIG_CANON" "$CLOCK_GEN_CANON" || true
    exit 1
fi
echo "normalized canonical ok: clock_convert"

echo "running hybrid build gate"
bash ./decomp-build.sh >"${LOG_DIR}/decomp-build_clock.log" 2>&1
echo "decomp-build ok (log: ${LOG_DIR}/decomp-build_clock.log)"

echo "running canonical hash gate"
bash ./test-hash.sh >"${LOG_DIR}/test-hash_clock.log" 2>&1
echo "test-hash ok (log: ${LOG_DIR}/test-hash_clock.log)"

echo "promotion gate passed"
