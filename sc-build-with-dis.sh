#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
AUTO_VAMOS_VOLS_BASE=0
if [ "${VAMOS_VOLS_BASE:-}" = "" ]; then
    VAMOS_VOLS_BASE="$(mktemp -d "$ROOT_DIR/build/decomp/vamos_vols.XXXXXX")"
    AUTO_VAMOS_VOLS_BASE=1
else
    mkdir -p "$VAMOS_VOLS_BASE"
fi

cleanup() {
    if [ "$AUTO_VAMOS_VOLS_BASE" -eq 1 ]; then
        rmdir "$VAMOS_VOLS_BASE/ram" 2>/dev/null || true
        rmdir "$VAMOS_VOLS_BASE" 2>/dev/null || true
    fi
}
trap cleanup EXIT

echo "Sourcing vamos"
source /Users/rj/Downloads/vamos/bin/activate

echo "Compiling $1"

DISASSEMBLE_FILE=work:$1.dis

if [ "$#" -ge 2 ]; then
    echo "Setting disassembly output to $2"
    DISASSEMBLE_FILE=work:$2
fi

vamos --vols-base-dir "$VAMOS_VOLS_BASE" --volume esq:/Users/rj/Downloads/Git/github.com/rickz0rz/esq-decomp/src/decomp/sas_c sc DISASSEMBLE=esq:$1.dis esq:$1
