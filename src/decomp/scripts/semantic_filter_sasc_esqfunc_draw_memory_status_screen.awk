BEGIN {
    has_entry = 0
    has_setapen = 0
    has_setdrmd = 0
    availmem_calls = 0
    sprintf_calls = 0
    display_calls = 0
    has_mode0_gate = 0
    has_mode1_gate = 0
    has_compute_htc = 0
    has_update_ctrl_h = 0
    has_bitmap_swap_in = 0
    has_restore_bitmap = 0
    has_unlk = 0
    has_rts = 0
    has_data_cmds = 0
    has_ctrl_cmds = 0
    has_mem_all_fmt = 0
    has_mem_chip_fmt = 0
    has_mem_fast_fmt = 0
    has_mem_max_fmt = 0
    has_mem_disabled_fmt = 0
    has_data_overruns_fmt = 0
    has_data_htc_fmt = 0
    has_ctrl_htc_fmt = 0
    has_julian_fmt = 0
    has_jday_fmt = 0
    has_curclu_fmt = 0
    has_cache_date_fmt = 0
    has_current_date_fmt = 0
    has_dst_fmt = 0
    has_hour_fmt = 0
    has_mask_all_branch = 0
    has_mask_chip_branch = 0
    has_mask_fast_branch = 0
    has_mask_max_branch = 0
    has_availmem_largest_chip = 0
    has_availmem_fast = 0
    has_availmem_chip = 0
    has_availmem_largest = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_DRAWMEMORYSTATUSSCREEN:/) has_entry = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVOSETDRMD/) has_setdrmd = 1
    if (uline ~ /LVOAVAILMEM/) availmem_calls++
    if (uline ~ /GROUP_AM_JMPTBL_WDISP_SPRINTF/ || uline ~ /WDISP_SPRINTF/) sprintf_calls++
    if (uline ~ /ESQPARS_JMPTBL_DISPLIB_DISPLAYTE/ || uline ~ /DISPLIB_DISPLAYTEXTATPOSITION/) display_calls++
    if (uline ~ /MOVE\.W ED_DIAGNOSTICSVIEWMODE\(A4\),D0/ || uline ~ /BNE\.W ___ESQFUNC_DRAWMEMORYSTATUSSCREEN__16/) has_mode0_gate = 1
    if (uline ~ /SUBQ\.W #\$1,D0/) has_mode1_gate = 1
    if (uline ~ /GLOBAL_STR_DATA_CMDS_CERRS_LERRS/) has_data_cmds = 1
    if (uline ~ /GLOBAL_STR_CTRL_CMDS_CERRS_LERRS/) has_ctrl_cmds = 1
    if (uline ~ /GLOBAL_STR_L_CHIP_FAST_MAX/) has_mem_all_fmt = 1
    if (uline ~ /GLOBAL_STR_CHIP_PLACEHOLDER/) has_mem_chip_fmt = 1
    if (uline ~ /GLOBAL_STR_FAST_PLACEHOLDER/) has_mem_fast_fmt = 1
    if (uline ~ /GLOBAL_STR_MAX_PLACEHOLDER/) has_mem_max_fmt = 1
    if (uline ~ /GLOBAL_STR_MEMORY_TYPES_DISABLED/) has_mem_disabled_fmt = 1
    if (uline ~ /GLOBAL_STR_DATA_OVERRUNS_FORMATT/) has_data_overruns_fmt = 1
    if (uline ~ /GLOBAL_STR_DATA_H_T_C_MAX_FORMAT/) has_data_htc_fmt = 1
    if (uline ~ /GLOBAL_STR_CTRL_H_T_C_MAX_FORMAT/) has_ctrl_htc_fmt = 1
    if (uline ~ /GLOBAL_STR_JULIAN_DAY_NEXT_FORMA/) has_julian_fmt = 1
    if (uline ~ /GLOBAL_STR_JDAY1_JDAY2_FORMATTED/) has_jday_fmt = 1
    if (uline ~ /GLOBAL_STR_CURCLU_NXTCLU_FORMATT/) has_curclu_fmt = 1
    if (uline ~ /GLOBAL_STR_C_DATE_C_MONTH_LP_YR_/) has_cache_date_fmt = 1
    if (uline ~ /GLOBAL_STR_B_DATE_B_MONTH_LP_YR_/) has_current_date_fmt = 1
    if (uline ~ /GLOBAL_STR_C_DST_B_DST_PSHIFT_FO/) has_dst_fmt = 1
    if (uline ~ /GLOBAL_STR_C_HOUR_B_HOUR_CS_FORM/) has_hour_fmt = 1
    if (uline ~ /SUBQ\.L #\$7,D0/) has_mask_all_branch = 1
    if (uline ~ /SUBQ\.L #\$1,D0/) has_mask_chip_branch = 1
    if (uline ~ /SUBQ\.L #\$2,D0/) has_mask_fast_branch = 1
    if (uline ~ /SUBQ\.L #\$4,D0/) has_mask_max_branch = 1
    if (uline ~ /MOVE\.L #\$20002,-\(A7\)/) has_availmem_largest_chip = 1
    if (uline ~ /PEA \(\$4\)\.W/) has_availmem_fast = 1
    if (uline ~ /PEA \(\$2\)\.W/) has_availmem_chip = 1
    if (uline ~ /MOVE\.L #\$20000,\(A7\)/ || uline ~ /MOVE\.L #\$20000,-\(A7\)/) has_availmem_largest = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_COMPUTEH/ || uline ~ /PARSEINI_COMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_UPDATECT/ || uline ~ /PARSEINI_UPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (uline ~ /^MOVE\.L GLOBAL_REF_696_400_BITMAP\(A4\),\$4\(A0\)$/) has_bitmap_swap_in = 1
    if (uline ~ /^MOVE\.L A5,\$4\(A0\)$/ || uline ~ /^MOVE\.L -76\(A5\),4\(A0\)$/) has_restore_bitmap = 1
    if (uline ~ /^ADD\.W #\$4C,A7$/ || uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_MODE0_GATE=" has_mode0_gate
    print "HAS_MODE1_GATE=" has_mode1_gate
    print "HAS_DATA_CMDS_FMT=" has_data_cmds
    print "HAS_CTRL_CMDS_FMT=" has_ctrl_cmds
    print "HAS_MEM_ALL_FMT=" has_mem_all_fmt
    print "HAS_MEM_CHIP_FMT=" has_mem_chip_fmt
    print "HAS_MEM_FAST_FMT=" has_mem_fast_fmt
    print "HAS_MEM_MAX_FMT=" has_mem_max_fmt
    print "HAS_MEM_DISABLED_FMT=" has_mem_disabled_fmt
    print "HAS_DATA_OVERRUNS_FMT=" has_data_overruns_fmt
    print "HAS_DATA_HTC_FMT=" has_data_htc_fmt
    print "HAS_CTRL_HTC_FMT=" has_ctrl_htc_fmt
    print "HAS_JULIAN_FMT=" has_julian_fmt
    print "HAS_JDAY_FMT=" has_jday_fmt
    print "HAS_CURCLU_FMT=" has_curclu_fmt
    print "HAS_CACHE_DATE_FMT=" has_cache_date_fmt
    print "HAS_CURRENT_DATE_FMT=" has_current_date_fmt
    print "HAS_DST_FMT=" has_dst_fmt
    print "HAS_HOUR_FMT=" has_hour_fmt
    print "HAS_MASK_ALL_BRANCH=" has_mask_all_branch
    print "HAS_MASK_CHIP_BRANCH=" has_mask_chip_branch
    print "HAS_MASK_FAST_BRANCH=" has_mask_fast_branch
    print "HAS_MASK_MAX_BRANCH=" has_mask_max_branch
    print "HAS_AVAILMEM_LARGEST_CHIP=" has_availmem_largest_chip
    print "HAS_AVAILMEM_FAST=" has_availmem_fast
    print "HAS_AVAILMEM_CHIP=" has_availmem_chip
    print "HAS_AVAILMEM_LARGEST=" has_availmem_largest
    print "HAS_AVAILMEM_CALLS_EQ_6=" (availmem_calls == 6)
    print "HAS_SPRINTF_CALLS_EQ_17=" (sprintf_calls == 17)
    print "HAS_DISPLAY_CALLS_EQ_13=" (display_calls == 13)
    print "HAS_COMPUTE_HTC=" has_compute_htc
    print "HAS_UPDATE_CTRL_H=" has_update_ctrl_h
    print "HAS_BITMAP_SWAP_IN=" has_bitmap_swap_in
    print "HAS_RESTORE_BITMAP=" has_restore_bitmap
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
