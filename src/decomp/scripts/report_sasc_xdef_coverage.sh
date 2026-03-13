#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

XDEFS_FILE="$(mktemp)"
COVERED_FILE="$(mktemp)"
trap 'rm -f "$XDEFS_FILE" "$COVERED_FILE"' EXIT

# Canonical assembly exports only (exclude decomp scaffolding sources).
rg -No --no-filename '^[[:space:]]*XDEF[[:space:]]+[A-Za-z0-9_]+' \
  src \
  --glob '*.{s,asm}' \
  --glob '!src/decomp/**' \
  | sed -E 's/^[[:space:]]*XDEF[[:space:]]+//' \
  | sort -u >"$XDEFS_FILE"

# Compare scripts that either expose an explicit original-entry variable or
# inline the extractor label directly in their awk matcher.
for script in src/decomp/scripts/compare_sasc_*_trial.sh; do
  {
    rg -No --no-filename 'ENTRY_ORIG="[^"]+"|ENTRY="[^"]+"|ENTRY_LABEL="[^"]+"|ENTRY_CANONICAL="[^"]+"|TARGET="[^"]+"' "$script" \
      | sed -E 's/.*="([^"]+)"/\1/' || true
    sed -nE 's/.*\$0 ~ \/\^_?([A-Za-z0-9_]+)(\[[^]]+\]\*)?:\$\/.*/\1/p' "$script" || true
  }
done | sort -u >"$COVERED_FILE"

TOTAL_XDEFS="$(wc -l <"$XDEFS_FILE" | tr -d ' ')"
COVERED_XDEFS="$(comm -12 "$XDEFS_FILE" "$COVERED_FILE" | wc -l | tr -d ' ')"
UNCOVERED_XDEFS="$((TOTAL_XDEFS - COVERED_XDEFS))"

echo "SAS/C XDEF Coverage"
echo "  total_xdefs: ${TOTAL_XDEFS}"
echo "  covered_by_script_extractors: ${COVERED_XDEFS}"
echo "  uncovered_by_script_extractors: ${UNCOVERED_XDEFS}"
echo
echo "Uncovered sample (first 40):"
comm -23 "$XDEFS_FILE" "$COVERED_FILE" | awk 'NR<=40 { print }'
