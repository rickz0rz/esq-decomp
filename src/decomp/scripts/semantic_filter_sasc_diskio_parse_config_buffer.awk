BEGIN {
    has_entry = 0
    has_parse = 0
    has_brush_select = 0
    has_time_window_store = 0
    has_gate_duration_store = 0
    has_selection16_store = 0
    has_clock_format_store = 0
    has_diag_find = 0
    has_pc1_call = 0
    has_lrbn_find = 0
    has_banner_transition = 0
    has_msn_find = 0
    has_refresh_update = 0
    has_mulu = 0
    has_store_minutes = 0
    has_store_seconds = 0
    has_rts = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

function is_call(line) {
    return (line ~ /^(JSR|BSR(\.[A-Z]+)?|BSR\.W) /)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DISKIO_PARSECONFIGBUFFER:/ || l ~ /^DISKIO_PARSECONFIGBUFF/) has_entry = 1

    if (is_call(l) &&
        (index(l, "GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT") > 0 ||
         index(l, "PARSE_TWO_DIGITS") > 0 ||
         index(l, "PARSE_THREE_DIGITS") > 0)) {
        has_parse = 1
    }

    if (is_call(l) && index(l, "BRUSH_SELECTBRUSHBYLABEL") > 0) has_brush_select = 1
    if (index(l, "CONFIG_TIMEWINDOWMINUTES") > 0 && l ~ /^MOVE\.L /) has_time_window_store = 1
    if (index(l, "CONFIG_MODECYCLEGATEDURATION") > 0 && l ~ /^MOVE\.L /) has_gate_duration_store = 1
    if (index(l, "CONFIG_NEWGRIDSELECTIONCODE16") > 0 && l ~ /^MOVE\.B /) has_selection16_store = 1
    if (index(l, "GLOBAL_REF_STR_CLOCK_FORMAT") > 0 && l ~ /^MOVE\.L /) has_clock_format_store = 1

    if (is_call(l) && index(l, "GROUP_AI_JMPTBL_STR_FINDCHARPTR") > 0) {
        if (index(prev, "DISKIO_TAG_NRLS") > 0 || index(prev2, "DISKIO_TAG_NRLS") > 0) has_diag_find = 1
        if (index(prev, "DISKIO_TAG_LRBN") > 0 || index(prev2, "DISKIO_TAG_LRBN") > 0) has_lrbn_find = 1
        if (index(prev, "DISKIO_TAG_MSN") > 0 || index(prev2, "DISKIO_TAG_MSN") > 0) has_msn_find = 1
    }

    if (is_call(l) &&
        (index(l, "DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED") > 0 ||
         index(l, "DISKIO_ENSUREPC1MOUNTEDANDGFXASS") > 0)) {
        has_pc1_call = 1
    }

    if (is_call(l) &&
        (index(l, "GROUP_AG_JMPTBL_SCRIPT_BEGINBANNERCHARTRANSITION") > 0 ||
         index(l, "GROUP_AG_JMPTBL_SCRIPT_BEGINBANN") > 0)) {
        has_banner_transition = 1
    }

    if (is_call(l) &&
        (index(l, "ESQFUNC_UPDATEREFRESHMODESTATE") > 0 ||
         index(l, "GROUP_AG_JMPTBL_ESQFUNC_UPDATERE") > 0)) {
        has_refresh_update = 1
    }

    if (is_call(l) && index(l, "MATH_MULU32") > 0) has_mulu = 1
    if (index(l, "CONFIG_REFRESHINTERVALMINUTES") > 0 && l ~ /^MOVE\.B /) has_store_minutes = 1
    if (index(l, "CONFIG_REFRESHINTERVALSECONDS") > 0 && l ~ /^MOVE\.L /) has_store_seconds = 1
    if (l ~ /^RTS$/) has_rts = 1

    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PARSE=" has_parse
    print "HAS_BRUSH_SELECT=" has_brush_select
    print "HAS_TIME_WINDOW_STORE=" has_time_window_store
    print "HAS_GATE_DURATION_STORE=" has_gate_duration_store
    print "HAS_SELECTION16_STORE=" has_selection16_store
    print "HAS_CLOCK_FORMAT_STORE=" has_clock_format_store
    print "HAS_DIAG_FIND=" has_diag_find
    print "HAS_PC1_CALL=" has_pc1_call
    print "HAS_LRBN_FIND=" has_lrbn_find
    print "HAS_BANNER_TRANSITION=" has_banner_transition
    print "HAS_MSN_FIND=" has_msn_find
    print "HAS_REFRESH_UPDATE=" has_refresh_update
    print "HAS_MULU=" has_mulu
    print "HAS_STORE_MINUTES=" has_store_minutes
    print "HAS_STORE_SECONDS=" has_store_seconds
    print "HAS_RTS=" has_rts
}
