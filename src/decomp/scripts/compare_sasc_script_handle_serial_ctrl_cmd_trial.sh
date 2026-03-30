#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

BASE="script_handle_serial_ctrl_cmd"
SASC_SRC="script3_handle_serial_ctrl_cmd.c"
ORIG_ASM="src/modules/groups/b/a/script3.s"
# Metadata mirror for audit tooling: awk -f src/decomp/scripts/semantic_filter_sasc_script3_handle_serial_ctrl_cmd.awk

ALIAS_BASE="$(basename "$0" .sh)"
ALIAS_BASE="${ALIAS_BASE#compare_sasc_}"
ALIAS_BASE="${ALIAS_BASE%_trial}"

exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh     src/decomp/scripts/compare_sasc_script3_handle_serial_ctrl_cmd_trial.sh     "$ALIAS_BASE"     "$@"
