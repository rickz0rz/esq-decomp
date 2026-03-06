#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown42_clock_wrappers.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown42.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="CLOCK_CheckDateOrSecondsFromEpoch"
ENTRY_SASC_REGEX="^CLOCK_CheckDateOrSecondsFromEpoc[h]?:$"
NEXT_ENTRY_SASC="CLOCK_SecondsFromEpoch"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_clock_check_date_or_seconds_from_epoch.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.s"

awk -v e="^${ENTRY_ORIG}:$" -v e2="$ENTRY_SASC_REGEX" -v n="^${NEXT_ENTRY_SASC}:$" '
  $0 ~ e || $0 ~ e2 {in_func=1}
  in_func {
    if ($0 ~ n) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.dis.s"

normalize() {
  sed -E \
    -e 's/;.*$//' \
    -e 's/^[[:space:]]+//' \
    -e 's/[[:space:]]+/ /g' \
    -e 's/[[:space:]]+$//' \
    -e '/^$/d' \
    -e 's/^___[A-Za-z0-9_]+__[0-9]+:$//' \
    -e '/^const:$/d' \
    -e '/^strings:$/d' \
    -e '/^$/d'
}

normalize <"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.s" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.norm.s"
normalize <"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.dis.s" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.norm.s"

diff -u "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.norm.s" "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.norm.s" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_clock_check_date_or_seconds_from_epoch.awk "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.norm.s" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_clock_check_date_or_seconds_from_epoch.awk "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.norm.s" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.semantic.txt"
diff -u "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.original.semantic.txt" "${OUT_DIR}/clock_check_date_or_seconds_from_epoch.sasc.semantic.txt" >"${OUT_DIR}/clock_check_date_or_seconds_from_epoch.semantic.diff" || true

echo "wrote: ${OUT_DIR}/clock_check_date_or_seconds_from_epoch.diff"
echo "wrote: ${OUT_DIR}/clock_check_date_or_seconds_from_epoch.semantic.diff"
