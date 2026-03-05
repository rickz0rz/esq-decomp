#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown36_finalize_and_abort_requester.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown36.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_unknown36_finalize_request.log" 2>&1

awk '$0 ~ /^UNKNOWN36_FinalizeRequest:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/unknown36_finalize_request.original.s"
awk '$0 ~ /^UNKNOWN36_FinalizeRequest:$/ {in_func=1} in_func { if ($0 ~ /^UNKNOWN36_ShowAbortRequester:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/unknown36_finalize_request.sasc.dis.s"

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

normalize <"${OUT_DIR}/unknown36_finalize_request.original.s" >"${OUT_DIR}/unknown36_finalize_request.original.norm.s"
normalize <"${OUT_DIR}/unknown36_finalize_request.sasc.dis.s" >"${OUT_DIR}/unknown36_finalize_request.sasc.norm.s"

diff -u "${OUT_DIR}/unknown36_finalize_request.original.norm.s" "${OUT_DIR}/unknown36_finalize_request.sasc.norm.s" >"${OUT_DIR}/unknown36_finalize_request.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_unknown36_finalize_request.awk "${OUT_DIR}/unknown36_finalize_request.original.norm.s" >"${OUT_DIR}/unknown36_finalize_request.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_unknown36_finalize_request.awk "${OUT_DIR}/unknown36_finalize_request.sasc.norm.s" >"${OUT_DIR}/unknown36_finalize_request.sasc.semantic.txt"
diff -u "${OUT_DIR}/unknown36_finalize_request.original.semantic.txt" "${OUT_DIR}/unknown36_finalize_request.sasc.semantic.txt" >"${OUT_DIR}/unknown36_finalize_request.semantic.diff" || true

echo "wrote: ${OUT_DIR}/unknown36_finalize_request.diff"
echo "wrote: ${OUT_DIR}/unknown36_finalize_request.semantic.diff"
