#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_getentryauxpointerbymode_trial.sh \
    "$ALIAS_BASE" \
    "$@"
