#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT_DIR"

ALIAS_BASE="$(basename "$0" .sh)"
ALIAS_BASE="${ALIAS_BASE#compare_sasc_}"
ALIAS_BASE="${ALIAS_BASE%_trial}"

exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh     src/decomp/scripts/compare_sasc_parseini_jmptbl_esqfunc_rebuildpwbrushlistfromtagtablefromtagtable_trial.sh     "$ALIAS_BASE"     "$@"
