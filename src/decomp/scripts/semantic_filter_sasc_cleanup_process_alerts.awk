BEGIN {
    has_label = 0
    has_pending_gate = 0
    has_processing_gate = 0
    has_diag_refresh = 0
    has_filter_step = 0
    has_tick_clock = 0
    has_ctrl_timeout = 0
    has_attention = 0
    has_banner_queue = 0
    has_status_banner = 0
    has_update_clock = 0
    has_normalize = 0
    has_draw_grid = 0
    has_draw_clock = 0
    has_update_ctrl_state = 0
    has_finish_clear = 0
    has_return = 0
    tick_call_count = 0
    has_first_tick_store = 0
    has_second_tick_store = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_PROCESSALERTS[A-Z0-9_]*:/) has_label = 1
    if (u ~ /CLEANUP_PENDINGALERTFLAG/) has_pending_gate = 1
    if (u ~ /CLEANUP_ALERTPROCESSINGFLAG/) has_processing_gate = 1
    if (u ~ /DRAWDIAGNOSTICSSCREEN/ || u ~ /GROUP_AC_JMPTBL_ESQFUNC_DRAWDIAG/) has_diag_refresh = 1
    if (u ~ /LOCAVAIL_FILTERSTEP/ || u ~ /RESETSELECTIONANDREFRESH/) has_filter_step = 1
    if (u ~ /ESQ_TICKCLOCKANDFLAGEVENTS/ || u ~ /TICKCLOCKANDFLAGEVENTS/) has_tick_clock = 1
    if (u ~ /UPDATECTRLLINETIMEOUT/ || u ~ /CLEARCTRLLINEIFENABLED/ || u ~ /GROUP_AC_JMPTBL_SCRIPT_CLEARCTRL/ || u ~ /GROUP_AC_JMPTBL_SCRIPT_UPDATECTR/) has_ctrl_timeout = 1
    if (u ~ /SHOWATTENTIONOVERLAY/ || u ~ /GROUP_AH_JMPTBL_ESQIFF2_SHOWATTE/) has_attention = 1
    if (u ~ /UPDATEBANNERQUEUE/ || u ~ /GROUP_AC_JMPTBL_DST_UPDATEBANNER/) has_banner_queue = 1
    if (u ~ /DRAWSTATUSBANNER/ || u ~ /GROUP_AC_JMPTBL_ESQDISP_DRAWSTAT/) has_status_banner = 1
    if (u ~ /UPDATECLOCKFROMRTC/ || u ~ /REFRESHBANNERBUFFER/ || u ~ /GROUP_AC_JMPTBL_PARSEINI_UPDATEC/ || u ~ /GROUP_AC_JMPTBL_DST_REFRESHBANNE/) has_update_clock = 1
    if (u ~ /NORMALIZEVALUEBYSTEP/) has_normalize = 1
    if (u ~ /CLEANUP_DRAWGRIDTIMEBANNER/ || u ~ /DRAWGRIDTIMEBANNER/) has_draw_grid = 1
    if (u ~ /CLEANUP_DRAWCLOCKBANNER/ || u ~ /DRAWCLOCKBANNER/) has_draw_clock = 1
    if (u ~ /UPDATECTRLSTATEMACHINE/ || u ~ /GROUP_AC_JMPTBL_SCRIPT_UPDATECTR/) has_update_ctrl_state = 1
    if (u ~ /CLEANUP_ALERTPROCESSINGFLAG/ && (u ~ /CLR.L/ || u ~ /MOVEQ.L #0/ || u ~ /MOVE.L D[0-7],CLEANUP_ALERTPROCESSINGFLAG/)) has_finish_clear = 1
    if (u == "RTS") has_return = 1
    if (u ~ /ESQ_TICKCLOCKANDFLAGEVENTS/ || u ~ /TICKCLOCKANDFLAGEVENTS/) {
        tick_call_count++
        next
    }
    if (tick_call_count == 1 && u ~ /^MOVE\.[BWL] D0,/) has_first_tick_store = 1
    if (tick_call_count == 2 && u ~ /^MOVE\.[BWL] D0,/) has_second_tick_store = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_PENDING_GATE=" has_pending_gate
    print "HAS_PROCESSING_GATE=" has_processing_gate
    print "HAS_DIAG_REFRESH=" has_diag_refresh
    print "HAS_FILTER_STEP=" has_filter_step
    print "HAS_TICK_CLOCK=" has_tick_clock
    print "HAS_CTRL_TIMEOUT=" has_ctrl_timeout
    print "HAS_ATTENTION=" has_attention
    print "HAS_BANNER_QUEUE=" has_banner_queue
    print "HAS_STATUS_BANNER=" has_status_banner
    print "HAS_UPDATE_CLOCK=" has_update_clock
    print "HAS_NORMALIZE=" has_normalize
    print "HAS_DRAW_GRID=" has_draw_grid
    print "HAS_DRAW_CLOCK=" has_draw_clock
    print "HAS_UPDATE_CTRL_STATE=" has_update_ctrl_state
    print "HAS_FINISH_CLEAR=" has_finish_clear
    print "HAS_RETURN=" has_return
    print "HAS_FIRST_TICK_STORE=" has_first_tick_store
    print "HAS_SECOND_TICK_STORE=" has_second_tick_store
}
