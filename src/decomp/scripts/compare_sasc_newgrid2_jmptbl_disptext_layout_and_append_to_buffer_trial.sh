#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_disptext_layout_and_append_to_buffer"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_layoutandappendtobuffer_trial.sh \
    "$ALIAS_BASE" \
    "$@"
