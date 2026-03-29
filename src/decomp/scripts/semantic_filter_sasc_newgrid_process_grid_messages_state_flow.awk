BEGIN {
    has_entry = 0
    has_init_cluster = 0
    has_getmsg = 0
    has_stateword_clear = 0
    has_validate_zero_arg = 0
    has_param_clear = 0
    has_switch = 0
    has_mode9_dispatch7 = 0
    has_mode10_awaiting = 0
    has_mode11_header_redraw = 0
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

    if (l ~ /PEA (\(\$7\)\.W|7\.W)/) pending_dispatch_id = "7"
    else if (l ~ /PEA (\(\$[0-6]\)\.W|[0-6]\.W)/) pending_dispatch_id = "other"
    if (pending_dispatch_id == "7" && l ~ /(NEWGRID2_DISPATCHGRIDOPERATION)/) {
        if (current_case_index == 9) has_mode9_dispatch7 = 1
        pending_dispatch_id = ""
    } else if (pending_dispatch_id != "" && l !~ /^(PEA|MOVE|EXT|LEA|BSR|JSR)/) {
        pending_dispatch_id = ""
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
    print "HAS_MODE9_DISPATCH7=" has_mode9_dispatch7
    print "HAS_MODE10_AWAITING=" has_mode10_awaiting
    print "HAS_MODE11_HEADER_REDRAW=" has_mode11_header_redraw
    print "HAS_REPLY_LOOP=" has_reply_loop
    print "HAS_UPDATE_CACHE=" has_update_cache
    print "HAS_PUTMSG=" has_putmsg
    print "HAS_TOP_BARS=" has_top_bars
    print "HAS_TOP_BORDER=" has_top_border
    print "HAS_RTS=" has_rts
}
