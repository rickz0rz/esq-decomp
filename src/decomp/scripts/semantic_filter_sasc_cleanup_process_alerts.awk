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
    has_brush_cmp_1 = 0
    has_brush_cmp_2 = 0
    has_brush_cmp_3 = 0
    has_overlay_code_3 = 0
    has_overlay_code_4 = 0
    has_overlay_code_5 = 0
    has_weather_countdown = 0
    has_banner_tick_counter = 0
    has_banner_tick_reset = 0
    has_day_entry_decrement = 0
    has_clamp_gate_toggle = 0
    has_reset_pending = 0
    has_type2_divide = 0
    has_type2_clear_brush = 0
    has_deferred_delay_clear = 0
    has_free_extra_titles = 0
    has_set_apen = 0
    has_tick_cmp_2 = 0
    has_tick_cmp_3 = 0
    has_tick_cmp_4 = 0
    has_tick_cmp_5 = 0
    has_menu_state_8 = 0
    has_menu_state_7 = 0
    tick_call_count = 0
    has_first_tick_store = 0
    has_second_tick_store = 0
    attention_call_count = 0
    status_banner_call_count = 0
    status_banner_arg0_count = 0
    status_banner_arg1_count = 0
    normalize_call_count = 0
    pending_brush_cmp = 0
    pending_menu_state = 0
    pending_tick_cmp = 0
    pending_status_banner_arg = -1
    pending_d7_cmp = 0
    has_const_60 = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

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
    if (u ~ /^MOVE\.W #\(-1\),TEXTDISP_DEFERREDACTIONDELAYTICK/ || u ~ /^MOVE\.W #\$FFFF/ || u ~ /^MOVE\.W #\$FFFFFFFF,TEXTDISP_DEFERREDACTIONDELAYTICK/) has_deferred_delay_clear = 1
    if (u ~ /FREEEXTRATITLETEXTPOINTE/ || u ~ /GROUP_AC_JMPTBL_ESQFUNC_FREEEXTRA/) has_free_extra_titles = 1
    if (u ~ /_LVOSETAPEN/) has_set_apen = 1
    if (u == "RTS") has_return = 1
    if (u ~ /^MOVEQ(\.L)? #\$1,D0$/ || u ~ /^MOVEQ(\.L)? #1,D0$/) pending_brush_cmp = 1
    else if (u ~ /^MOVEQ(\.L)? #\$2,D0$/ || u ~ /^MOVEQ(\.L)? #2,D0$/) pending_brush_cmp = 2
    else if (u ~ /^MOVEQ(\.L)? #\$3,D0$/ || u ~ /^MOVEQ(\.L)? #3,D0$/) pending_brush_cmp = 3
    if (u ~ /^MOVEQ(\.L)? #\$2,D0$/ || u ~ /^MOVEQ(\.L)? #2,D0$/) pending_tick_cmp = 2
    else if (u ~ /^MOVEQ(\.L)? #\$3,D0$/ || u ~ /^MOVEQ(\.L)? #3,D0$/) pending_tick_cmp = 3
    else if (u ~ /^MOVEQ(\.L)? #\$4,D0$/ || u ~ /^MOVEQ(\.L)? #4,D0$/) pending_tick_cmp = 4
    else if (u ~ /^MOVEQ(\.L)? #\$5,D0$/ || u ~ /^MOVEQ(\.L)? #5,D0$/) pending_tick_cmp = 5
    else if (u ~ /^MOVE\.B ED_MENUSTATEID/ || n ~ /^MOVEBEDMENUSTATEID/) pending_menu_state = 1
    if (u ~ /^PEA 1\.W$/ || u ~ /^PEA \$1\.W$/ || u ~ /^PEA .*1\.W$/ || u ~ /^PEA .*\$1\)\.W$/) pending_status_banner_arg = 1
    else if (u ~ /^CLR\.L -\(A7\)$/) pending_status_banner_arg = 0
    if (u ~ /^MOVE\.L D7,D0$/) pending_d7_cmp = 1
    if (u ~ /ESQ_TICKCLOCKANDFLAGEVENTS/ || u ~ /TICKCLOCKANDFLAGEVENTS/) {
        tick_call_count++
        next
    }
    if (n ~ /CMPLBRUSHPENDINGALERTCODEA4D0/ || n ~ /CMPLBRUSHPENDINGALERTCODED0/) {
        if (pending_brush_cmp == 1) has_brush_cmp_1 = 1
        if (pending_brush_cmp == 2) has_brush_cmp_2 = 1
        if (pending_brush_cmp == 3) has_brush_cmp_3 = 1
        pending_brush_cmp = 0
    }
    if ((u ~ /^JSR / || u ~ /^BSR\.[BWL]? /) && (u ~ /ESQIFF2_SHOWATTENTIONOVERLAY/ || u ~ /GROUP_AH_JMPTBL_ESQIFF2_SHOWATTE/)) attention_call_count++
    if (u ~ /PEA .*3\.W/ || u ~ /PEA .*\$3\)\.W/) has_overlay_code_3 = 1
    if (u ~ /PEA .*4\.W/ || u ~ /PEA .*\$4\)\.W/) has_overlay_code_4 = 1
    if (u ~ /PEA .*5\.W/ || u ~ /PEA .*\$5\)\.W/) has_overlay_code_5 = 1
    if (pending_d7_cmp == 1 && (u ~ /^SUBQ\.L #\$2,D0$/ || u ~ /^SUBQ\.L #2,D0$/)) {
        has_tick_cmp_2 = 1
        pending_d7_cmp = 0
    } else if (pending_d7_cmp == 1 && (u ~ /^SUBQ\.L #\$3,D0$/ || u ~ /^SUBQ\.L #3,D0$/)) {
        has_tick_cmp_3 = 1
        pending_d7_cmp = 0
    } else if (pending_d7_cmp == 1 && (u ~ /^SUBQ\.L #\$4,D0$/ || u ~ /^SUBQ\.L #4,D0$/)) {
        has_tick_cmp_4 = 1
        pending_d7_cmp = 0
    } else if (pending_d7_cmp == 1 && (u ~ /^SUBQ\.L #\$5,D0$/ || u ~ /^SUBQ\.L #5,D0$/)) {
        has_tick_cmp_5 = 1
        pending_d7_cmp = 0
    }
    if (u ~ /^CMP\.L D0,D7$/ || u ~ /^CMP\.L D[0-7],D7$/ || u ~ /^CMP\.L D7,D0$/ || u ~ /^CMP\.L D7,D[0-7]$/) {
        if (pending_tick_cmp == 2) has_tick_cmp_2 = 1
        if (pending_tick_cmp == 3) has_tick_cmp_3 = 1
        if (pending_tick_cmp == 4) has_tick_cmp_4 = 1
        if (pending_tick_cmp == 5) has_tick_cmp_5 = 1
        pending_tick_cmp = 0
    }
    if (u ~ /WDISP_WEATHERSTATUSCOUNTDOWN/ && (u ~ /SUBQ\.B/ || u ~ /^MOVE\.B D0,WDISP_WEATHERSTATUSCOUNTDOWN/)) has_weather_countdown = 1
    if (u ~ /CLEANUP_BANNERTICKCOUNTER/ && u ~ /SUBQ\.L/) has_banner_tick_counter = 1
    if (u ~ /#60/ || u ~ /#\$3C/) has_const_60 = 1
    if (u ~ /CLEANUP_BANNERTICKCOUNTER/ && u ~ /^MOVE\.[BWL] D0,/) has_banner_tick_reset = has_const_60
    if (u ~ /TLIBA1_DAYENTRYMODECOUNTER/ && (u ~ /SUBQ\.B/ || u ~ /^MOVE\.B D0,TLIBA1_DAYENTRYMODECOUNTER/)) has_day_entry_decrement = 1
    if (u ~ /ESQDISP_STATUSBANNERCLAMPGATE/ && (u ~ /CLR\.W/ || u ~ /#1/ || u ~ /#\$1/)) has_clamp_gate_toggle = 1
    if ((u ~ /^JSR / || u ~ /^BSR\.[BWL]? /) && (u ~ /ESQDISP_DRAWSTATUSBANNER/ || u ~ /GROUP_AC_JMPTBL_ESQDISP_DRAWSTAT/)) {
        status_banner_call_count++
        if (pending_status_banner_arg == 0) status_banner_arg0_count++
        else if (pending_status_banner_arg == 1) status_banner_arg1_count++
        pending_status_banner_arg = -1
    }
    if (u ~ /BANNER_RESETPENDINGFLAG/) has_reset_pending = 1
    if ((u ~ /^JSR / || u ~ /^BSR\.[BWL]? /) && u ~ /NORMALIZEVALUEBYSTEP/) normalize_call_count++
    if (u ~ /MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_type2_divide = 1
    if (u ~ /CLR\.L BRUSH_PENDINGALERTCODE/ || u ~ /CLR\.L BRUSH_PENDINGALERTCODE\(A4\)/) has_type2_clear_brush = 1
    if (pending_menu_state == 1 && u ~ /^SUBQ\.B/ && (u ~ /#8/ || u ~ /#\$8/)) {
        has_menu_state_8 = 1
        pending_menu_state = 0
    } else if (pending_menu_state == 1 && u ~ /^SUBQ\.B/ && (u ~ /#7/ || u ~ /#\$7/)) {
        has_menu_state_7 = 1
        pending_menu_state = 0
    } else if (pending_menu_state == 1 && u !~ /^MOVE\.B ED_MENUSTATEID/ && n !~ /^MOVEBEDMENUSTATEID/) {
        pending_menu_state = 0
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
    print "HAS_BRUSH_CMP_1=" has_brush_cmp_1
    print "HAS_BRUSH_CMP_2=" has_brush_cmp_2
    print "HAS_BRUSH_CMP_3=" has_brush_cmp_3
    print "HAS_OVERLAY_CODE_3=" has_overlay_code_3
    print "HAS_OVERLAY_CODE_4=" has_overlay_code_4
    print "HAS_OVERLAY_CODE_5=" has_overlay_code_5
    print "ATTENTION_CALL_COUNT=" attention_call_count
    print "HAS_WEATHER_COUNTDOWN=" has_weather_countdown
    print "HAS_BANNER_TICK_COUNTER=" has_banner_tick_counter
    print "HAS_BANNER_TICK_RESET=" has_banner_tick_reset
    print "HAS_DAY_ENTRY_DECREMENT=" has_day_entry_decrement
    print "STATUS_BANNER_CALL_COUNT=" status_banner_call_count
    print "HAS_CLAMP_GATE_TOGGLE=" has_clamp_gate_toggle
    print "HAS_RESET_PENDING=" has_reset_pending
    print "NORMALIZE_CALL_COUNT=" normalize_call_count
    print "HAS_TYPE2_DIVIDE=" has_type2_divide
    print "HAS_TYPE2_CLEAR_BRUSH=" has_type2_clear_brush
    print "HAS_DEFERRED_DELAY_CLEAR=" has_deferred_delay_clear
    print "HAS_FREE_EXTRA_TITLES=" has_free_extra_titles
    print "HAS_SET_APEN=" has_set_apen
    print "HAS_TICK_CMP_2=" has_tick_cmp_2
    print "HAS_TICK_CMP_3=" has_tick_cmp_3
    print "HAS_TICK_CMP_4=" has_tick_cmp_4
    print "HAS_TICK_CMP_5=" has_tick_cmp_5
    print "HAS_MENU_STATE_8=" has_menu_state_8
    print "HAS_MENU_STATE_7=" has_menu_state_7
    print "HAS_FIRST_TICK_STORE=" has_first_tick_store
    print "HAS_SECOND_TICK_STORE=" has_second_tick_store
    print "STATUS_BANNER_ARG0_COUNT=" status_banner_arg0_count
    print "STATUS_BANNER_ARG1_COUNT=" status_banner_arg1_count
}
