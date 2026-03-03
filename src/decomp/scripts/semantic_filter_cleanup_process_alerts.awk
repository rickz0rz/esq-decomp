BEGIN {
    has_label = 0
    has_save = 0
    has_pending_test = 0
    has_diag_draw = 0
    has_tick_clock = 0
    has_update_banner = 0
    has_draw_status = 0
    has_update_rtc = 0
    has_refresh_banner = 0
    has_draw_grid_time = 0
    has_draw_clock_banner = 0
    has_update_ctrl_sm = 0
    has_finish = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_PROCESSALERTS:/) has_label = 1
    if (uline ~ /MOVEM.L D2\/D7,-\(A7\)/) has_save = 1
    if (uline ~ /CLEANUP_PENDINGALERTFLAG/) has_pending_test = 1
    if (uline ~ /GROUP_AC_JMPTBL_ESQFUNC_DRAWDIAGNOSTICSSCREEN/) has_diag_draw = 1
    if (uline ~ /ESQ_TICKCLOCKANDFLAGEVENTS/) has_tick_clock = 1
    if (uline ~ /GROUP_AC_JMPTBL_DST_UPDATEBANNERQUEUE/) has_update_banner = 1
    if (uline ~ /GROUP_AC_JMPTBL_ESQDISP_DRAWSTATUSBANNER/) has_draw_status = 1
    if (uline ~ /GROUP_AC_JMPTBL_PARSEINI_UPDATECLOCKFROMRTC/) has_update_rtc = 1
    if (uline ~ /GROUP_AC_JMPTBL_DST_REFRESHBANNERBUFFER/) has_refresh_banner = 1
    if (uline ~ /CLEANUP_DRAWGRIDTIMEBANNER/) has_draw_grid_time = 1
    if (uline ~ /CLEANUP_DRAWCLOCKBANNER/) has_draw_clock_banner = 1
    if (uline ~ /GROUP_AC_JMPTBL_SCRIPT_UPDATECTRLSTATEMACHINE/) has_update_ctrl_sm = 1
    if (uline ~ /\.FINISH:/ && uline !~ /\.RETURN_STATUS:/) has_finish = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2\/D7/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_PENDING_TEST=" has_pending_test
    print "HAS_DIAG_DRAW=" has_diag_draw
    print "HAS_TICK_CLOCK=" has_tick_clock
    print "HAS_UPDATE_BANNER=" has_update_banner
    print "HAS_DRAW_STATUS=" has_draw_status
    print "HAS_UPDATE_RTC=" has_update_rtc
    print "HAS_REFRESH_BANNER=" has_refresh_banner
    print "HAS_DRAW_GRID_TIME=" has_draw_grid_time
    print "HAS_DRAW_CLOCK_BANNER=" has_draw_clock_banner
    print "HAS_UPDATE_CTRL_SM=" has_update_ctrl_sm
    print "HAS_FINISH=" has_finish
    print "HAS_RESTORE=" has_restore
}
