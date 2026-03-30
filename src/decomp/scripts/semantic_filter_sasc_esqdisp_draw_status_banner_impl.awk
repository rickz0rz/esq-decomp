BEGIN {
    has_entry = 0
    has_setapen = 0
    has_halfhour = 0
    has_clamp = 0
    has_highlight = 0
    has_banner_reset = 0
    has_slot_range_lower = 0
    has_slot_range_upper = 0
    has_primary_code = 0
    has_secondary_code = 0
    has_end_of_year_day_check = 0
    has_end_of_year_month_check = 0
    has_secondary_wrap_to_one = 0
    has_year_wrap_modulo = 0
    has_leap_primary_code = 0
    has_nonleap_primary_code = 0
    has_countdown_cache = 0
    has_countdown_slot3_reset = 0
    has_countdown_slot46_clear = 0
    has_persist_arm = 0
    has_prop_done_clear = 0
    has_status_inactive_check = 0
    has_status_current_day_check = 0
    has_status_plus_100_check = 0
    has_status_shift = 0
    has_propagate_guard = 0
    has_slot1_reset = 0
    has_persist_request = 0
    has_slot44_clear = 0
    has_slot45_gate = 0
    has_propagate_meta = 0
    has_sync_filter = 0
    has_ensure_secondary = 0
    has_return = 0

    saw_const_1 = 0
    saw_const_2 = 0
    saw_const_3 = 0
    saw_const_11 = 0
    saw_const_31 = 0
    saw_const_39 = 0
    saw_const_40 = 0
    saw_const_44 = 0
    saw_const_45 = 0
    saw_const_46 = 0
    saw_const_100 = 0
    saw_const_6d = 0
    saw_const_6e = 0
    saw_shift_by_2 = 0

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

    if (uline ~ /#1([^0-9]|$)/ || index(uline, "#$1") > 0) saw_const_1 = 1
    if (uline ~ /#2([^0-9]|$)/ || index(uline, "#$2") > 0) saw_const_2 = 1
    if (uline ~ /#3([^0-9]|$)/ || index(uline, "#$3") > 0) saw_const_3 = 1
    if (uline ~ /#11([^0-9]|$)/ || index(uline, "#$B") > 0) saw_const_11 = 1
    if (uline ~ /#31([^0-9]|$)/ || index(uline, "#$1F") > 0) saw_const_31 = 1
    if (uline ~ /#39([^0-9]|$)/ || index(uline, "#$27") > 0) saw_const_39 = 1
    if (uline ~ /#40([^0-9]|$)/ || index(uline, "#$40") > 0) saw_const_40 = 1
    if (uline ~ /#44([^0-9]|$)/ || index(uline, "#$2C") > 0) saw_const_44 = 1
    if (uline ~ /#45([^0-9]|$)/ || index(uline, "#$2D") > 0) saw_const_45 = 1
    if (uline ~ /#46([^0-9]|$)/ || index(uline, "#$2E") > 0) saw_const_46 = 1
    if (uline ~ /#256([^0-9]|$)/ || index(uline, "#$100") > 0) saw_const_100 = 1
    if (index(uline, "#$6D") > 0) saw_const_6d = 1
    if (index(uline, "#$6E") > 0) saw_const_6e = 1
    if (index(uline, "LSL.L #$2") > 0 || index(uline, "ASL.L #$2") > 0) saw_shift_by_2 = 1

    if (uline ~ /^ESQDISP_DRAWSTATUSBANNER_IMP/) has_entry = 1
    if (uline ~ /_LVOSETAPEN/) has_setapen = 1
    if (uline ~ /ESQFUNC_JMPTBL_ESQ_GETHALFHOUR/ || uline ~ /ESQ_GETHALFHOUR/) has_halfhour = 1
    if (uline ~ /ESQFUNC_JMPTBL_ESQ_CLAMPBANNERCH/ || uline ~ /ESQ_CLAMPBANNERCH/) has_clamp = 1
    if (uline ~ /ESQFUNC_JMPTBL_LADFUNC_UPDATEHIG/ || uline ~ /LADFUNC_UPDATEHIG/) has_highlight = 1
    if (uline ~ /BANNER_RESETPENDINGFLAG/) has_banner_reset = 1
    if (uline ~ /TEXTDISP_PRIMARYGROUPCODE/) has_primary_code = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPCODE/) has_secondary_code = 1
    if (uline ~ /CLOCK_CACHEYEAR/) has_year_wrap_modulo = 1
    if (uline ~ /ESQDISP_LASTPRIMARYCOUNTDOWNVALU/) has_countdown_cache = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTARMGATEF/) has_persist_arm = 1
    if (uline ~ /ESQDISP_SECONDARYPROPAGATIONDONE/) has_prop_done_clear = 1
    if ((index(uline, "TST.L $10(") > 0) || (index(uline, "TST.L 16(A1)") > 0)) has_status_inactive_check = 1
    if (uline ~ /CLOCK_CURRENTDAYOFYEAR/) has_status_current_day_check = 1
    if (uline ~ /WDISP_STATUSDAYENTRY1/ ||
        uline ~ /WDISP_STATUSDAYENTRY2/ ||
        uline ~ /WDISP_STATUSDAYENTRY3/ ||
        index(uline, "WDISP_STATUSDAYENTRY0+$14") > 0 ||
        index(uline, "WDISP_STATUSDAYENTRY0+$28") > 0 ||
        index(uline, "WDISP_STATUSDAYENTRY0+$3C") > 0) has_status_shift = 1
    if (uline ~ /TLIBA1_STATUSBANNERPROPAGATEGUAR/) has_propagate_guard = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTREQUESTF/) has_persist_request = 1
    if (uline ~ /ESQDISP_PROPAGATEPRIMARYTITLEMET/) has_propagate_meta = 1
    if (uline ~ /ESQFUNC_JMPTBL_LOCAVAIL_SYNCSECO/ || uline ~ /LOCAVAIL_SYNCSECO/) has_sync_filter = 1
    if (uline ~ /ESQFUNC_JMPTBL_P_TYPE_ENSURESECO/ || uline ~ /P_TYPE_ENSURESECO/) has_ensure_secondary = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_slot_range_lower = saw_const_2
    has_slot_range_upper = saw_const_39
    has_end_of_year_day_check = saw_const_31
    has_end_of_year_month_check = saw_const_11
    if (has_secondary_code && saw_const_1) has_secondary_wrap_to_one = 1
    if (has_year_wrap_modulo && saw_const_3) has_year_wrap_modulo = 1
    else has_year_wrap_modulo = 0
    if (has_primary_code && saw_const_6e) has_leap_primary_code = 1
    if (has_primary_code && saw_const_6d) has_nonleap_primary_code = 1
    if (has_persist_arm && saw_const_3) has_countdown_slot3_reset = 1
    if (has_prop_done_clear && saw_const_46) has_countdown_slot46_clear = 1
    has_status_plus_100_check = saw_const_100 || (saw_const_40 && saw_shift_by_2)
    if (has_persist_arm && saw_const_1) has_slot1_reset = 1
    if (has_prop_done_clear && saw_const_44) has_slot44_clear = 1
    has_slot45_gate = saw_const_45

    print "HAS_ENTRY=" has_entry
    print "HAS_SETAPEN=" has_setapen
    print "HAS_HALFHOUR=" has_halfhour
    print "HAS_CLAMP=" has_clamp
    print "HAS_HIGHLIGHT=" has_highlight
    print "HAS_BANNER_RESET=" has_banner_reset
    print "HAS_SLOT_RANGE_LOWER=" has_slot_range_lower
    print "HAS_SLOT_RANGE_UPPER=" has_slot_range_upper
    print "HAS_PRIMARY_CODE=" has_primary_code
    print "HAS_SECONDARY_CODE=" has_secondary_code
    print "HAS_END_OF_YEAR_DAY_CHECK=" has_end_of_year_day_check
    print "HAS_END_OF_YEAR_MONTH_CHECK=" has_end_of_year_month_check
    print "HAS_SECONDARY_WRAP_TO_ONE=" has_secondary_wrap_to_one
    print "HAS_YEAR_WRAP_MODULO=" has_year_wrap_modulo
    print "HAS_LEAP_PRIMARY_CODE=" has_leap_primary_code
    print "HAS_NONLEAP_PRIMARY_CODE=" has_nonleap_primary_code
    print "HAS_COUNTDOWN_CACHE=" has_countdown_cache
    print "HAS_COUNTDOWN_SLOT3_RESET=" has_countdown_slot3_reset
    print "HAS_COUNTDOWN_SLOT46_CLEAR=" has_countdown_slot46_clear
    print "HAS_PERSIST_ARM=" has_persist_arm
    print "HAS_PROP_DONE_CLEAR=" has_prop_done_clear
    print "HAS_STATUS_INACTIVE_CHECK=" has_status_inactive_check
    print "HAS_STATUS_CURRENT_DAY_CHECK=" has_status_current_day_check
    print "HAS_STATUS_PLUS_100_CHECK=" has_status_plus_100_check
    print "HAS_STATUS_SHIFT=" has_status_shift
    print "HAS_PROPAGATE_GUARD=" has_propagate_guard
    print "HAS_SLOT1_RESET=" has_slot1_reset
    print "HAS_PERSIST_REQUEST=" has_persist_request
    print "HAS_SLOT44_CLEAR=" has_slot44_clear
    print "HAS_SLOT45_GATE=" has_slot45_gate
    print "HAS_PROPAGATE_META=" has_propagate_meta
    print "HAS_SYNC_FILTER=" has_sync_filter
    print "HAS_ENSURE_SECONDARY=" has_ensure_secondary
    print "HAS_RETURN=" has_return
}
