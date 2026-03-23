#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_displib_find_previous_valid_entry_index"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_displib_findpreviousvalidentryindex_trial.sh \
    "$ALIAS_BASE" \
    "$@"
