#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_tliba_find_first_wildcard_match_index"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_tliba_findfirstwildcardmatchindex_trial.sh \
    "$ALIAS_BASE" \
    "$@"
