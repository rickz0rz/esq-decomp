#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown36_finalize_and_abort_requester.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown36.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="UNKNOWN36_ShowAbortRequester"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown36_show_abort_requester.log" 2>&1

awk -v entry="^${ENTRY_ORIG}:$" '$0 ~ entry {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown36_show_abort_requester.original.s"
awk -v entry="^${ENTRY_ORIG}:$" '$0 ~ entry {in_func=1} in_func { if ($0 ~ /^DEBUG_STR_UserAbortRequested:$/ || $0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown36_show_abort_requester.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown36_show_abort_requester.original.s" >"${OUT_DIR}/unknown36_show_abort_requester.original.norm.s"
normalize <"${OUT_DIR}/unknown36_show_abort_requester.sasc.dis.s" >"${OUT_DIR}/unknown36_show_abort_requester.sasc.norm.s"

diff -u "${OUT_DIR}/unknown36_show_abort_requester.original.norm.s" "${OUT_DIR}/unknown36_show_abort_requester.sasc.norm.s" >"${OUT_DIR}/unknown36_show_abort_requester.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown36_show_abort_requester.awk "${OUT_DIR}/unknown36_show_abort_requester.original.norm.s" >"${OUT_DIR}/unknown36_show_abort_requester.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown36_show_abort_requester.awk "${OUT_DIR}/unknown36_show_abort_requester.sasc.norm.s" >"${OUT_DIR}/unknown36_show_abort_requester.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown36_show_abort_requester.original.semantic.txt" "${OUT_DIR}/unknown36_show_abort_requester.sasc.semantic.txt" >"${OUT_DIR}/unknown36_show_abort_requester.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown36_show_abort_requester.diff"
echo "wrote: ${OUT_DIR}/unknown36_show_abort_requester.semantic.diff"
