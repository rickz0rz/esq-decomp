#!/bin/bash
# Compile a C file with SAS/C 6.51 under vamos and diff it against the
# reference bytes of a function in the original build.
#
#   tools/cmatch.sh <file.c> <FunctionLabel> [extra sc options]
#
# Exit 0 only on an exact byte match. Trailing NOP padding emitted to round the
# object up to a longword is ignored -- the linker's own padding, not code.
#
# NOSTKCHK is always passed: the stock build has no __XCOVF stack-check
# prologue, so leaving it on guarantees a mismatch on every function.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CFILE="${1:?usage: cmatch.sh <file.c> <FunctionLabel> [sc options]}"
LABEL="${2:?usage: cmatch.sh <file.c> <FunctionLabel> [sc options]}"
shift 2
SCOPTS="NOSTKCHK $*"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/cmatch.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
cp "$CFILE" "$WORK/u.c"

# shellcheck disable=SC2086
( . /Users/rj/Downloads/vamos/bin/activate 2>/dev/null
  vamos --volume work:"$WORK" sc:c/sc $SCOPTS OBJNAME=work:u.o work:u.c ) \
  >"$WORK/log" 2>&1

if [ ! -f "$WORK/u.o" ]; then
    echo "COMPILE FAILED  [$SCOPTS]"
    grep -iE '^(error|warning)|Invalid' "$WORK/log" | head -5
    exit 2
fi

GOT="$(python3 "$ROOT/tools/objbytes.py" "$WORK/u.o" | sed -n 's/^bytes: //p')"
GOT="${GOT%4e71}"                     # drop longword-alignment NOP if present
REF="$(python3 "$ROOT/tools/refbytes.py" "$LABEL" | sed -n 's/^bytes: //p')"

if [ "$GOT" = "$REF" ]; then
    echo "MATCH  $LABEL  (${#REF} nibbles)  [$SCOPTS]"
    exit 0
fi
echo "DIFFER $LABEL  [$SCOPTS]"
echo "  ref $REF"
echo "  got $GOT"
python3 - "$REF" "$GOT" <<'PY'
import sys
ref, got = sys.argv[1], sys.argv[2]
n = min(len(ref), len(got)); i = 0
while i < n and ref[i] == got[i]: i += 1
print(f'  first divergence at byte {i//2} ({len(ref)//2} vs {len(got)//2} bytes total)')
PY
exit 1
