#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

CORE_SCRIPT="src/decomp/scripts/run_sasc_core_sweep.sh"

if [ ! -f "$CORE_SCRIPT" ]; then
    echo "error: missing $CORE_SCRIPT" >&2
    exit 1
fi

core_count="$(rg -o 'compare_sasc_[^"[:space:]]+_trial\.sh' "$CORE_SCRIPT" | wc -l | tr -d ' ')"

active_count="$(
    rg -o 'compare_sasc_[^"[:space:]]+_trial\.sh' "$CORE_SCRIPT" \
        | rg 'newgrid|displib|disptext|parallel' \
        | wc -l \
        | tr -d ' '
)"

echo "full_sweep_lane_count=${core_count}"
echo "active_cluster_lane_count=${active_count}"
