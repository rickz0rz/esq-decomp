#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown38_signal_poll_and_dispatch.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown38.s"
OUT_DIR="build/decomp/sasc_trial"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_signal_poll_and_dispatch.log" 2>&1

awk '$0 ~ /^SIGNAL_PollAndDispatch:$/ {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/signal_poll_and_dispatch.original.s"
awk '$0 ~ /^SIGNAL_PollAndDispatch:$/ {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/signal_poll_and_dispatch.sasc.dis.s"

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

normalize <"${OUT_DIR}/signal_poll_and_dispatch.original.s" >"${OUT_DIR}/signal_poll_and_dispatch.original.norm.s"
normalize <"${OUT_DIR}/signal_poll_and_dispatch.sasc.dis.s" >"${OUT_DIR}/signal_poll_and_dispatch.sasc.norm.s"

diff -u "${OUT_DIR}/signal_poll_and_dispatch.original.norm.s" "${OUT_DIR}/signal_poll_and_dispatch.sasc.norm.s" >"${OUT_DIR}/signal_poll_and_dispatch.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_signal_poll_and_dispatch.awk "${OUT_DIR}/signal_poll_and_dispatch.original.norm.s" >"${OUT_DIR}/signal_poll_and_dispatch.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_signal_poll_and_dispatch.awk "${OUT_DIR}/signal_poll_and_dispatch.sasc.norm.s" >"${OUT_DIR}/signal_poll_and_dispatch.sasc.semantic.txt"
diff -u "${OUT_DIR}/signal_poll_and_dispatch.original.semantic.txt" "${OUT_DIR}/signal_poll_and_dispatch.sasc.semantic.txt" >"${OUT_DIR}/signal_poll_and_dispatch.semantic.diff" || true

echo "wrote: ${OUT_DIR}/signal_poll_and_dispatch.diff"
echo "wrote: ${OUT_DIR}/signal_poll_and_dispatch.semantic.diff"
