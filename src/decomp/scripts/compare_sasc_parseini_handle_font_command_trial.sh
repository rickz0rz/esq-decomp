#!/bin/bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"
SASC_SRC="parseini_handle_font_command.c"
SASC_DIS="src/decomp/sas_c/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/b/a/parseini.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="parseini_handle_font_command"
STATE_BASE="${BASE}_state_flow"
ENTRY="PARSEINI_HandleFontCommand"
ENTRY_SASC_REGEX="^PARSEINI_HandleFontComman[A-Za-z0-9_]*:$"
mkdir -p "$OUT_DIR"
./src/decomp/scripts/compare_sasc_${STATE_BASE}_trial.sh >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1
cp "${OUT_DIR}/${STATE_BASE}.original.s" "${OUT_DIR}/${BASE}.original.s"
cp "${OUT_DIR}/${STATE_BASE}.sasc.dis.s" "${OUT_DIR}/${BASE}.sasc.dis.s"
cp "${OUT_DIR}/${STATE_BASE}.original.norm.s" "${OUT_DIR}/${BASE}.original.norm.s"
cp "${OUT_DIR}/${STATE_BASE}.sasc.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s"
diff -u "${OUT_DIR}/${BASE}.original.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.diff" || true
awk -f src/decomp/scripts/semantic_filter_sasc_parseini_handle_font_command.awk "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_parseini_handle_font_command.awk "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true
echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
