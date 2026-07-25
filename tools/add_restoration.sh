#!/bin/bash
# Install a C restoration into src/c/ with a verified header.
#
#   tools/add_restoration.sh <draft.c> <FunctionLabel> <dest-name.c> <slug> "<summary>" [sc options]
#
# Compiles the draft, diffs it against the original, and writes src/<dest> with
# a RESTORES/MODULE/STATUS header. STATUS is set from the measured result, never
# asserted: `exact` on a byte match, `behavioural` otherwise, with the real ref
# and got bytes recorded in a SASC-MISMATCH block.
#
# The point is that the recorded status is always the observed one, so
# `tools/mismatches.py --recheck` can never disagree with what is written down.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DRAFT="${1:?draft.c}"; LABEL="${2:?FunctionLabel}"; DEST="${3:?dest.c}"
SLUG="${4:-codegen-divergence}"; SUMMARY="${5:-}"; shift 5 2>/dev/null || shift $#
OPTS="$*"

OUT="$("$ROOT/tools/cmatch.sh" "$DRAFT" "$LABEL" $OPTS 2>&1)"
REF="$(printf '%s\n' "$OUT" | sed -n 's/^  ref //p')"
GOT="$(printf '%s\n' "$OUT" | sed -n 's/^  got //p')"
MODULE="$(python3 "$ROOT/tools/refbytes.py" "$LABEL" 2>/dev/null | sed -n '1s/.*\[\(.*\)\].*/\1/p')"

if printf '%s' "$OUT" | grep -q '^MATCH'; then
    STATUS=exact
else
    STATUS=behavioural
fi

{
  echo "/* RESTORES: $LABEL"
  echo " * MODULE:   ${MODULE:-unknown}"
  echo " * STATUS:   $STATUS"
  [ -n "$OPTS" ] && echo " * OPTIONS:  $OPTS"
  echo " *"
  if [ "$STATUS" = behavioural ]; then
      echo " * SASC-MISMATCH: $SLUG"
      [ -n "$REF" ] && echo " *   ref:     $REF"
      [ -n "$GOT" ] && echo " *   got:     $GOT"
      [ -n "$SUMMARY" ] && echo " *   summary: $SUMMARY"
      echo " *   retest:  re-run tools/mismatches.py --recheck against a different"
      echo " *            SAS/C version; see docs/compiler-version.md."
  else
      echo " * Byte-exact against the original."
  fi
  echo " */"
  cat "$DRAFT"
} > "$ROOT/src/c/$DEST"

echo "$STATUS  $LABEL -> src/c/$DEST"
