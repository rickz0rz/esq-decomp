#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

bash src/decomp/scripts/compare_sasc_parallel_writecharhw_trial.sh "$@"

OUT_DIR="build/decomp/sasc_trial"
for suffix in original.s sasc.dis.s original.norm.s sasc.norm.s diff original.semantic.txt sasc.semantic.txt semantic.diff; do
    src="${OUT_DIR}/parallel_writecharhw.${suffix}"
    dst="${OUT_DIR}/parallel_write_char_hw.${suffix}"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
    fi
done
