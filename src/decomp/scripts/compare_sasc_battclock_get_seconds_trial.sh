#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown40_battclock_get_seconds.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown40.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_battclock_get_seconds.log" 2>&1

awk '$0 ~ /^BATTCLOCK_GetSecondsFromBatteryBackedClock:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/battclock_get_seconds.original.s"
awk '$0 ~ /^BATTCLOCK_GetSecondsFromBattery/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/battclock_get_seconds.sasc.dis.s"

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

normalize <"${OUT_DIR}/battclock_get_seconds.original.s" >"${OUT_DIR}/battclock_get_seconds.original.norm.s"
normalize <"${OUT_DIR}/battclock_get_seconds.sasc.dis.s" >"${OUT_DIR}/battclock_get_seconds.sasc.norm.s"

diff -u "${OUT_DIR}/battclock_get_seconds.original.norm.s" "${OUT_DIR}/battclock_get_seconds.sasc.norm.s" >"${OUT_DIR}/battclock_get_seconds.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_battclock_get_seconds.awk "${OUT_DIR}/battclock_get_seconds.original.norm.s" >"${OUT_DIR}/battclock_get_seconds.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_battclock_get_seconds.awk "${OUT_DIR}/battclock_get_seconds.sasc.norm.s" >"${OUT_DIR}/battclock_get_seconds.sasc.semantic.txt"
diff -u "${OUT_DIR}/battclock_get_seconds.original.semantic.txt" "${OUT_DIR}/battclock_get_seconds.sasc.semantic.txt" >"${OUT_DIR}/battclock_get_seconds.semantic.diff" || true

echo "wrote: ${OUT_DIR}/battclock_get_seconds.diff"
echo "wrote: ${OUT_DIR}/battclock_get_seconds.semantic.diff"
