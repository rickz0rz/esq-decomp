#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_bevel_drawbevelframewithtopright_trial.sh \
    "$ALIAS_BASE" \
    "$@"
