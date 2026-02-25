#!/bin/bash
set -euo pipefail

SRC_C="src/decomp/c/replacements/clock_convert_amiga_seconds.c"
ORIG_ASM="src/decomp/replacements/modules/submodules/unknown41.s"
OUT_DIR="build/decomp/c_trial"
GEN_ASM="${OUT_DIR}/clock_convert.generated.s"
ORIG_SLICE="${OUT_DIR}/clock_convert.original_slice.s"
GEN_SLICE="${OUT_DIR}/clock_convert.generated_slice.s"
ORIG_NORM="${OUT_DIR}/clock_convert.original_slice.norm.s"
GEN_NORM="${OUT_DIR}/clock_convert.generated_slice.norm.s"

CC_BIN="${CROSS_CC:-}"
VBCC_ROOT="${VBCC_ROOT:-/Users/rj/Downloads/vbcc_installer}"
VBCC_BIN_DEFAULT="${VBCC_ROOT}/vbcc/bin/vc"
VBCC_CFLAGS="${VBCC_CFLAGS:--use-framepointer}"

if [ -z "${CC_BIN}" ]; then
    if [ -x "$VBCC_BIN_DEFAULT" ]; then
        CC_BIN="$VBCC_BIN_DEFAULT"
    fi
fi

if [ -z "${CC_BIN}" ]; then
    for candidate in vc m68k-amigaos-gcc m68k-elf-gcc m68k-linux-gnu-gcc; do
        if command -v "$candidate" >/dev/null 2>&1; then
            CC_BIN="$candidate"
            break
        fi
    done
fi

if [ -z "${CC_BIN}" ]; then
    echo "error: no m68k C compiler found" >&2
    echo "install one of: vc (+aos68k), m68k-amigaos-gcc, m68k-elf-gcc, m68k-linux-gnu-gcc" >&2
    echo "or set CROSS_CC=<compiler> and retry" >&2
    exit 2
fi

mkdir -p "$OUT_DIR"

if [[ "$CC_BIN" == *"/vc" || "$CC_BIN" == "vc" ]]; then
    export VBCC="$VBCC_ROOT"
    export PATH="${VBCC_ROOT}/vbcc/bin:${PATH}"
    "$CC_BIN" \
        +aos68k \
        -S \
        -O=0 \
        $VBCC_CFLAGS \
        -Isrc/decomp/c/include \
        "$SRC_C" \
        -o "$GEN_ASM"
else
    "$CC_BIN" \
        -S \
        -O0 \
        -m68000 \
        -ffreestanding \
        -fno-builtin \
        -fno-inline \
        -fno-omit-frame-pointer \
        -Isrc/decomp/c/include \
        "$SRC_C" \
        -o "$GEN_ASM"
fi

awk '
$0 ~ /^CLOCK_ConvertAmigaSecondsToClockData:?$/ {in_func=1}
in_func {
    print
    if (tolower($1) == "rts") {
        exit
    }
}
' "$ORIG_ASM" > "$ORIG_SLICE"

awk '
$0 ~ /^_?CLOCK_ConvertAmigaSecondsToClockData:?$/ {in_func=1}
in_func {
    print
    if (tolower($1) == "rts") {
        exit
    }
}
' "$GEN_ASM" > "$GEN_SLICE"

echo "compiler: $CC_BIN"
echo "generated: $GEN_ASM"
echo "original slice: $ORIG_SLICE"
echo "generated slice: $GEN_SLICE"

diff -u "$ORIG_SLICE" "$GEN_SLICE" || true

sed \
    -e 's/\r$//' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]\+/ /g' \
    -e 's/^_//' \
    -e 's/ _/ /g' \
    -e 's/:[[:space:]]*$/:/' \
    "$ORIG_SLICE" > "$ORIG_NORM"

sed \
    -e 's/\r$//' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]\+/ /g' \
    -e 's/^_//' \
    -e 's/ _/ /g' \
    -e 's/:[[:space:]]*$/:/' \
    "$GEN_SLICE" > "$GEN_NORM"

echo "normalized original: $ORIG_NORM"
echo "normalized generated: $GEN_NORM"
diff -u "$ORIG_NORM" "$GEN_NORM" || true
