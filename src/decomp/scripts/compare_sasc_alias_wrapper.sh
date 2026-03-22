#!/bin/bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
    echo "usage: $0 <canonical_compare_script> <alias_base> [compare args...]" >&2
    exit 2
fi

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CANONICAL_SCRIPT="$1"
ALIAS_BASE="$2"
shift 2

CANONICAL_BASE="$(awk -F'"' '/^BASE="/ { print $2; exit }' "$CANONICAL_SCRIPT")"
if [ -z "$CANONICAL_BASE" ]; then
    CANONICAL_BASE="$(basename "$CANONICAL_SCRIPT" .sh)"
    CANONICAL_BASE="${CANONICAL_BASE#compare_sasc_}"
    CANONICAL_BASE="${CANONICAL_BASE%_trial}"
fi

OUT_DIR="build/decomp/sasc_trial"

bash "$CANONICAL_SCRIPT" "$@"

copied_any=0

for suffix in \
    diff \
    semantic.diff \
    original.s \
    original.norm.s \
    original.semantic.txt \
    sasc.dis.s \
    sasc.norm.s \
    sasc.semantic.txt
do
    if [ -f "${OUT_DIR}/${CANONICAL_BASE}.${suffix}" ]; then
        cp "${OUT_DIR}/${CANONICAL_BASE}.${suffix}" "${OUT_DIR}/${ALIAS_BASE}.${suffix}"
        copied_any=1
    fi
done

if [ -f "${OUT_DIR}/sc_build_${CANONICAL_BASE}.log" ]; then
    cp "${OUT_DIR}/sc_build_${CANONICAL_BASE}.log" "${OUT_DIR}/sc_build_${ALIAS_BASE}.log"
fi

if [ "$copied_any" -eq 1 ]; then
    echo "alias wrote: ${OUT_DIR}/${ALIAS_BASE}.diff"
    echo "alias wrote: ${OUT_DIR}/${ALIAS_BASE}.semantic.diff"
fi
