#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_bevel_draw_horizontal_bevel"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawhorizontalbevel_trial.sh \
    "$ALIAS_BASE" \
    "$@"
