#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_cleanup_update_entry_flag_bytes"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_cleanup_updateentryflagbytes_trial.sh \
    "$ALIAS_BASE" \
    "$@"
