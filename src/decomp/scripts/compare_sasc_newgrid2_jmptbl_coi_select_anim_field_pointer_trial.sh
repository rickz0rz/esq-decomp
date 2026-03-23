#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_coi_select_anim_field_pointer"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_selectanimfieldpointer_trial.sh \
    "$ALIAS_BASE" \
    "$@"
