#!/bin/bash
set -euo pipefail

ROOT_ASM="src/Prevue.asm"
REPLACEMENT_MAP="src/decomp/replacements.map"
HYBRID_ROOT="build/decomp/Prevue_hybrid.asm"
BASELINE_OBJ="build/decomp/esq_baseline.o"
BASELINE_OUT="build/decomp/ESQ_baseline"
HYBRID_OBJ="build/decomp/esq_decomp.o"
HYBRID_OUT="build/ESQ_decomp"
GEN_HYBRID_SCRIPT="src/decomp/scripts/gen_hybrid_root.sh"
EXPECTED_HASH="6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2"

VASM_BIN="${VASM_BIN:-$HOME/Downloads/vasm/vasmm68k_mot}"
VLINK_BIN="${VLINK_BIN:-$HOME/Downloads/vbcc_installer/vlink/vlink}"

if [ ! -x "$VASM_BIN" ]; then
    echo "error: vasm binary not executable: $VASM_BIN" >&2
    echo "set VASM_BIN=<path-to-vasmm68k_mot>" >&2
    exit 1
fi

if [ ! -x "$VLINK_BIN" ]; then
    echo "error: vlink binary not executable: $VLINK_BIN" >&2
    echo "set VLINK_BIN=<path-to-vlink>" >&2
    exit 1
fi

mkdir -p build/decomp

"$GEN_HYBRID_SCRIPT" "$ROOT_ASM" "$REPLACEMENT_MAP" "$HYBRID_ROOT"

"$VASM_BIN" -I src -Fhunk -nosym -o "$BASELINE_OBJ" "$ROOT_ASM"
"$VLINK_BIN" -bamigahunk -k "$BASELINE_OBJ" -o "$BASELINE_OUT"
"$VASM_BIN" -I src -Fhunk -nosym -o "$HYBRID_OBJ" "$HYBRID_ROOT"
"$VLINK_BIN" -bamigahunk -k "$HYBRID_OBJ" -o "$HYBRID_OUT"

BASELINE_HASH_LINE="$(shasum -a 256 "$BASELINE_OUT")"
BASELINE_HASH_VALUE="$(echo "$BASELINE_HASH_LINE" | awk '{print $1}')"
HASH_LINE="$(shasum -a 256 "$HYBRID_OUT")"
HASH_VALUE="$(echo "$HASH_LINE" | awk '{print $1}')"

echo "$BASELINE_HASH_LINE"
echo "$HASH_LINE"
echo "reference: $EXPECTED_HASH"

if [ "$HASH_VALUE" = "$BASELINE_HASH_VALUE" ]; then
    echo "status: hybrid matches local baseline pipeline"
elif [ "$HASH_VALUE" = "$EXPECTED_HASH" ]; then
    echo "status: hybrid matches canonical baseline"
else
    echo "status: hash diverged from local baseline (expected during active decomp replacements)"
fi
