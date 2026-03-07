#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="ed_transform_line_spacing_mode3.c"
SASC_DIS="src/decomp/sas_c/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/l/ed3.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="ed_transform_line_spacing_mode3"
ENTRY_ORIG="ED_TransformLineSpacing_Mode3"
ENTRY_SASC_REGEX="^ED_TransformLineSpacing_Mode3[A-Za-z0-9_]*:$"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk -v e="^${ENTRY_ORIG}:$" '
  $0 ~ e {in_func=1}
  in_func {
    if ($0 ~ /^;!======/) exit
    print
  }
' "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"

awk -v e="^${ENTRY_ORIG}:$" -v e2="$ENTRY_SASC_REGEX" '
  $0 ~ e || $0 ~ e2 {in_func=1}
  in_func {
    if (($0 ~ /^[A-Z0-9_]+:$/ || $0 ~ /^_?[A-Z0-9_]+:$/) && $0 !~ /^___/ && $0 !~ e && $0 !~ e2) exit
    if ($0 ~ /^XREF / || $0 ~ /^XDEF / || $0 ~ /^ END$/ || $0 ~ /^END$/) exit
    print
  }
' "$SASC_DIS" >"${OUT_DIR}/${BASE}.sasc.dis.s"

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

normalize <"${OUT_DIR}/${BASE}.original.s" >"${OUT_DIR}/${BASE}.original.norm.s"
normalize <"${OUT_DIR}/${BASE}.sasc.dis.s" >"${OUT_DIR}/${BASE}.sasc.norm.s"

diff -u "${OUT_DIR}/${BASE}.original.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_ed_transform_line_spacing_mode3.awk "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_ed_transform_line_spacing_mode3.awk "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
