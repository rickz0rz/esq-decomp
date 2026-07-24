#!/bin/bash
# Build ESQ from separately-assembled objects and prove it matches the reference.
#
# The reference is the monolithic vasm build of src/Prevue.asm, whose SHA-256 is
# checked by test-hash.sh. This script asserts the *split* build is equivalent to
# it in every way that carries program semantics: hunk count, sizes, memory
# flags, every content byte, and the complete relocation set. Relocation table
# *encoding* is allowed to differ -- it is a linker artifact with no runtime
# meaning, and the genuine original ESQ used a different encoding than vasm does.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

VASM_BIN="${VASM_BIN:-$HOME/Downloads/vasm/vasmm68k_mot}"
VLINK_BIN="${VLINK_BIN:-$HOME/Downloads/vbcc_installer/vlink/vlink}"
BUILD=build
UNITS=$BUILD/units
OBJ=$BUILD/obj

for bin in "$VASM_BIN" "$VLINK_BIN"; do
    [ -x "$bin" ] || { echo "error: not executable: $bin" >&2; exit 1; }
done

mkdir -p "$OBJ"

echo "==> reference (monolithic)"
"$VASM_BIN" -I src -Fhunkexe -nosym -o "$BUILD/ESQ_reference" src/Prevue.asm >/dev/null
shasum -a 256 "$BUILD/ESQ_reference"

echo "==> generating link units"
python3 tools/gen_units.py

echo "==> assembling units"
fail=0
while read -r u; do
    if ! "$VASM_BIN" -I src -I "$UNITS" -Fhunk -nosym \
            -o "$OBJ/$u.o" "$UNITS/$u.asm" >"$OBJ/$u.log" 2>&1; then
        fail=$((fail + 1)); echo "  FAILED: $u"; sed -n '1,4p' "$OBJ/$u.log"
    fi
done < "$UNITS/ORDER"
[ "$fail" -eq 0 ] || { echo "error: $fail unit(s) failed to assemble" >&2; exit 1; }

echo "==> linking"
: > "$BUILD/objlist"
while read -r u; do echo "$OBJ/$u.o" >> "$BUILD/objlist"; done < "$UNITS/ORDER"
# -Rstd: emit a plain relocation table. -s: no symbol hunk.
< "$BUILD/objlist" xargs "$VLINK_BIN" -bamigahunk -Rstd -s -o "$BUILD/ESQ"

echo "==> verifying split build against reference"
python3 tools/hunkcmp.py "$BUILD/ESQ_reference" "$BUILD/ESQ"
