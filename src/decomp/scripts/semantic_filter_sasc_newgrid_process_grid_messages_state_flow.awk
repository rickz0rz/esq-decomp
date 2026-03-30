BEGIN {
    has_entry = 0
    has_init_cluster = 0
    has_getmsg = 0
    has_stateword_clear = 0
    has_validate_zero_arg = 0
    has_param_clear = 0
    has_switch = 0
    has_mode0_preview = 0
    has_mode1_slot_header = 0
    has_mode2_date_banner = 0
    has_mode3_dispatch1 = 0
    has_mode4_dispatch5 = 0
    has_mode5_dispatch2 = 0
    has_mode6_dispatch3 = 0
    has_mode7_dispatch4 = 0
    has_mode8_offset_dispatch6 = 0
    has_mode9_dispatch7 = 0
    has_mode10_awaiting = 0
    has_mode11_header_redraw = 0
    has_header_redraw_on_dispatch_fail = 0
    has_reply_loop = 0
    has_update_cache = 0
    has_putmsg = 0
    has_top_bars = 0
    has_top_border = 0
    has_rts = 0
    jumptable_index = 0
    current_case_index = -1
    pending_dispatch_id = ""
    prev = ""
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^NEWGRID_PROCESSGRIDMESSAGES:/ || l ~ /^NEWGRID_PROCESSGRIDMESSAG[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /NEWGRID_INITGRIDRESOURCES/) seen_init = 1
    if (l ~ /NEWGRID_CLEARHIGHLIGHTAREA/) seen_clear = 1
    if (l ~ /CLEANUP_DRAWCLOCKBANNER/) seen_banner = 1
    if (l ~ /CLEANUP_DRAWCLOCKFORMATLIST/) seen_list = 1
    if (l ~ /CLEANUP_DRAWCLOCKFORMATFRAME/) seen_frame = 1
    if (seen_init && seen_clear && seen_banner && seen_list && seen_frame) has_init_cluster = 1

    if (l ~ /(_LVOGETMSG|BSR\.W _LVOGETMSG|JSR _LVOGETMSG)/) has_getmsg = 1
    if (l ~ /(LEA \$34\(A[05]\),A0|CLR\.W 52\(A0\)|CLR\.W \(A0\))/) has_stateword_clear = 1
    if (l ~ /CLR\.L -\(A7\)/ && prev ~ /CLR\.W (52\(A0\)|\(A0\))/) has_validate_zero_arg = 1
    if (l ~ /(LEA \$20\(A[05]\),A0|CLR\.L 32\(A0\)|CLR\.L \(A0\))/) has_param_clear = 1

    if (l ~ /(MOVE\.W \$6\(PC,D0\.W\),D0|MOVE\.W \.MODE_JUMPTABLE\(PC,D0\.W\),D0)/) has_switch = 1
    if (l ~ /^DC\.W / && jumptable_index < 12) {
        target = l
        sub(/^DC\.W /, "", target)
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

    if (current_case_index == 0 && l ~ /WDISP_UPDATESELECTIONPREVIEWPANE/) {
        has_mode0_preview = 1
    }

    if (current_case_index == 1 && l ~ /NEWGRID_COMPUTEDAYSLOTFROMCLOCK/) {
        seen_mode1_compute = 1
    }
    if (current_case_index == 1 && l ~ /NEWGRID_ADJUSTCLOCKSTRINGBYSLOT/ &&
        l !~ /WITHOFFSET/) {
        seen_mode1_adjust = 1
    }
    if (current_case_index == 1 && l ~ /NEWGRID_DRAWCLOCKFORMATHEADER/) {
        seen_mode1_header = 1
    }
    if (seen_mode1_compute && seen_mode1_adjust && seen_mode1_header) {
        has_mode1_slot_header = 1
    }

    if (current_case_index == 2 && l ~ /NEWGRID_DRAWDATEBANNER/) {
        has_mode2_date_banner = 1
    }

    if (current_case_index == 8 && l ~ /NEWGRID_COMPUTEDAYSLOTFROMCLOCKW/) {
        seen_mode8_compute = 1
    }
    if (current_case_index == 8 && l ~ /NEWGRID_ADJUSTCLOCKSTRINGBYSLOTW/) {
        seen_mode8_adjust = 1
    }

    if (l ~ /PEA (\(\$1\)\.W|1\.W)/) pending_dispatch_id = "1"
    else if (l ~ /PEA (\(\$2\)\.W|2\.W)/) pending_dispatch_id = "2"
    else if (l ~ /PEA (\(\$3\)\.W|3\.W)/) pending_dispatch_id = "3"
    else if (l ~ /PEA (\(\$4\)\.W|4\.W)/) pending_dispatch_id = "4"
    else if (l ~ /PEA (\(\$5\)\.W|5\.W)/) pending_dispatch_id = "5"
    else if (l ~ /PEA (\(\$6\)\.W|6\.W)/) pending_dispatch_id = "6"
    else if (l ~ /PEA (\(\$7\)\.W|7\.W)/) pending_dispatch_id = "7"
    if (l ~ /NEWGRID2_DISPATCHGRIDOPERATION/) {
        if (current_case_index == 3 && pending_dispatch_id == "1") has_mode3_dispatch1 = 1
        if (current_case_index == 4 && pending_dispatch_id == "5") has_mode4_dispatch5 = 1
        if (current_case_index == 5 && pending_dispatch_id == "2") has_mode5_dispatch2 = 1
        if (current_case_index == 6 && pending_dispatch_id == "3") has_mode6_dispatch3 = 1
        if (current_case_index == 7 && pending_dispatch_id == "4") has_mode7_dispatch4 = 1
        if (current_case_index == 8 && pending_dispatch_id == "6" &&
            seen_mode8_compute && seen_mode8_adjust) {
            has_mode8_offset_dispatch6 = 1
        }
        if (current_case_index == 9 && pending_dispatch_id == "7") has_mode9_dispatch7 = 1
        pending_dispatch_id = ""
    } else if (pending_dispatch_id != "" && l !~ /^(PEA|MOVE|EXT|LEA|BSR|JSR)/) {
        pending_dispatch_id = ""
    }

    if (current_case_index >= 5 && current_case_index <= 9 &&
        l ~ /NEWGRID_HEADERREDRAWPENDING/ &&
        prev ~ /TST\.(L|W) D[06]/) {
        has_header_redraw_on_dispatch_fail = 1
    }

    if (l ~ /NEWGRID_DRAWAWAITINGLISTINGSMESS/ && current_case_index == 10) {
        has_mode10_awaiting = 1
    }
    if (l ~ /NEWGRID_HEADERREDRAWPENDING/ && current_case_index == 11) seen_mode11_pending = 1
    if (l ~ /NEWGRID_DRAWCLOCKFORMATHEADER/ && current_case_index == 11) seen_mode11_header = 1
    if (seen_mode11_pending && seen_mode11_header) has_mode11_header_redraw = 1

    if (l ~ /BLS(\.W|\.) .*DISPATCH_MAIN_MODE/ || l ~ /BLS\.W ___NEWGRID_PROCESSGRIDMESSAGES__13/) has_reply_loop = 1
    if (l ~ /GCOMMAND_UPDATEPRESETENTRYCACHE/) has_update_cache = 1
    if (l ~ /(_LVOPUTMSG|BSR\.W _LVOPUTMSG|JSR _LVOPUTMSG)/) has_putmsg = 1
    if (l ~ /NEWGRID_DRAWGRIDTOPBARS/) has_top_bars = 1
    if (l ~ /NEWGRID_DRAWTOPBORDERLINE/) has_top_border = 1
    if (l == "RTS") has_rts = 1

    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INIT_CLUSTER=" has_init_cluster
    print "HAS_GETMSG=" has_getmsg
    print "HAS_STATEWORD_CLEAR=" has_stateword_clear
    print "HAS_VALIDATE_ZERO_ARG=" has_validate_zero_arg
    print "HAS_PARAM_CLEAR=" has_param_clear
    print "HAS_SWITCH=" has_switch
    print "HAS_MODE0_PREVIEW=" has_mode0_preview
    print "HAS_MODE1_SLOT_HEADER=" has_mode1_slot_header
    print "HAS_MODE2_DATE_BANNER=" has_mode2_date_banner
    print "HAS_MODE3_DISPATCH1=" has_mode3_dispatch1
    print "HAS_MODE4_DISPATCH5=" has_mode4_dispatch5
    print "HAS_MODE5_DISPATCH2=" has_mode5_dispatch2
    print "HAS_MODE6_DISPATCH3=" has_mode6_dispatch3
    print "HAS_MODE7_DISPATCH4=" has_mode7_dispatch4
    print "HAS_MODE8_OFFSET_DISPATCH6=" has_mode8_offset_dispatch6
    print "HAS_MODE9_DISPATCH7=" has_mode9_dispatch7
    print "HAS_MODE10_AWAITING=" has_mode10_awaiting
    print "HAS_MODE11_HEADER_REDRAW=" has_mode11_header_redraw
    print "HAS_HEADER_REDRAW_ON_DISPATCH_FAIL=" has_header_redraw_on_dispatch_fail
    print "HAS_REPLY_LOOP=" has_reply_loop
    print "HAS_UPDATE_CACHE=" has_update_cache
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_TOP_BARS=" has_top_bars
    print "HAS_TOP_BORDER=" has_top_border
    print "HAS_RTS=" has_rts
}
