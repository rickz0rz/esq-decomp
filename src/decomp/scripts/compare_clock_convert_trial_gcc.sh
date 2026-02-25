#!/bin/bash
set -euo pipefail

SRC_C="src/decomp/c/replacements/clock_convert_amiga_seconds_gcc.c"
ORIG_ASM="src/decomp/replacements/modules/submodules/unknown41.s"
OUT_DIR="build/decomp/c_trial_gcc"
GEN_ASM="${OUT_DIR}/clock_convert.generated.gcc.s"
ORIG_SLICE="${OUT_DIR}/clock_convert.original_slice.s"
GEN_SLICE="${OUT_DIR}/clock_convert.generated_slice.s"
ORIG_NORM="${OUT_DIR}/clock_convert.original_slice.norm.s"
GEN_NORM="${OUT_DIR}/clock_convert.generated_slice.norm.s"

CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS="${GCC_CFLAGS:--O0 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

if [ ! -x "$CC_BIN" ]; then
    if command -v m68k-amigaos-gcc >/dev/null 2>&1; then
        CC_BIN="$(command -v m68k-amigaos-gcc)"
    else
        echo "error: GCC compiler not found at '$CC_BIN'" >&2
        echo "set CROSS_CC=/path/to/m68k-amigaos-gcc and retry" >&2
        exit 2
    fi
fi

mkdir -p "$OUT_DIR"

"$CC_BIN" \
    -S \
    $GCC_CFLAGS \
    -Isrc/decomp/c/include \
    "$SRC_C" \
    -o "$GEN_ASM"

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
    -e '/^#APP$/d' \
    -e '/^#NO_APP$/d' \
    -e '/^| /d' \
    -e 's/^_//' \
    -e 's/ _/ /g' \
    -e 's/:[[:space:]]*$/:/' \
    "$ORIG_SLICE" > "$ORIG_NORM"

# Normalize common GAS m68k style into closer vasm-like text for easier diffing.
sed \
    -e 's/\r$//' \
    -e 's/^[[:space:]]*//' \
    -e 's/[[:space:]]\+/ /g' \
    -e '/^#APP$/d' \
    -e '/^#NO_APP$/d' \
    -e '/^| /d' \
    -e 's/^_//' \
    -e 's/ _/ /g' \
    -e 's/:[[:space:]]*$/:/' \
    -e 's/%sp/A7/g' \
    -e 's/%a\([0-7]\)/A\1/g' \
    -e 's/%d\([0-7]\)/D\1/g' \
    "$GEN_SLICE" \
    | awk '
{
    if ($0 ~ /^[a-z]/) {
        first=$1
        $1=toupper(first)
    }
    print
}' > "$GEN_NORM"

echo "normalized original: $ORIG_NORM"
echo "normalized generated: $GEN_NORM"
diff -u "$ORIG_NORM" "$GEN_NORM" || true
