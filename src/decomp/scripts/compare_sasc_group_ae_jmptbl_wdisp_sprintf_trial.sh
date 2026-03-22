#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

exec bash src/decomp/scripts/compare_sasc_group_ae_jmptbl_wdisp_s_printf_trial.sh "$@"
