#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAMOS_VOLS_BASE="${VAMOS_VOLS_BASE:-$ROOT_DIR/build/decomp/vamos_vols}"
mkdir -p "$VAMOS_VOLS_BASE"

echo "Sourcing vamos"
source /Users/rj/Downloads/vamos/bin/activate

echo "Compiling $1"

DISASSEMBLE_FILE=work:$1.dis

if [ "$#" -ge 2 ]; then
    echo "Setting disassembly output to $2"
    DISASSEMBLE_FILE=work:$2
fi

vamos --vols-base-dir "$VAMOS_VOLS_BASE" --volume esq:/Users/rj/Downloads/Git/github.com/rickz0rz/esq-decomp/src/decomp/sas_c sc DISASSEMBLE=esq:$1.dis esq:$1
