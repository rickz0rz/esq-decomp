#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="esqdisp_parse_program_info_command_record.c"
SASC_DIR="src/decomp/sas_c"
SASC_DIS="${SASC_DIR}/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/n/esqdisp.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="esqdisp_parse_program_info_command_record"
ENTRY="ESQDISP_ParseProgramInfoCommandRecord"
ENTRY_SASC_REGEX="^ESQDISP_ParseProgramInfoCommandR[A-Za-z0-9_]*:$"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk -v e="^${ENTRY}:$" '$0 ~ e {in_func=1} in_func { if ($0 ~ /^;!======/) exit; print }' \
    "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"

awk -v e="^${ENTRY}:$" -v e2="$ENTRY_SASC_REGEX" '
    $0 ~ e || $0 ~ e2 { in_func=1 }
    in_func {
        if (($0 ~ /^[A-Z][A-Za-z0-9_]+:$/ || $0 ~ /^_?[A-Z][A-Za-z0-9_]+:$/) && $0 !~ e && $0 !~ e2) exit
        if ($0 ~ /^XREF / || $0 ~ /^XDEF / || $0 ~ /^ END$/ || $0 ~ /^END$/ || $0 ~ /^__const:$/) exit
        print
    }
' "$SASC_DIS" | sed \
    -e 's/^ESQDISP_ParseProgramInfoCommandR:/ESQDISP_ParseProgramInfoCommandRecord:/' \
    -e 's/___ESQDISP_ParseProgramInfoCommandR__/___ESQDISP_ParseProgramInfoCommandRecord__/g' \
    | awk '
        /MOVEM\.L[[:space:]]+\(A7\)\+,D2-D3\/D5-D7\/A2-A3\/A5/ && !injected {
            print "ESQDISP_ParseProgramInfoCommandRecord_Return:"
            injected = 1
        }
        { print }
    ' >"${OUT_DIR}/${BASE}.sasc.dis.s"

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

awk -f src/decomp/scripts/semantic_filter_esqdisp_parse_program_info_command_record.awk \
    "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_esqdisp_parse_program_info_command_record.awk \
    "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"

diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
