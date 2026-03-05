#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

bash src/decomp/scripts/compare_sasc_parallel_checkready_stub_trial.sh "$@"

OUT_DIR="build/decomp/sasc_trial"
for suffix in original.s sasc.dis.s original.norm.s sasc.norm.s diff original.semantic.txt sasc.semantic.txt semantic.diff; do
    src="${OUT_DIR}/parallel_checkready_stub.${suffix}"
    dst="${OUT_DIR}/parallel_check_ready_stub.${suffix}"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
    fi
done
