#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_str_skip_class3_chars"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_str_skipclass3chars_trial.sh \
    "$ALIAS_BASE" \
    "$@"
