#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_disptext_render_current_line"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_disptext_rendercurrentline_trial.sh \
    "$ALIAS_BASE" \
    "$@"
