BEGIN {
    has_entry = 0
    has_ui_busy = 0
    has_read_mode_101 = 0
    has_read_mode_clear = 0
    has_refresh_check = 0
    has_init_resources = 0
    has_clear_highlight = 0
    has_draw_banner = 0
    has_draw_list = 0
    has_draw_frame = 0
    has_dispatch_default = 0
    has_getmsg = 0
    has_validate = 0
    has_preview = 0
    has_clock_slot = 0
    has_clock_slot_offset = 0
    has_header = 0
    has_date_banner = 0
    has_awaiting = 0
    has_mode9_dispatch7 = 0
    has_mode10_awaiting = 0
    has_dispatch_1 = 0
    has_dispatch_2 = 0
    has_dispatch_3 = 0
    has_dispatch_4 = 0
    has_dispatch_5 = 0
    has_dispatch_6 = 0
    has_dispatch_7 = 0
    has_mode3_dispatch1 = 0
    has_mode4_dispatch5 = 0
    has_mode5_dispatch2 = 0
    has_mode6_dispatch3 = 0
    has_mode7_dispatch4 = 0
    has_mode8_dispatch6 = 0
    header_redraw_set_count = 0
    has_header_redraw_clear = 0
    has_mode11_header = 0
    has_stateword_compare = 0
    has_stateword_loop_branch = 0
    has_stateword_clear = 0
    has_param_clear = 0
    has_preview_rast_offset = 0
    has_validate_zero_arg = 0
    has_update_cache = 0
    has_putmsg = 0
    has_top_bars = 0
    has_top_border = 0
    has_rts = 0
    map_selection_call_count = 0
    dispatch_grid_call_count = 0
    pending_stateword_ptr = 0
    pending_param_ptr = 0
    prev = ""
    pending_dispatch_id = ""
    stateword_base_loaded = 0
    jumptable_index = 0
    current_case_index = -1
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^NEWGRID_PROCESSGRIDMESSAG[A-Z0-9_]*:/) has_entry = 1
    if (l ~ /GLOBAL_UIBUSYFLAG/) has_ui_busy = 1
    if ((l ~ /ESQPARS2_READMODEFLAGS/ && l ~ /#\$?101/) || (prev ~ /ESQPARS2_READMODEFLAGS/ && l ~ /CMPI\.W[ \t]+#\$?101/)) has_read_mode_101 = 1
    if (l ~ /CLR\.W ESQPARS2_READMODEFLAGS/) has_read_mode_clear = 1
    if (l ~ /NEWGRID_REFRESHSTATEFLAG/) has_refresh_check = 1
    if (l ~ /(JSR|BSR).*NEWGRID_INITGRIDRESOURCE/) has_init_resources = 1
    if (l ~ /(JSR|BSR).*NEWGRID_CLEARHIGHLIGHTAREA/) has_clear_highlight = 1
    if (l ~ /(JSR|BSR).*DRAWCLOCKBANNER/) has_draw_banner = 1
    if (l ~ /(JSR|BSR).*DRAWCLOCKFORMATLIST/) has_draw_list = 1
    if (l ~ /(JSR|BSR).*DRAWCLOCKFORMATFRAME/) has_draw_frame = 1
    if (l ~ /(JSR|BSR).*NEWGRID2_DISPATCHOPERATIONDEFAUL/) has_dispatch_default = 1
    if (l ~ /(JSR|BSR).*_LVOGETMSG/) has_getmsg = 1
    if (l ~ /(JSR|BSR).*NEWGRID_VALIDATESELECTIONCODE/) has_validate = 1
    if (l ~ /(JSR|BSR).*WDISP_UPDATESELECTIONPREVIEWPANE/) has_preview = 1
    if (l ~ /(JSR|BSR).*NEWGRID_COMPUTEDAYSLOTFROMCLOCK([^A-Z]|$)/) has_clock_slot = 1
    if (l ~ /(JSR|BSR).*NEWGRID_COMPUTEDAYSLOTFROMCLOCKW/) has_clock_slot_offset = 1
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWCLOCKFORMATHEADER/) has_header = 1
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWDATEBANNER/) has_date_banner = 1
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWAWAITINGLISTINGSMESS/) {
        has_awaiting = 1
        if (current_case_index == 10) has_mode10_awaiting = 1
    }
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWCLOCKFORMATHEADER/ && current_case_index == 11) has_mode11_header = 1
    if (l ~ /^DC\.W[ \t]+/ && jumptable_index < 12) {
        target = l
        sub(/^DC\.W[ \t]+/, "", target)
        sub(/-.*/, "", target)
        if (target != "") {
            jumptable_target[jumptable_index] = target
            jumptable_index++
        }
    } else if (l ~ /^[_\.A-Z0-9]+:$/) {
        for (i = 0; i < 12; i++) {
            if (jumptable_target[i] != "" && l == jumptable_target[i] ":") {
                current_case_index = i
                break
            }
        }
    }
    if (l ~ /(LEA[ \t]+\$3C\(A[05]\),A0|ADDA?\.W[ \t]+#\$?3C,A0)/) has_preview_rast_offset = 1
    if (l ~ /CLR\.L[ \t]+-\(A7\)/ && prev ~ /CLR\.W[ \t]+(52\(A0\)|\(A0\))/) has_validate_zero_arg = 1
    if (l ~ /PEA[ \t]+(\(\$?1\)|1)\.W/) pending_dispatch_id = "1"
    else if (l ~ /PEA[ \t]+(\(\$?2\)|2)\.W/) pending_dispatch_id = "2"
    else if (l ~ /PEA[ \t]+(\(\$?3\)|3)\.W/) pending_dispatch_id = "3"
    else if (l ~ /PEA[ \t]+(\(\$?4\)|4)\.W/) pending_dispatch_id = "4"
    else if (l ~ /PEA[ \t]+(\(\$?5\)|5)\.W/) pending_dispatch_id = "5"
    else if (l ~ /PEA[ \t]+(\(\$?6\)|6)\.W/) pending_dispatch_id = "6"
    else if (l ~ /PEA[ \t]+(\(\$?7\)|7)\.W/) pending_dispatch_id = "7"
    if (l ~ /NEWGRID2_DISPATCHGRIDOPERATION/) {
        if (pending_dispatch_id == "1") {
            has_dispatch_1 = 1
            if (current_case_index == 3) has_mode3_dispatch1 = 1
        } else if (pending_dispatch_id == "2") {
            has_dispatch_2 = 1
            if (current_case_index == 5) has_mode5_dispatch2 = 1
        } else if (pending_dispatch_id == "3") {
            has_dispatch_3 = 1
            if (current_case_index == 6) has_mode6_dispatch3 = 1
        } else if (pending_dispatch_id == "4") {
            has_dispatch_4 = 1
            if (current_case_index == 7) has_mode7_dispatch4 = 1
        } else if (pending_dispatch_id == "5") {
            has_dispatch_5 = 1
            if (current_case_index == 4) has_mode4_dispatch5 = 1
        } else if (pending_dispatch_id == "6") {
            has_dispatch_6 = 1
            if (current_case_index == 8) has_mode8_dispatch6 = 1
        } else if (pending_dispatch_id == "7") {
            has_dispatch_7 = 1
            if (current_case_index == 9) has_mode9_dispatch7 = 1
        }
        pending_dispatch_id = ""
    }
    if (l ~ /MOVE\.W[ \t]+#\$?1,[ \t]*NEWGRID_HEADERREDRAWPENDING/) header_redraw_set_count++
    if (l ~ /CLR\.W[ \t]+NEWGRID_HEADERREDRAWPENDING/) has_header_redraw_clear = 1
    if (l ~ /(JSR|BSR).*NEWGRID_MAPSELECTIONTOMODE/) map_selection_call_count++
    if (l ~ /(JSR|BSR).*NEWGRID2_DISPATCHGRIDOPERATION/) dispatch_grid_call_count++
    if (pending_stateword_ptr && l ~ /CLR\.W[ \t]+\((A0|A1)\)/) {
        has_stateword_clear = 1
        pending_stateword_ptr = 0
    } else if (l ~ /CLR\.W[ \t]+52\(A0\)/) {
        has_stateword_clear = 1
        pending_stateword_ptr = 0
    } else if (pending_stateword_ptr && l !~ /^(MOVE|LEA|ADDA?)/) {
        pending_stateword_ptr = 0
    }
    if (pending_param_ptr && l ~ /CLR\.L[ \t]+\((A0|A1)\)/) {
        has_param_clear = 1
        pending_param_ptr = 0
    } else if (l ~ /CLR\.L[ \t]+32\(A0\)/) {
        has_param_clear = 1
        pending_param_ptr = 0
    } else if (pending_param_ptr && l !~ /^(MOVE|LEA|ADDA?)/) {
        pending_param_ptr = 0
    }
    if (l ~ /(LEA[ \t]+\$34\(A[05]\),A0|ADDA?\.W[ \t]+#\$?34,A0)/) pending_stateword_ptr = 1
    if (l ~ /(LEA[ \t]+\$20\(A[05]\),A0|ADDA?\.W[ \t]+#\$?20,A0)/) pending_param_ptr = 1
    if (l ~ /(LEA[ \t]+\$34\(A[05]\),A0|MOVEA?\.L[ \t]+.*A0.*\$34)/ || l ~ /ADDA?\.W[ \t]+#\$?34,A0/) stateword_base_loaded = 1
    if (l ~ /CMPI?\.W[ \t]+#\$?0,52\(A0\)/) has_stateword_compare = 1
    if (stateword_base_loaded && l ~ /CMPI?\.W[ \t]+#\$?0,\(A0\)/) has_stateword_compare = 1
    if (has_stateword_compare && l ~ /BLS(\.W|\.S)?/) has_stateword_loop_branch = 1
    if (l ~ /(JSR|BSR).*GCOMMAND_UPDATEPRESETENTRYCACHE/) has_update_cache = 1
    if (l ~ /(JSR|BSR).*_LVOPUTMSG/) has_putmsg = 1
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWGRIDTOPBAR/) has_top_bars = 1
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWTOPBORDERLINE/) has_top_border = 1
    if (l == "RTS") has_rts = 1
    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_UI_BUSY=" has_ui_busy
    print "HAS_READ_MODE_101=" has_read_mode_101
    print "HAS_READ_MODE_CLEAR=" has_read_mode_clear
    print "HAS_REFRESH_CHECK=" has_refresh_check
    print "HAS_INIT_RESOURCES=" has_init_resources
    print "HAS_CLEAR_HIGHLIGHT=" has_clear_highlight
    print "HAS_DRAW_BANNER=" has_draw_banner
    print "HAS_DRAW_LIST=" has_draw_list
    print "HAS_DRAW_FRAME=" has_draw_frame
    print "HAS_DISPATCH_DEFAULT=" has_dispatch_default
    print "HAS_GETMSG=" has_getmsg
    print "HAS_VALIDATE=" has_validate
    print "HAS_PREVIEW=" has_preview
    print "HAS_PREVIEW_RAST_OFFSET=" has_preview_rast_offset
    print "HAS_CLOCK_SLOT=" has_clock_slot
    print "HAS_CLOCK_SLOT_OFFSET=" has_clock_slot_offset
    print "HAS_HEADER=" has_header
    print "HAS_DATE_BANNER=" has_date_banner
    print "HAS_AWAITING=" has_awaiting
    print "HAS_DISPATCH_1_TO_7=" (has_dispatch_1 && has_dispatch_2 && has_dispatch_3 && has_dispatch_4 && has_dispatch_5 && has_dispatch_6 && has_dispatch_7 ? 1 : 0)
    print "HAS_MODE3_DISPATCH1=" has_mode3_dispatch1
    print "HAS_MODE4_DISPATCH5=" has_mode4_dispatch5
    print "HAS_MODE5_DISPATCH2=" has_mode5_dispatch2
    print "HAS_MODE6_DISPATCH3=" has_mode6_dispatch3
    print "HAS_MODE7_DISPATCH4=" has_mode7_dispatch4
    print "HAS_MODE8_DISPATCH6=" has_mode8_dispatch6
    print "HAS_MODE9_DISPATCH7=" has_mode9_dispatch7
    print "HAS_MODE10_AWAITING=" has_mode10_awaiting
    print "HAS_VALIDATE_ZERO_ARG=" has_validate_zero_arg
    print "HAS_STATEWORD_CLEAR=" has_stateword_clear
    print "HAS_PARAM_CLEAR=" has_param_clear
    print "HAS_HEADER_REDRAW_SET_CLUSTER=" (header_redraw_set_count == 5 ? 1 : 0)
    print "HEADER_REDRAW_SET_COUNT=" header_redraw_set_count
    print "HAS_MODE11_HEADER=" has_mode11_header
    print "HAS_HEADER_REDRAW_CLEAR=" has_header_redraw_clear
    print "HAS_MODE11_HEADER_REDRAW=" (has_mode11_header && has_header_redraw_clear ? 1 : 0)
    print "HAS_STATEWORD_REPLY_LOOP=" (has_stateword_compare && has_stateword_loop_branch ? 1 : 0)
    print "HAS_MAP_SELECTION_CALL_COUNT_13=" (map_selection_call_count == 13 ? 1 : 0)
    print "MAP_SELECTION_CALL_COUNT=" map_selection_call_count
    print "HAS_DISPATCH_GRID_CALL_COUNT_7=" (dispatch_grid_call_count == 7 ? 1 : 0)
    print "DISPATCH_GRID_CALL_COUNT=" dispatch_grid_call_count
    print "HAS_UPDATE_CACHE=" has_update_cache
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_TOP_BARS=" has_top_bars
    print "HAS_TOP_BORDER=" has_top_border
    print "HAS_RTS=" has_rts
}
