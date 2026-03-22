#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

exec bash src/decomp/scripts/compare_sasc_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_trial.sh "$@"
