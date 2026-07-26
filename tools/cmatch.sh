#!/bin/bash
# Compile a C file with SAS/C 6.51 under vamos and diff it against the
# reference bytes of a function in the original build.
#
#   tools/cmatch.sh <file.c> <FunctionLabel> [extra sc options]
#
# Exit 0 only on an exact byte match. Trailing NOP padding emitted to round the
# object up to a longword is ignored -- the linker's own padding, not code.
#
# Defaults match build-split.sh: NOSTKCHK (the stock build has no __XCOVF
# prologue) and DATA=FAR (application globals are absolute, not A4-relative).
# Override the base with SCOPTS_BASE to test a different compiler or model.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CFILE="${1:?usage: cmatch.sh <file.c> <FunctionLabel> [sc options]}"
LABEL="${2:?usage: cmatch.sh <file.c> <FunctionLabel> [sc options]}"
shift 2
SCOPTS="${SCOPTS_BASE:-NOSTKCHK DATA=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128} $*"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/cmatch.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
cp "$CFILE" "$WORK/u.c"

# shellcheck disable=SC2086
# VAMOS_CFG selects an alternate toolchain (a different SAS/C install with its
# own vamos config). Unset means the 6.51 baseline.
CFGARG=""
[ -n "${VAMOS_CFG:-}" ] && CFGARG="-c $VAMOS_CFG"
# shellcheck disable=SC2086
( . /Users/rj/Downloads/vamos/bin/activate 2>/dev/null
  vamos $CFGARG --volume work:"$WORK" sc:c/sc $SCOPTS OBJNAME=work:u.o work:u.c ) \
  >"$WORK/log" 2>&1

if [ ! -f "$WORK/u.o" ]; then
    echo "COMPILE FAILED  [$SCOPTS]"
    grep -iE '^(error|warning)|Invalid' "$WORK/log" | head -5
    exit 2
fi

REF="$(python3 "$ROOT/tools/refbytes.py" "$LABEL" | sed -n 's/^bytes: //p')"

# Compare with relocated fields masked. A compiled object holds 00000000 where
# the linker will later patch an address, while the reference holds the real
# linked address, so those longwords can only be compared positionally.
python3 - "$WORK/u.o" "$REF" "$LABEL" "$SCOPTS" "$ROOT" <<'PY'
import sys, os
objf, ref, label, opts, root = sys.argv[1:6]
sys.path.insert(0, os.path.join(root, 'tools'))
from objbytes import parse

code, relocs, xdefs, xrefs = parse(objf)
got = code.hex()
# Objects are longword-sized, so a function of odd word length gets two bytes of
# alignment padding that are not code. Which filler is used is compiler-specific:
# SAS/C 6.51 emits a NOP (4e71), 6.00 emits zeros. Strip either, but only when
# doing so makes the lengths agree -- never trim real code.
if len(got) == len(ref) + 4 and got[-4:] in ('4e71', '0000'):
    got = got[:-4]

# (offset, width) -- width matters: masking 4 bytes at a 2-byte PC-relative
# reference would also blank the next opcode and hide a real difference.
sites = [(o, 4) for o in relocs] + [(o, w) for v in xrefs.values() for o, w in v]
def mask(hexstr):
    b = bytearray.fromhex(hexstr)
    for o, w in sites:
        if o + w <= len(b):
            b[o:o+w] = b'\xee' * w
    return b.hex()

mgot, mref = mask(got), (mask(ref) if len(ref) == len(got) else ref)
if mgot == mref:
    note = f'  ({len(sites)} relocated field(s) compared positionally)' if sites else ''
    print(f'MATCH  {label}  ({len(got)//2} bytes){note}  [{opts}]')
    sys.exit(0)

print(f'DIFFER {label}  [{opts}]')
print(f'  ref {ref}')
print(f'  got {got}')
n = min(len(mref), len(mgot)); i = 0
while i < n and mref[i] == mgot[i]: i += 1
print(f'  first divergence at byte {i//2} ({len(ref)//2} ref vs {len(got)//2} got bytes)')
if sites:
    print(f'  relocated at: {[hex(s) for s in sites]}')
sys.exit(1)
PY
