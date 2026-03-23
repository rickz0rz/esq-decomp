#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_esqdisp_test_entry_bits0_and2"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esqdisp_testentrybits0and2_trial.sh \
    "$ALIAS_BASE" \
    "$@"
