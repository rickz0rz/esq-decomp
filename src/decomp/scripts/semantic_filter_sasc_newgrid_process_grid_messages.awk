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
    has_dispatch_1 = 0
    has_dispatch_2 = 0
    has_dispatch_3 = 0
    has_dispatch_4 = 0
    has_dispatch_5 = 0
    has_dispatch_6 = 0
    has_dispatch_7 = 0
    header_redraw_set_count = 0
    has_header_redraw_clear = 0
    has_stateword_compare = 0
    has_stateword_loop_branch = 0
    has_update_cache = 0
    has_putmsg = 0
    has_top_bars = 0
    has_top_border = 0
    has_rts = 0
    prev = ""
    pending_dispatch_id = ""
    stateword_base_loaded = 0
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
    if (l ~ /(JSR|BSR).*NEWGRID_DRAWAWAITINGLISTINGSMESS/) has_awaiting = 1
    if (l ~ /PEA[ \t]+(\(\$?1\)|1)\.W/) pending_dispatch_id = "1"
    else if (l ~ /PEA[ \t]+(\(\$?2\)|2)\.W/) pending_dispatch_id = "2"
    else if (l ~ /PEA[ \t]+(\(\$?3\)|3)\.W/) pending_dispatch_id = "3"
    else if (l ~ /PEA[ \t]+(\(\$?4\)|4)\.W/) pending_dispatch_id = "4"
    else if (l ~ /PEA[ \t]+(\(\$?5\)|5)\.W/) pending_dispatch_id = "5"
    else if (l ~ /PEA[ \t]+(\(\$?6\)|6)\.W/) pending_dispatch_id = "6"
    else if (l ~ /PEA[ \t]+(\(\$?7\)|7)\.W/) pending_dispatch_id = "7"
    if (l ~ /NEWGRID2_DISPATCHGRIDOPERATION/) {
        if (pending_dispatch_id == "1") has_dispatch_1 = 1
        else if (pending_dispatch_id == "2") has_dispatch_2 = 1
        else if (pending_dispatch_id == "3") has_dispatch_3 = 1
        else if (pending_dispatch_id == "4") has_dispatch_4 = 1
        else if (pending_dispatch_id == "5") has_dispatch_5 = 1
        else if (pending_dispatch_id == "6") has_dispatch_6 = 1
        else if (pending_dispatch_id == "7") has_dispatch_7 = 1
        pending_dispatch_id = ""
    }
    if (l ~ /MOVE\.W[ \t]+#\$?1,[ \t]*NEWGRID_HEADERREDRAWPENDING/) header_redraw_set_count++
    if (l ~ /CLR\.W[ \t]+NEWGRID_HEADERREDRAWPENDING/) has_header_redraw_clear = 1
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
    print "HAS_CLOCK_SLOT=" has_clock_slot
    print "HAS_CLOCK_SLOT_OFFSET=" has_clock_slot_offset
    print "HAS_HEADER=" has_header
    print "HAS_DATE_BANNER=" has_date_banner
    print "HAS_AWAITING=" has_awaiting
    print "HAS_DISPATCH_1_TO_7=" (has_dispatch_1 && has_dispatch_2 && has_dispatch_3 && has_dispatch_4 && has_dispatch_5 && has_dispatch_6 && has_dispatch_7 ? 1 : 0)
    print "HAS_HEADER_REDRAW_SET_CLUSTER=" (header_redraw_set_count >= 5 ? 1 : 0)
    print "HAS_HEADER_REDRAW_CLEAR=" has_header_redraw_clear
    print "HAS_STATEWORD_REPLY_LOOP=" (has_stateword_compare && has_stateword_loop_branch ? 1 : 0)
    print "HAS_UPDATE_CACHE=" has_update_cache
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_TOP_BARS=" has_top_bars
    print "HAS_TOP_BORDER=" has_top_border
    print "HAS_RTS=" has_rts
}
