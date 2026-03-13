BEGIN {
    has_entry = 0
    has_setapen = 0
    has_halfhour = 0
    has_clamp = 0
    has_highlight = 0
    has_banner_reset = 0
    has_primary_code = 0
    has_secondary_code = 0
    has_countdown_cache = 0
    has_persist_arm = 0
    has_prop_done_clear = 0
    has_status_shift = 0
    has_propagate_guard = 0
    has_persist_request = 0
    has_propagate_meta = 0
    has_sync_filter = 0
    has_ensure_secondary = 0
    has_return = 0
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

    if (uline ~ /^ESQDISP_DRAWSTATUSBANNER_IMP/) has_entry = 1
    if (uline ~ /_LVOSETAPEN/) has_setapen = 1
    if (uline ~ /ESQFUNC_JMPTBL_ESQ_GETHALFHOUR/ || uline ~ /ESQ_GETHALFHOUR/) has_halfhour = 1
    if (uline ~ /ESQFUNC_JMPTBL_ESQ_CLAMPBANNERCH/ || uline ~ /ESQ_CLAMPBANNERCH/) has_clamp = 1
    if (uline ~ /ESQFUNC_JMPTBL_LADFUNC_UPDATEHIG/ || uline ~ /LADFUNC_UPDATEHIG/) has_highlight = 1
    if (uline ~ /BANNER_RESETPENDINGFLAG/) has_banner_reset = 1
    if (uline ~ /TEXTDISP_PRIMARYGROUPCODE/) has_primary_code = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPCODE/) has_secondary_code = 1
    if (uline ~ /ESQDISP_LASTPRIMARYCOUNTDOWNVALU/) has_countdown_cache = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTARMGATEF/) has_persist_arm = 1
    if (uline ~ /ESQDISP_SECONDARYPROPAGATIONDONE/) has_prop_done_clear = 1
    if (uline ~ /WDISP_STATUSDAYENTRY0\\+\\$14/ ||
        uline ~ /WDISP_STATUSDAYENTRY0\\+\\$28/ ||
        uline ~ /WDISP_STATUSDAYENTRY0\\+\\$3C/) has_status_shift = 1
    if (uline ~ /TLIBA1_STATUSBANNERPROPAGATEGUAR/) has_propagate_guard = 1
    if (uline ~ /ESQDISP_SECONDARYPERSISTREQUESTF/) has_persist_request = 1
    if (uline ~ /ESQDISP_PROPAGATEPRIMARYTITLEMET/) has_propagate_meta = 1
    if (uline ~ /ESQFUNC_JMPTBL_LOCAVAIL_SYNCSECO/ || uline ~ /LOCAVAIL_SYNCSECO/) has_sync_filter = 1
    if (uline ~ /ESQFUNC_JMPTBL_P_TYPE_ENSURESECO/ || uline ~ /P_TYPE_ENSURESECO/) has_ensure_secondary = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETAPEN=" has_setapen
    print "HAS_HALFHOUR=" has_halfhour
    print "HAS_CLAMP=" has_clamp
    print "HAS_HIGHLIGHT=" has_highlight
    print "HAS_BANNER_RESET=" has_banner_reset
    print "HAS_PRIMARY_CODE=" has_primary_code
    print "HAS_SECONDARY_CODE=" has_secondary_code
    print "HAS_COUNTDOWN_CACHE=" has_countdown_cache
    print "HAS_PERSIST_ARM=" has_persist_arm
    print "HAS_PROP_DONE_CLEAR=" has_prop_done_clear
    print "HAS_STATUS_SHIFT=" has_status_shift
    print "HAS_PROPAGATE_GUARD=" has_propagate_guard
    print "HAS_PERSIST_REQUEST=" has_persist_request
    print "HAS_PROPAGATE_META=" has_propagate_meta
    print "HAS_SYNC_FILTER=" has_sync_filter
    print "HAS_ENSURE_SECONDARY=" has_ensure_secondary
    print "HAS_RETURN=" has_return
}
