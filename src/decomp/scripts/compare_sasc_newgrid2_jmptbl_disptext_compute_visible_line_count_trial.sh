#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_disptext_compute_visible_line_count"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_computevisiblelinecount_trial.sh \
    "$ALIAS_BASE" \
    "$@"
