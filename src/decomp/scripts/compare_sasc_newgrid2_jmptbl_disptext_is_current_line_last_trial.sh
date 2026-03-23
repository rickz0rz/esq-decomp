#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_disptext_is_current_line_last"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_iscurrentlinelast_trial.sh \
    "$ALIAS_BASE" \
    "$@"
