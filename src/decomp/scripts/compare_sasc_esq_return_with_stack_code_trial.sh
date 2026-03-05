#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="esq_return_with_stack_code.c"
SASC_DIS="src/decomp/sas_c/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/_main/a/a.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="esq_return_with_stack_code"
ENTRY="ESQ_ReturnWithStackCode"
NEXT_LABEL="ESQ_ShutdownAndReturn"
ENTRY_SASC_REGEX="^ESQ_ReturnWithStackCode[A-Za-z0-9_]*:$"
ENTRY_SEM="ESQ_RETURNWITHSTACKCODE:"
ENTRY_ALT_SEM="ESQ_RETURNWITHSTACKCODE"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk -v start_label="$ENTRY" -v next_label="$NEXT_LABEL" '
$0 ~ ("^" start_label ":$") {in_func=1}
in_func {
    if (next_label != "" && $0 ~ ("^" next_label ":$")) exit
    print
}
' "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"

awk -v e="^${ENTRY}:$" -v e2="$ENTRY_SASC_REGEX" '
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

awk -v ENTRY_PREFIX="$ENTRY_SEM" -v ENTRY_ALT_PREFIX="$ENTRY_ALT_SEM" -f src/decomp/scripts/semantic_filter_sasc_esq_return_with_stack_code.awk "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -v ENTRY_PREFIX="$ENTRY_SEM" -v ENTRY_ALT_PREFIX="$ENTRY_ALT_SEM" -f src/decomp/scripts/semantic_filter_sasc_esq_return_with_stack_code.awk "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
