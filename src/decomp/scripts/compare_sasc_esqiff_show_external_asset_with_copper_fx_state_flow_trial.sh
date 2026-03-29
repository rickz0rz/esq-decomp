#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SASC_SRC="esqiff_show_external_asset_with_copper_fx.c"
SASC_DIS="src/decomp/sas_c/${SASC_SRC}.dis"
ORIG_ASM="src/modules/groups/a/n/esqiff.s"
OUT_DIR="build/decomp/sasc_trial"
BASE="esqiff_show_external_asset_with_copper_fx_state_flow"
ENTRY="ESQIFF_ShowExternalAssetWithCopperFx"
ENTRY_SASC_REGEX="^ESQIFF_ShowExternalAssetWithC[A-Za-z0-9_]*:$"

mkdir -p "$OUT_DIR"

./sc-build-with-dis.sh "$SASC_SRC" >"${OUT_DIR}/sc_build_${BASE}.log" 2>&1

awk -v e="^${ENTRY}:$" '
    $0 ~ e { inf=1 }
    inf {
        if ($0 ~ /^; FUNC: ESQIFF_ShowExternalAssetWithCopperFx_Return/) exit
        if ($0 ~ /^;!======/) exit
        print
    }
' "$ORIG_ASM" >"${OUT_DIR}/${BASE}.original.s"

awk -v e="^${ENTRY}:$" -v e2="$ENTRY_SASC_REGEX" '
    $0 ~ e || $0 ~ e2 { inf=1 }
    inf {
        if (($0 ~ /^ESQIFF_[A-Za-z0-9_]+:$/ || $0 ~ /^_?ESQIFF_[A-Za-z0-9_]+:$/) &&
            $0 !~ /^ESQIFF_ShowExternalAssetWithCopperFx:$/ &&
            $0 !~ /^ESQIFF_ShowExternalAssetWithC[A-Za-z0-9_]*:$/) exit
        if ($0 ~ /^[[:space:]]*XREF / || $0 ~ /^[[:space:]]*XDEF / ||
            $0 ~ /^[[:space:]]*END$/ || $0 ~ /^[[:space:]]+END$/) exit
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
        -e '/^__const:$/d' \
        -e '/^__strings:$/d' \
        -e '/^const:$/d' \
        -e '/^strings:$/d' \
        -e '/^$/d'
}

normalize <"${OUT_DIR}/${BASE}.original.s" >"${OUT_DIR}/${BASE}.original.norm.s"
normalize <"${OUT_DIR}/${BASE}.sasc.dis.s" >"${OUT_DIR}/${BASE}.sasc.norm.s"

diff -u "${OUT_DIR}/${BASE}.original.norm.s" "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.diff" || true

awk -f src/decomp/scripts/semantic_filter_sasc_esqiff_show_external_asset_with_copper_fx_state_flow.awk "${OUT_DIR}/${BASE}.original.norm.s" >"${OUT_DIR}/${BASE}.original.semantic.txt"
awk -f src/decomp/scripts/semantic_filter_sasc_esqiff_show_external_asset_with_copper_fx_state_flow.awk "${OUT_DIR}/${BASE}.sasc.norm.s" >"${OUT_DIR}/${BASE}.sasc.semantic.txt"
diff -u "${OUT_DIR}/${BASE}.original.semantic.txt" "${OUT_DIR}/${BASE}.sasc.semantic.txt" >"${OUT_DIR}/${BASE}.semantic.diff" || true

echo "wrote: ${OUT_DIR}/${BASE}.diff"
echo "wrote: ${OUT_DIR}/${BASE}.semantic.diff"
