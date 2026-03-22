#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

exec bash src/decomp/scripts/compare_sasc_group_av_jmptbl_signal_create_msgport_with_signal_trial.sh "$@"
