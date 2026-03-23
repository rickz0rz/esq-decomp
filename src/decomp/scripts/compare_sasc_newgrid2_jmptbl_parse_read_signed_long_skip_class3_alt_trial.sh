#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_parse_readsignedlongskipclass3_alt_trial.sh \
    "$ALIAS_BASE" \
    "$@"
