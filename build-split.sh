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
ESQ_EXACT="${ESQ_EXACT:-1}"          # 1 = byte-matching arm (default), 0 = pure-C fallback
SCOPTS="${SCOPTS:-NOSTKCHK DATA=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128} DEFINE=ESQ_EXACT=$ESQ_EXACT"   # options MUST precede the filename;
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

# A C extern must dereference a global as many times as the original does. Get
# it wrong and the code reads a different address while every byte check stays
# green: DATA=FAR makes each access an absolute long carrying a relocation, and
# cdiff.sh masks relocated fields by definition. The emitted size does not move
# either. That is how a clock-format table read one level too shallow removed
# every time-slot label from the grid banner and passed the soak, menusweep and
# framecolor. Only the addressing mode the original uses can settle it.
if [ -n "${C_REPLACEMENTS:-}" ]; then
    echo "==> checking C extern shapes against the original's addressing"
    if ! python3 tools/data_shape_audit.py; then
        echo "*** ABORT: a C extern disagrees with the data it names. ***"
        exit 1
    fi
fi

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
        cp src/c/*.h "$cwork/" 2>/dev/null || true   # see cmatch.sh
        ( . "$VAMOS_ACTIVATE" 2>/dev/null
          vamos --volume work:"$PWD/$cwork" sc:c/sc $SCOPTS $extra \
                OBJNAME=work:u.o work:u.c ) >"$cwork/log" 2>&1
        if [ ! -f "$cwork/u.o" ]; then
            fail=$((fail + 1)); echo "  FAILED (cc): $cfile"
            grep -iE 'error [0-9]+:|^(error)|Invalid' "$cwork/log" | head -3
        else
            cp "$cwork/u.o" "$cobj"
            echo "  cc $cfile${extra:+ [+$extra]} -> $(python3 tools/objbytes.py "$cobj" | sed -n 's/^code: //p')"
            echo "$cobj" >> "$BUILD/objlist"
        fi
        ;;
    *)
        # $UNITS/far comes FIRST so an ESQ_FARCALLS=1 rewrite shadows the original
        # module; gen_units.py empties that directory when the flag is off, so a
        # default build resolves everything from src/ exactly as before.
        if ! "$VASM_BIN" -I "$UNITS/far" -I src -I "$UNITS" -Fhunk -nosym \
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
python3 tools/mkabsdefs.py "$OBJ/absdefs.o" _VPOSR=0xDFF004 _CIAB_PRA=0xBFD000 _SERDAT=0xDFF030 _INTENA=0xDFF09A _SysBase=0x4
echo "$OBJ/absdefs.o" >> "$BUILD/objlist"
# SCLIB pulls in SAS/C's runtime helpers (__CXD33 and friends -- the 32-bit
# divide routines the compiler calls for `/` and `%`). Only a maximum-C build
# needs it; the byte-exact manifest never reaches code that calls them, and
# linking a library that contributes nothing is harmless but noisy, so it is
# opt-in. See AGENTS.md, "Library code is not application code".
# Accept either a bare library name (resolved by vlink's -l search) or a full
# path to a .lib, which vlink takes as an ordinary input file. The datetime
# restorations need this: their `/` and `%` on longs compile to calls to __CXD22,
# SAS/C's 32-bit divide helper, where the original called its own MATH_DivS32.
SCLIB="${SCLIB:-}"
SCLIB_ARGS=()
if [ -n "$SCLIB" ]; then
    if [ -f "$SCLIB" ]; then SCLIB_ARGS=("$SCLIB"); else SCLIB_ARGS=(-l"$SCLIB"); fi
fi
# Delete the previous binary FIRST and abort if the link fails. vlink leaves the
# old build/ESQ in place on an undefined-symbol error, and a stale binary that
# still boots will happily PASS tools/probe_esq.sh -- which it did: a 289-entry
# manifest whose link failed on four undefined symbols "passed", because what got
# probed was the pure-assembly build from the previous command.
rm -f "$BUILD/ESQ"
LINKLOG="$BUILD/link.log"
if ! < "$BUILD/objlist" xargs "$VLINK_BIN" -bamigahunk -Rstd -s ${SCLIB_ARGS[@]+"${SCLIB_ARGS[@]}"} -o "$BUILD/ESQ" 2>&1 | tee "$LINKLOG"; then :; fi
if [ ! -f "$BUILD/ESQ" ]; then
    # Error 28 on a LARGE manifest almost always means CODE=FAR was left out, not
    # that the manifest outgrew the address space. Without it `sc` emits BSR.W for
    # every call, so any C caller more than 32767 bytes from its callee fails --
    # and the errors name innocent restorations, which sends you dropping entries
    # that were never the problem. Say so here rather than in a comment nobody
    # reads until after the third rebuild.
    # The two causes are told apart by WHICH object vlink names. A `c_*.o` that is
    # a compiled restoration means CODE=FAR. An assembly unit means the program's
    # own 16-bit references have been stretched, and only ESQ_FARCALLS=1 fixes
    # that -- CODE=FAR does nothing for them.
    if grep -q "Error 28" "$LINKLOG" 2>/dev/null; then
        echo
        if ! [[ "$SCOPTS" == *CODE=FAR* ]]; then
            echo "*** Error 28 and CODE=FAR is NOT set. Retry with:"
            echo "      SCOPTS=\"NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128\" \\"
            echo "        C_REPLACEMENTS=$C_REPLACEMENTS ./build-split.sh"
            echo "    Byte-exact manifests must NOT use it -- it changes the call encoding."
        fi
        if [ "${ESQ_FARCALLS:-0}" != "1" ]; then
            echo "*** Error 28 and ESQ_FARCALLS is NOT set. If the object named above is an"
            echo "    assembly unit, the assembly's own 16-bit references are out of range."
            echo "    CODE=FAR cannot fix those. Prefix the command with ESQ_FARCALLS=1."
            echo "    Byte-exact manifests must NOT use it -- see AGENTS.md."
        fi
    fi
    echo "*** LINK FAILED -- no binary produced ***"
    exit 1
fi
[ -f "$BUILD/ESQ" ] || { echo "*** LINK produced no binary ***"; exit 1; }

# A 16-bit PC-relative call whose target drifts past +/-32767 is written by vlink
# with a WRAPPED displacement and no diagnostic, so the call jumps 65536 bytes into
# arbitrary code. Nothing else here can see it: the CODE size is unchanged, the
# relocation count is unchanged (a same-section PC-relative reference emits no
# reloc either way), and both byte gates stay green. That is precisely how the
# ESC-menu guru hid for as long as it did. Relink with symbols to get a map and
# check every such call before believing any build.
echo "==> checking 16-bit PC-relative call range"
if < "$BUILD/objlist" xargs "$VLINK_BIN" -bamigahunk -Rstd ${SCLIB_ARGS[@]+"${SCLIB_ARGS[@]}"} \
       -M -o "$BUILD/ESQ_mapprobe" > "$BUILD/ESQ.map" 2>&1; then
    if ! python3 tools/check_pcrel_range.py "$BUILD/ESQ" "$BUILD/ESQ.map"; then
        echo "*** ABORT: the linker silently truncated a call. This build is broken. ***"
        exit 1
    fi
else
    echo "  (map link failed -- range check skipped; see $BUILD/ESQ.map)"
fi

echo "==> verifying split build against reference"
python3 tools/hunkcmp.py "$BUILD/ESQ_reference" "$BUILD/ESQ"
