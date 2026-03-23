#!/bin/bash
set -euo pipefail

ALIAS_BASE="newgrid2_jmptbl_esq_get_half_hour_slot_index"
exec bash src/decomp/scripts/compare_sasc_alias_wrapper.sh \
    src/decomp/scripts/compare_sasc_newgrid2_jmptbl_esq_gethalfhourslotindex_trial.sh \
    "$ALIAS_BASE" \
    "$@"
