#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_testentryflagyandbit1_trial.sh \
    "$ALIAS_BASE" \
    "$@"
