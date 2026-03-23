#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_cleanup_format_clock_format_entry"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_formatclockformatentry_trial.sh \
    "$ALIAS_BASE" \
    "$@"
