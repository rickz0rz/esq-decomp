BEGIN {
    has_entry = 0
    has_setapen = 0
    has_setdrmd = 0
    availmem_calls = 0
    sprintf_calls = 0
    display_calls = 0
    has_mode0_gate = 0
    has_mode1_gate = 0
    has_memmask_all = 0
    has_memmask_chip = 0
    has_memmask_fast = 0
    has_memmask_max = 0
    has_memmask_disabled = 0
    has_mode0_formats = 0
    has_mode1_formats = 0
    has_compute_htc = 0
    has_update_ctrl_h = 0
    has_bitmap_swap_in = 0
    has_restore_bitmap = 0
    has_unlk = 0
    has_rts = 0
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
    if (uline ~ /LVOSETAPEN\(A6\)/) has_setapen = 1
    if (uline ~ /LVOSETDRMD\(A6\)/) has_setdrmd = 1
    if (uline ~ /LVOAVAILMEM\(A6\)/) availmem_calls++
    if (uline ~ /GROUP_AM_JMPTBL_WDISP_SPRINTF/) sprintf_calls++
    if (uline ~ /ESQPARS_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION/) display_calls++
    if (uline ~ /MOVE\.W ED_DIAGNOSTICSVIEWMODE,D0/ || uline ~ /SUBQ\.W #1,D0/) has_mode1_gate = 1
    if (uline ~ /MOVE\.W ED_DIAGNOSTICSVIEWMODE,D0/ || uline ~ /BNE\.W \.DRAW_CALENDAR_SECTION/) has_mode0_gate = 1
    if (uline ~ /ED_DIAGAVAILMEMMASK/ && (uline ~ /MOVEQ #7,D0/ || uline ~ /SUBQ\.L #7,D0/)) has_memmask_all = 1
    if (uline ~ /ED_DIAGAVAILMEMMASK/ && (uline ~ /MOVEQ #1,D0/ || uline ~ /SUBQ\.L #1,D0/)) has_memmask_chip = 1
    if (uline ~ /ED_DIAGAVAILMEMMASK/ && (uline ~ /MOVEQ #2,D0/ || uline ~ /SUBQ\.L #2,D0/)) has_memmask_fast = 1
    if (uline ~ /ED_DIAGAVAILMEMMASK/ && (uline ~ /MOVEQ #4,D0/ || uline ~ /SUBQ\.L #4,D0/)) has_memmask_max = 1
    if (uline ~ /GLOBAL_STR_MEMORY_TYPES_DISABLED/) has_memmask_disabled = 1
    if (uline ~ /GLOBAL_STR_DATA_CMDS_CERRS_LERRS/ ||
        uline ~ /GLOBAL_STR_CTRL_CMDS_CERRS_LERRS/ ||
        uline ~ /GLOBAL_STR_L_CHIP_FAST_MAX/ ||
        uline ~ /GLOBAL_STR_CHIP_PLACEHOLDER/ ||
        uline ~ /GLOBAL_STR_FAST_PLACEHOLDER/ ||
        uline ~ /GLOBAL_STR_MAX_PLACEHOLDER/ ||
        uline ~ /GLOBAL_STR_MEMORY_TYPES_DISABLED/ ||
        uline ~ /GLOBAL_STR_DATA_OVERRUNS_FORMATTED/ ||
        uline ~ /GLOBAL_STR_DATA_H_T_C_MAX_FORMATTED/ ||
        uline ~ /GLOBAL_STR_CTRL_H_T_C_MAX_FORMATTED/) has_mode0_formats = 1
    if (uline ~ /GLOBAL_STR_JULIAN_DAY_NEXT_FORMATTED/ ||
        uline ~ /GLOBAL_STR_JDAY1_JDAY2_FORMATTED/ ||
        uline ~ /GLOBAL_STR_CURCLU_NXTCLU_FORMATTED/ ||
        uline ~ /GLOBAL_STR_C_DATE_C_MONTH_LP_YR_FORMATTED/ ||
        uline ~ /GLOBAL_STR_B_DATE_B_MONTH_LP_YR_FORMATTED/ ||
        uline ~ /GLOBAL_STR_C_DST_B_DST_PSHIFT_FORMATTED/ ||
        uline ~ /GLOBAL_STR_C_HOUR_B_HOUR_CS_FORMATTED/) has_mode1_formats = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_COMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_UPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (uline ~ /^MOVE\.L #GLOBAL_REF_696_400_BITMAP,4\(A0\)$/) has_bitmap_swap_in = 1
    if (uline ~ /^MOVE\.L -76\(A5\),4\(A0\)$/) has_restore_bitmap = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_MODE0_GATE=" has_mode0_gate
    print "HAS_MODE1_GATE=" has_mode1_gate
    print "HAS_MEMMASK_ALL=" has_memmask_all
    print "HAS_MEMMASK_CHIP=" has_memmask_chip
    print "HAS_MEMMASK_FAST=" has_memmask_fast
    print "HAS_MEMMASK_MAX=" has_memmask_max
    print "HAS_MEMMASK_DISABLED=" has_memmask_disabled
    print "HAS_MODE0_FORMATS=" has_mode0_formats
    print "HAS_MODE1_FORMATS=" has_mode1_formats
    print "HAS_AVAILMEM_CALLS_GE_6=" (availmem_calls >= 6)
    print "HAS_SPRINTF_CALLS_GE_13=" (sprintf_calls >= 13)
    print "HAS_DISPLAY_CALLS_GE_13=" (display_calls >= 13)
    print "HAS_COMPUTE_HTC=" has_compute_htc
    print "HAS_UPDATE_CTRL_H=" has_update_ctrl_h
    print "HAS_BITMAP_SWAP_IN=" has_bitmap_swap_in
    print "HAS_RESTORE_BITMAP=" has_restore_bitmap
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
