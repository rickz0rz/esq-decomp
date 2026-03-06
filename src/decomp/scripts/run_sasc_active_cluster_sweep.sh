#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

SCRIPT="src/decomp/scripts/run_sasc_core_sweep.sh"

if [ ! -x "$SCRIPT" ]; then
    chmod +x "$SCRIPT"
fi

start_ts="$(date +%s)"

cmd=(
    bash "$SCRIPT"
    --strict
    --clean-generated-dis
    --filter "newgrid"
    --filter "displib"
    --filter "disptext"
    --filter "parallel"
)

if [ $# -gt 0 ]; then
    cmd+=("$@")
fi

echo "SAS/C active cluster sweep"
echo "filters: newgrid, displib, disptext, parallel"
"${cmd[@]}"

end_ts="$(date +%s)"
elapsed="$((end_ts - start_ts))"
echo "SAS/C active cluster sweep: elapsed ${elapsed}s"
