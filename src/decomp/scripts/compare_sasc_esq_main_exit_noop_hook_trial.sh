#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="unknown2b_main_noop_hooks.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/submodules/unknown2b.s"
OUT_DIR="build/decomp/sasc_trial"
ENTRY_ORIG="ESQ_MainExitNoOpHook"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_esq_main_exit_noop_hook.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '$0 ~ e {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' "$ORIG_ASM" >"${OUT_DIR}/esq_main_exit_noop_hook.original.s"
awk -v e="^${ENTRY_ORIG}:$" '$0 ~ e {in_func=1} in_func { if ($0 ~ /^__const:$/) exit; print }' "$SASC_DIS" >"${OUT_DIR}/esq_main_exit_noop_hook.sasc.dis.s"

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

normalize <"${OUT_DIR}/esq_main_exit_noop_hook.original.s" >"${OUT_DIR}/esq_main_exit_noop_hook.original.norm.s"
normalize <"${OUT_DIR}/esq_main_exit_noop_hook.sasc.dis.s" >"${OUT_DIR}/esq_main_exit_noop_hook.sasc.norm.s"

diff -u "${OUT_DIR}/esq_main_exit_noop_hook.original.norm.s" "${OUT_DIR}/esq_main_exit_noop_hook.sasc.norm.s" >"${OUT_DIR}/esq_main_exit_noop_hook.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_esq_main_noop_hook.awk "${OUT_DIR}/esq_main_exit_noop_hook.original.norm.s" >"${OUT_DIR}/esq_main_exit_noop_hook.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_esq_main_noop_hook.awk "${OUT_DIR}/esq_main_exit_noop_hook.sasc.norm.s" >"${OUT_DIR}/esq_main_exit_noop_hook.sasc.semantic.txt"
diff -u "${OUT_DIR}/esq_main_exit_noop_hook.original.semantic.txt" "${OUT_DIR}/esq_main_exit_noop_hook.sasc.semantic.txt" >"${OUT_DIR}/esq_main_exit_noop_hook.semantic.diff" || true

echo "wrote: ${OUT_DIR}/esq_main_exit_noop_hook.diff"
echo "wrote: ${OUT_DIR}/esq_main_exit_noop_hook.semantic.diff"
