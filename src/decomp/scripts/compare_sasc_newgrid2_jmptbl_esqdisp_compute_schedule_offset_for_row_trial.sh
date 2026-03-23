#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_computescheduleoffsetforrow_trial.sh \
    "$ALIAS_BASE" \
    "$@"
