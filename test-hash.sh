#!/bin/bash
# Byte-exactness gate for the monolithic build.
#
# Exits 0 only if the build SUCCEEDS and its SHA-256 matches the reference.
#
# This previously echoed the expected hash unconditionally and never checked the
# exit status, so a failed assembly printed the expected value and looked like a
# pass. Anything grepping the output for the hash string -- including
# tools/extract_function.py and the wiring scripts -- was therefore running a
# check that could not fail. Keep this script's exit code meaningful.
set -uo pipefail

EXPECTED=6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2
VASM_BIN="${VASM_BIN:-$HOME/Downloads/vasm/vasmm68k_mot}"
OUT="$(mktemp "${TMPDIR:-/tmp}/esqhash.XXXXXX")"
trap 'rm -f "$OUT"' EXIT

if ! "$VASM_BIN" -Fhunkexe -o "$OUT" -nosym src/Prevue.asm >/dev/null 2>"$OUT.err"; then
    echo "FAIL: assembly failed"
    sed -n '1,12p' "$OUT.err"; rm -f "$OUT.err"
    exit 1
fi
rm -f "$OUT.err"

ACTUAL="$(shasum -a 256 "$OUT" | awk '{print $1}')"
if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "PASS  $ACTUAL"
    exit 0
fi
echo "FAIL  actual   $ACTUAL"
echo "      expected $EXPECTED"
exit 1
