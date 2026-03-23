#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_disptext_set_layout_params"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_setlayoutparams_trial.sh \
    "$ALIAS_BASE" \
    "$@"
