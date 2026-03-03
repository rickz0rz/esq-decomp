#!/bin/bash
set -euo pipefail

SRC_C="src/decomp/c/replacements/disptext_build_line_with_width_gcc.c"
ORIG_ASM="src/modules/groups/a/i/disptext.s"
OUT_DIR="build/decomp/c_trial_gcc"
GEN_ASM="${OUT_DIR}/disptext_build_line_with_width.generated.gcc.s"
ORIG_SLICE="${OUT_DIR}/disptext_build_line_with_width.original_slice.s"
GEN_SLICE="${OUT_DIR}/disptext_build_line_with_width.generated_slice.s"
ORIG_NORM="${OUT_DIR}/disptext_build_line_with_width.original_slice.norm.s"
GEN_NORM="${OUT_DIR}/disptext_build_line_with_width.generated_slice.norm.s"
ORIG_SEM="${OUT_DIR}/disptext_build_line_with_width.original_slice.semantic.txt"
GEN_SEM="${OUT_DIR}/disptext_build_line_with_width.generated_slice.semantic.txt"

CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
GCC_CFLAGS="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"

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
"$CC_BIN" -S $GCC_CFLAGS -Isrc/decomp/c/include "$SRC_C" -o "$GEN_ASM"

awk '$0 ~ /^DISPTEXT_BuildLineWithWidth:?$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" > "$ORIG_SLICE"
awk '$0 ~ /^_?DISPTEXT_BuildLineWithWidth:?$/ {in_func=1} in_func { print }' "$GEN_ASM" > "$GEN_SLICE"

sed -e 's/\r$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]\+/ /g' -e '/^#APP$/d' -e '/^#NO_APP$/d' -e '/^| /d' -e 's/^_//' -e 's/ _/ /g' -e 's/:[[:space:]]*$/:/' "$ORIG_SLICE" > "$ORIG_NORM"
sed -e 's/\r$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]\+/ /g' -e '/^#APP$/d' -e '/^#NO_APP$/d' -e '/^| /d' -e 's/^_//' -e 's/ _/ /g' -e 's/:[[:space:]]*$/:/' "$GEN_SLICE" > "$GEN_NORM"

awk -f src/decomp/scripts/semantic_filter_disptext_build_line_with_width.awk "$ORIG_NORM" > "$ORIG_SEM"
awk -f src/decomp/scripts/semantic_filter_disptext_build_line_with_width.awk "$GEN_NORM" > "$GEN_SEM"

diff -u "$ORIG_SLICE" "$GEN_SLICE" || true
diff -u "$ORIG_NORM" "$GEN_NORM" || true
diff -u "$ORIG_SEM" "$GEN_SEM" || true
