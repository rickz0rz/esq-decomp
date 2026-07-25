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
VAMOS_ACTIVATE="${VAMOS_ACTIVATE:-$HOME/Downloads/vamos/bin/activate}"
SCOPTS="${SCOPTS:-NOSTKCHK DATA=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128}"   # options MUST precede the filename;
                                                          # CODENAME/DATANAME make sc emit into the
                                                          # same sections as the asm, so PC-relative
                                                          # calls into C resolve at link time. See AGENTS.md
BUILD=build
UNITS=$BUILD/units
OBJ=$BUILD/obj

for bin in "$VASM_BIN" "$VLINK_BIN"; do
    [ -x "$bin" ] || { echo "error: not executable: $bin" >&2; exit 1; }
done

mkdir -p "$OBJ"
# Drop C-replacement objects from any previous run. Their count varies with the
# manifest, so a build with fewer replacements would otherwise leave higher-
# numbered objects behind for tooling to pick up and misreport.
rm -f "$OBJ"/c_repl_*.o

echo "==> reference (monolithic)"
"$VASM_BIN" -I src -Fhunkexe -nosym -o "$BUILD/ESQ_reference" src/Prevue.asm >/dev/null
shasum -a 256 "$BUILD/ESQ_reference"

echo "==> generating link units"
python3 tools/gen_units.py

echo "==> assembling units"
fail=0
cnum=0
: > "$BUILD/objlist"
while read -r u; do
    case "$u" in
    C:*)
        # a C replacement: compile with SAS/C 6.51 under vamos.
        # NOSTKCHK matches the stock build, which has no __XCOVF prologue.
        spec="${u#C:}"; cfile="src/${spec%%|*}"
        extra=""; [ "$spec" != "${spec#*|}" ] && extra="${spec#*|}"
        cnum=$((cnum + 1))
        cobj="$OBJ/c_repl_$cnum.o"
        cwork="$BUILD/cwork_$cnum"
        rm -rf "$cwork"; mkdir -p "$cwork"; cp "$cfile" "$cwork/u.c"
        ( . "$VAMOS_ACTIVATE" 2>/dev/null
          vamos --volume work:"$PWD/$cwork" sc:c/sc $SCOPTS $extra \
                OBJNAME=work:u.o work:u.c ) >"$cwork/log" 2>&1
        if [ ! -f "$cwork/u.o" ]; then
            fail=$((fail + 1)); echo "  FAILED (cc): $cfile"
            grep -iE '^(error)|Invalid' "$cwork/log" | head -3
        else
            cp "$cwork/u.o" "$cobj"
            echo "  cc $cfile${extra:+ [+$extra]} -> $(python3 tools/objbytes.py "$cobj" | sed -n 's/^code: //p')"
            echo "$cobj" >> "$BUILD/objlist"
        fi
        ;;
    *)
        if ! "$VASM_BIN" -I src -I "$UNITS" -Fhunk -nosym \
                -o "$OBJ/$u.o" "$UNITS/$u.asm" >"$OBJ/$u.log" 2>&1; then
            fail=$((fail + 1)); echo "  FAILED: $u"; sed -n '1,4p' "$OBJ/$u.log"
        fi
        echo "$OBJ/$u.o" >> "$BUILD/objlist"
        ;;
    esac
done < "$UNITS/ORDER"
[ "$fail" -eq 0 ] || { echo "error: $fail unit(s) failed to build" >&2; exit 1; }

echo "==> linking"
# -Rstd: emit a plain relocation table. -s: no symbol hunk.
# Absolute hardware symbols for C restorations. vasm cannot export absolute
# equates and vlink -D only works inside a linker script, so the definitions are
# supplied as a synthesised EXT_ABS object. src/modules/c-exports.s asserts these
# values still match hardware-addresses.s. Appended last: it defines symbols only
# and contributes no bytes, so it cannot affect layout.
python3 tools/mkabsdefs.py "$OBJ/absdefs.o" _VPOSR=0xDFF004 _CIAB_PRA=0xBFD000 _SERDAT=0xDFF030
echo "$OBJ/absdefs.o" >> "$BUILD/objlist"
< "$BUILD/objlist" xargs "$VLINK_BIN" -bamigahunk -Rstd -s -o "$BUILD/ESQ"

echo "==> verifying split build against reference"
python3 tools/hunkcmp.py "$BUILD/ESQ_reference" "$BUILD/ESQ"
