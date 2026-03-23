#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_coi_render_clock_format_entry_variant"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_coi_renderclockformatentryvariant_trial.sh \
    "$ALIAS_BASE" \
    "$@"
