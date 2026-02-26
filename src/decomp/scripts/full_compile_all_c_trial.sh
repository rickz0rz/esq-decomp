#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CC_BIN="${CROSS_CC:-/opt/amiga/bin/m68k-amigaos-gcc}"
CFLAGS="${GCC_CFLAGS:--O1 -m68000 -ffreestanding -fno-builtin -fno-inline -fomit-frame-pointer}"
OUT_DIR="build/decomp/full_c_trial"
OBJ_DIR="${OUT_DIR}/obj"
LOG_FILE="${OUT_DIR}/compile.log"

if [ ! -x "$CC_BIN" ]; then
    if command -v m68k-amigaos-gcc >/dev/null 2>&1; then
        CC_BIN="$(command -v m68k-amigaos-gcc)"
    else
        echo "error: GCC compiler not found at '$CC_BIN'" >&2
        echo "set CROSS_CC=/path/to/m68k-amigaos-gcc and retry" >&2
        exit 2
    fi
fi

mkdir -p "$OBJ_DIR"
: > "$LOG_FILE"

mapfile -t SRC_FILES < <(find src/decomp/c/replacements -maxdepth 1 -type f -name '*_gcc.c' | sort)

if [ "${#SRC_FILES[@]}" -eq 0 ]; then
    echo "error: no *_gcc.c sources found under src/decomp/c/replacements" >&2
    exit 1
fi

echo "full C trial: compiling ${#SRC_FILES[@]} replacement units"
echo "compiler: $CC_BIN"
echo "flags: $CFLAGS"

for src in "${SRC_FILES[@]}"; do
    base="$(basename "$src" .c)"
    obj="${OBJ_DIR}/${base}.o"
    echo "  cc  $src" | tee -a "$LOG_FILE"
    "$CC_BIN" -c $CFLAGS -Isrc/decomp/c/include "$src" -o "$obj" >>"$LOG_FILE" 2>&1
done

echo "compiled: ${#SRC_FILES[@]} / ${#SRC_FILES[@]}"

CC_DIR="$(dirname "$CC_BIN")"
LD_BIN="${CROSS_LD:-${CC_DIR}/m68k-amigaos-ld}"
NM_BIN="${CROSS_NM:-${CC_DIR}/m68k-amigaos-nm}"
COMBINED_OBJ="${OUT_DIR}/all_replacements.gcc.o"
EXPORTS_FILE="${OUT_DIR}/exports.txt"

if [ -x "$LD_BIN" ]; then
    if "$LD_BIN" -r -o "$COMBINED_OBJ" "${OBJ_DIR}"/*.o >>"$LOG_FILE" 2>&1; then
        echo "linked relocatable: $COMBINED_OBJ"
    else
        echo "note: $LD_BIN -r failed; trying gcc driver for relocatable link" | tee -a "$LOG_FILE"
        if "$CC_BIN" -r -o "$COMBINED_OBJ" "${OBJ_DIR}"/*.o >>"$LOG_FILE" 2>&1; then
            echo "linked relocatable (via gcc): $COMBINED_OBJ"
        else
            echo "note: relocatable link failed; continuing with per-object export inventory"
            rm -f "$COMBINED_OBJ"
        fi
    fi
else
    echo "note: linker not found at $LD_BIN; skipping relocatable link"
fi

if [ -x "$NM_BIN" ]; then
    if [ -f "$COMBINED_OBJ" ]; then
        "$NM_BIN" -g --defined-only "$COMBINED_OBJ" | awk '$2 ~ /[TDB]/ {print $3}' | sort -u > "$EXPORTS_FILE"
        echo "exports listed: $EXPORTS_FILE"
    else
        "$NM_BIN" -g --defined-only "${OBJ_DIR}"/*.o | awk '$2 ~ /[TDB]/ {print $3}' | sort -u > "$EXPORTS_FILE"
        echo "exports listed (per-object): $EXPORTS_FILE"
    fi
    echo "export count: $(wc -l < "$EXPORTS_FILE" | awk '{print $1}')"
else
    echo "note: nm not found at $NM_BIN; skipping export inventory"
fi

echo "full C trial status: ok"
