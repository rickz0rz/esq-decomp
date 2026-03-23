#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_esq_test_bit1_based"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esq_testbit1based_trial.sh \
    "$ALIAS_BASE" \
    "$@"
