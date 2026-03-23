#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_string_append_n"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_string_appendn_trial.sh \
    "$ALIAS_BASE" \
    "$@"
