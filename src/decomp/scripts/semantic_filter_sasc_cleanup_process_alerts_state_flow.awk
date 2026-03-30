BEGIN {
    has_entry = 0

    gate_stage = 0
    diag_stage = 0
    filter_stage = 0
    tick_stage = 0
    has_defer_gate = 0
    has_clear_ctrl_line = 0
    has_ctrl_timeout = 0
    brush_stage = 0
    banner_stage = 0
    has_type235_clamp_toggle = 0
    has_type235_rtc_refresh = 0
    has_type235_reset_pending = 0
    has_type4_rotate = 0
    has_draw_banners = 0
    has_type2_remainder_clear = 0
    has_menu_draw_esc = 0
    has_menu_draw_mem = 0
    has_finish_clear = 0

    normalize_count = 0
    tick_call_count = 0

    pending_d0 = ""
    pending_d1 = ""
    saw_div_call = 0
    has_return = 0
    saw_clamp_clear = 0
    saw_clamp_restore = 0
    saw_reset_pending_write = 0
    saw_type4_range_start = 0
    saw_type4_range_end = 0
    saw_setapen = 0
    saw_draw_grid = 0
    saw_draw_clock = 0
    saw_free_extra_titles = 0
    saw_update_ctrl = 0
    type2_div_line = 0
    type2_clear_line = 0
    type2_free_line = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^CLEANUP_PROCESSALERTS[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /TSTWCLEANUPPENDINGALERTFLAG/ || n ~ /MOVEWCLEANUPPENDINGALERTFLAGA4D0/) {
        gate_stage = advance_stage(gate_stage, 1)
    }
    if (gate_stage >= 1 && n ~ /TSTLCLEANUPALERTPROCESSINGFLAG/) {
        gate_stage = advance_stage(gate_stage, 2)
    }
    if (n ~ /^MOVEQL1D0$/ || n ~ /^MOVEQ1D0$/) {
        pending_d0 = "ONE"
    } else if (n ~ /^MOVEQL2D0$/ || n ~ /^MOVEQ2D0$/) {
        pending_d0 = "TWO"
    } else if (n ~ /^MOVEQL3D0$/ || n ~ /^MOVEQ3D0$/) {
        pending_d0 = "THREE"
    } else if (n ~ /^MOVEQL4D0$/ || n ~ /^MOVEQ4D0$/) {
        pending_d0 = "FOUR"
    } else if (n ~ /^MOVEQL5D0$/ || n ~ /^MOVEQ5D0$/) {
        pending_d0 = "FIVE"
    }
    if (n ~ /^MOVEQL0D1$/ || n ~ /^MOVEQ0D1$/) {
        pending_d1 = "ZERO"
    } else if (n ~ /^MOVEQL11D1$/ || n ~ /^MOVEQ11D1$/ || n ~ /^MOVEQLBD1$/ || n ~ /^MOVEQBD1$/) {
        pending_d1 = "ELEVEN"
    } else if (n ~ /^MOVEQL89D1$/ || n ~ /^MOVEQ89D1$/ || n ~ /^MOVEQL59D1$/ || n ~ /^MOVEQ59D1$/) {
        pending_d1 = "YCHAR"
    } else if (n ~ /^MOVEQL60D0$/ || n ~ /^MOVEQ60D0$/ || n ~ /^MOVEQL3CD0$/ || n ~ /^MOVEQ3CD0$/) {
        pending_d0 = "SIXTY"
    }

    if (gate_stage >= 2 && n ~ /MOVELD0CLEANUPALERTPROCESSINGFLAG/) {
        gate_stage = advance_stage(gate_stage, 3)
    }

    if (n ~ /SUBQL1CLEANUPALERTCOOLDOWNTICKS/) {
        diag_stage = advance_stage(diag_stage, 1)
    }
    if (diag_stage >= 1 &&
        (n ~ /ESQFUNCDRAWDIAGNOSTICSSCREEN/ || n ~ /GROUPACJMPTBLESQFUNCDRAWDIAG/)) {
        diag_stage = advance_stage(diag_stage, 2)
    }
    if (diag_stage >= 2 && n ~ /MOVELD0CLEANUPALERTCOOLDOWNTICKS/) {
        diag_stage = advance_stage(diag_stage, 3)
    }

    if (pending_d0 == "TWO" && (n ~ /CMPLLOCAVAILFILTERSTEPD0/ || n ~ /CMPLLOCAVAILFILTERSTEPA4D0/)) {
        filter_stage = advance_stage(filter_stage, 1)
    }
    if (filter_stage >= 1 &&
        (n ~ /MOVEWLOCAVAILFILTERCOOLDOWNTICKSD0/ || n ~ /MOVEWLOCAVAILFILTERCOOLDOWNTICKSA4D0/)) {
        filter_stage = advance_stage(filter_stage, 2)
    }
    if (filter_stage >= 2 &&
        (n ~ /ADDIW10D1/ || n ~ /ADDWA0D1/ || n ~ /ADDWAD1/ || n ~ /ADDW10D1/)) {
        filter_stage = advance_stage(filter_stage, 3)
    }
    if (filter_stage >= 3 && n ~ /MOVEWD1LOCAVAILFILTERCOOLDOWNTICKS/) {
        filter_stage = advance_stage(filter_stage, 4)
    }
    if (filter_stage >= 4 && pending_d0 == "THREE" && n ~ /MOVELD0LOCAVAILFILTERSTEP/) {
        filter_stage = advance_stage(filter_stage, 5)
    }
    if (filter_stage >= 5 && pending_d0 == "THREE" &&
        (n ~ /CMPLLOCAVAILFILTERSTEPD0/ || n ~ /CMPLLOCAVAILFILTERSTEPA4D0/)) {
        filter_stage = advance_stage(filter_stage, 6)
    }
    if (filter_stage >= 6 && pending_d0 == "FOUR" && n ~ /MOVELD0LOCAVAILFILTERSTEP/) {
        filter_stage = advance_stage(filter_stage, 7)
    }
    if (filter_stage >= 7 &&
        (n ~ /TEXTDISPRESETSELECTIONANDREFRESH/ ||
         n ~ /TEXTDISPRESETSELECTIONANDREFRES/ ||
         n ~ /GROUPAGJMPTBLTEXTDISPRESETSELECTIONANDREFRESH/)) {
        filter_stage = advance_stage(filter_stage, 8)
    }

    if (n ~ /CLRWCLEANUPPENDINGALERTFLAG/) {
        tick_stage = advance_stage(tick_stage, 1)
    }
    if ((n ~ /ESQTICKCLOCKANDFLAGEVENTS/ || n ~ /TICKCLOCKANDFLAGEVENTS/) && tick_call_count == 0) {
        tick_call_count = 1
        tick_stage = advance_stage(tick_stage, 2)
    } else if ((n ~ /ESQTICKCLOCKANDFLAGEVENTS/ || n ~ /TICKCLOCKANDFLAGEVENTS/) && tick_call_count == 1) {
        tick_call_count = 2
        tick_stage = advance_stage(tick_stage, 4)
    }
    if (tick_call_count == 1 && (n ~ /MOVELD0D7/ || n ~ /MOVELD0D7W/ || n ~ /EXTLD7/)) {
        tick_stage = advance_stage(tick_stage, 3)
    }
    if (tick_call_count == 2 && n ~ /ADDQW8A7/) {
        tick_stage = advance_stage(tick_stage, 5)
    }

    if (n ~ /MOVEWTEXTDISPDEFERREDACTIONDELAYTICKSD0/ ||
        n ~ /MOVEWTEXTDISPDEFERREDACTIONDELAYTICKSA4D0/ ||
        n ~ /MOVEWTEXTDISPDEFERREDACTIONDELAYTICKA4D0/) {
        has_defer_gate = 1
    }
    if (has_defer_gate &&
        (n ~ /SCRIPTCLEARCTRLLINEIFENABLED/ || n ~ /GROUPACJMPTBLSCRIPTCLEARCTRL/)) {
        has_clear_ctrl_line = 1
    }
    if (has_defer_gate &&
        (n ~ /SCRIPTPOLLHANDSHAKEANDAPPLYTIME/ || n ~ /GROUPACJMPTBLSCRIPTUPDATECTRL/)) {
        has_ctrl_timeout = 1
    }

    if (brush_stage == 0 && pending_d0 == "ONE" &&
        (n ~ /CMPLBRUSHPENDINGALERTCODED0/ || n ~ /CMPLBRUSHPENDINGALERTCODEA4D0/)) {
        brush_stage = 1
    } else if (brush_stage == 1 && n ~ /PEA3W/) {
        brush_stage = 2
    } else if (brush_stage == 2 && (n ~ /ESQIFF2SHOWATTENTIONOVERLAY/ || n ~ /GROUPAHJMPTBLESQIFF2SHOWATTE/)) {
        brush_stage = 3
    } else if (brush_stage == 3 && pending_d0 == "FOUR" && n ~ /MOVELD0BRUSHPENDINGALERTCODE/) {
        brush_stage = 4
    } else if (brush_stage == 4 && pending_d0 == "TWO" &&
               (n ~ /CMPLBRUSHPENDINGALERTCODED0/ || n ~ /CMPLBRUSHPENDINGALERTCODEA4D0/)) {
        brush_stage = 5
    } else if (brush_stage == 5 && n ~ /PEA4W/) {
        brush_stage = 6
    } else if (brush_stage == 6 && (n ~ /ESQIFF2SHOWATTENTIONOVERLAY/ || n ~ /GROUPAHJMPTBLESQIFF2SHOWATTE/)) {
        brush_stage = 7
    } else if (brush_stage == 7 && pending_d0 == "FOUR" && n ~ /MOVELD0BRUSHPENDINGALERTCODE/) {
        brush_stage = 8
    } else if (brush_stage == 8 && pending_d0 == "THREE" &&
               (n ~ /CMPLBRUSHPENDINGALERTCODED0/ || n ~ /CMPLBRUSHPENDINGALERTCODEA4D0/)) {
        brush_stage = 9
    } else if (brush_stage == 9 && n ~ /PEA5W/) {
        brush_stage = 10
    } else if (brush_stage == 10 && (n ~ /ESQIFF2SHOWATTENTIONOVERLAY/ || n ~ /GROUPAHJMPTBLESQIFF2SHOWATTE/)) {
        brush_stage = 11
    } else if (brush_stage == 11 && pending_d0 == "FOUR" && n ~ /MOVELD0BRUSHPENDINGALERTCODE/) {
        brush_stage = 12
    }

    if (n ~ /TSTLD7/) {
        banner_stage = advance_stage(banner_stage, 1)
    }
    if (banner_stage >= 1 &&
        (n ~ /SUBQB1D0/ || n ~ /MOVEBD0WDISPWEATHERSTATUSCOUNTDOWN/ ||
         n ~ /SUBQB1WDISPWEATHERSTATUSCOUNTDOWN/)) {
        banner_stage = advance_stage(banner_stage, 2)
    }
    if (banner_stage >= 1 && n ~ /SUBQL1CLEANUPBANNERTICKCOUNTER/) {
        banner_stage = advance_stage(banner_stage, 3)
    }
    if (banner_stage >= 3 && pending_d0 == "SIXTY" && n ~ /MOVELD0CLEANUPBANNERTICKCOUNTER/) {
        banner_stage = advance_stage(banner_stage, 4)
    }
    if (banner_stage >= 4 &&
        (n ~ /SUBQB1D0/ || n ~ /MOVEBD0TLIBA1DAYENTRYMODECOUNTER/ ||
         n ~ /SUBQB1TLIBA1DAYENTRYMODECOUNTER/)) {
        banner_stage = advance_stage(banner_stage, 5)
    }
    if (banner_stage >= 3 &&
        (n ~ /DSTUPDATEBANNERQUEUE/ || n ~ /GROUPACJMPTBLDSTUPDATEBANNER/)) {
        banner_stage = advance_stage(banner_stage, 6)
    }
    if ((n ~ /ESQDISPDRAWSTATUSBANNER/ || n ~ /GROUPACJMPTBLESQDISPDRAWSTAT/) && banner_stage >= 6) {
        banner_stage = advance_stage(banner_stage, 7)
    }

    if (n ~ /CLRWESQDISPSTATUSBANNERCLAMPGATEFLAG/ || n ~ /CLRWESQDISPSTATUSBANNERCLAMPGATEFLA/) {
        saw_clamp_clear = 1
    }
    if (saw_clamp_clear &&
        (n ~ /MOVEW1ESQDISPSTATUSBANNERCLAMPGATEFLAG/ || n ~ /MOVEW1ESQDISPSTATUSBANNERCLAMPGATEFLA/)) {
        saw_clamp_restore = 1
        has_type235_clamp_toggle = 1
    }

    if (n ~ /PARSEINIUPDATECLOCKFROMRTC/ || n ~ /GROUPACJMPTBLPARSEINIUPDATEC/) {
        has_type235_rtc_refresh = 1
    }
    if (has_type235_rtc_refresh &&
        (n ~ /DSTREFRESHBANNERBUFFER/ || n ~ /GROUPACJMPTBLDSTREFRESHBANNE/)) {
        has_type235_rtc_refresh = 1
    }

    if (n ~ /MOVEW1BANNERRESETPENDINGFLAG/ || n ~ /MOVEWD0BANNERRESETPENDINGFLAG/) {
        saw_reset_pending_write = 1
    }
    if ((n ~ /DISPLIBNORMALIZEVALUEBYSTEP/) && saw_reset_pending_write) {
        normalize_count++
        if (normalize_count >= 2) {
            has_type235_reset_pending = 1
        }
    }

    if (n ~ /MOVEWWDISPBANNERCHARRANGESTARTD0/ || n ~ /MOVEWD0WDISPBANNERCHARRANGESTART/) {
        saw_type4_range_start = 1
    }
    if (n ~ /MOVEWWDISPBANNERCHARRANGEENDD0/ || n ~ /MOVEWD0WDISPBANNERCHARRANGEEND/) {
        saw_type4_range_end = 1
    }
    if (saw_type4_range_start && saw_type4_range_end) {
        has_type4_rotate = 1
    }

    if (n ~ /LVOSETAPEN/) {
        saw_setapen = 1
    }
    if (n ~ /CLEANUPDRAWGRIDTIMEBANNER/) {
        saw_draw_grid = 1
    }
    if (n ~ /CLEANUPDRAWCLOCKBANNER/) {
        saw_draw_clock = 1
    }
    if (saw_setapen && saw_draw_grid && saw_draw_clock) {
        has_draw_banners = 1
    }

    if (n ~ /MATHDIVS32/ || n ~ /GROUPAGJMPTBLMATHDIVS32/) {
        saw_div_call = 1
        if (type2_div_line == 0) {
            type2_div_line = NR
        }
    }
    if (n ~ /ESQFUNCFREEEXTRATITLETEXTPOINT/ || n ~ /GROUPACJMPTBLESQFUNCFREEEXTRATITLET/) {
        saw_free_extra_titles = 1
        if (type2_free_line == 0) {
            type2_free_line = NR
        }
    }
    if ((n ~ /CLRLBRUSHPENDINGALERTCODE/ || n ~ /CLRLBRUSHPENDINGALERTCODEA4/) &&
        type2_clear_line == 0) {
        type2_clear_line = NR
    }

    if (n ~ /SCRIPTUPDATECTRLSTATEMACHINE/ || n ~ /GROUPACJMPTBLSCRIPTUPDATECTR/) {
        saw_update_ctrl = 1
    }
    if (saw_update_ctrl &&
        (n ~ /ESQFUNCDRAWESCMENUVERSION/ || n ~ /GROUPACJMPTBLESQFUNCDRAWESCMENUVER/)) {
        has_menu_draw_esc = 1
    }
    if (saw_update_ctrl &&
        (n ~ /ESQFUNCDRAWMEMORYSTATUSSCREEN/ || n ~ /GROUPACJMPTBLESQFUNCDRAWMEMORYSTAT/)) {
        has_menu_draw_mem = 1
    }
    if (n ~ /CLRLCLEANUPALERTPROCESSINGFLAG/) {
        has_finish_clear = 1
    }

    if (u == "RTS") {
        has_return = 1
    }
}

END {
    if (type2_div_line > 0 && type2_clear_line > type2_div_line && type2_free_line > type2_clear_line) {
        has_type2_remainder_clear = 1
    }
    print "HAS_ENTRY=" has_entry
    print "GATE_STAGE=" gate_stage
    print "DIAG_STAGE=" diag_stage
    print "FILTER_STAGE=" filter_stage
    print "TICK_STAGE=" tick_stage
    print "HAS_DEFER_GATE=" has_defer_gate
    print "HAS_CLEAR_CTRL_LINE=" has_clear_ctrl_line
    print "HAS_CTRL_TIMEOUT=" has_ctrl_timeout
    print "BRUSH_STAGE=" brush_stage
    print "BANNER_STAGE=" banner_stage
    print "HAS_TYPE235_CLAMP_TOGGLE=" has_type235_clamp_toggle
    print "HAS_TYPE235_RTC_REFRESH=" has_type235_rtc_refresh
    print "HAS_TYPE235_RESET_PENDING=" has_type235_reset_pending
    print "HAS_TYPE4_ROTATE=" has_type4_rotate
    print "HAS_DRAW_BANNERS=" has_draw_banners
    print "HAS_TYPE2_REMAINDER_CLEAR=" has_type2_remainder_clear
    print "HAS_MENU_DRAW_ESC=" has_menu_draw_esc
    print "HAS_MENU_DRAW_MEM=" has_menu_draw_mem
    print "HAS_FINISH_CLEAR=" has_finish_clear
    print "HAS_RETURN=" has_return
}
