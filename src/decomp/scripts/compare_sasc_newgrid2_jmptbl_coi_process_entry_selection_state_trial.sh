#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_coi_process_entry_selection_state"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_processentryselectionstate_trial.sh \
    "$ALIAS_BASE" \
    "$@"
