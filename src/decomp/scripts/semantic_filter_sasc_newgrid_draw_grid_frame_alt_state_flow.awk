BEGIN {
    has_entry = 0
    has_row_limit2 = 0
    has_saved_final_is_last = 0
    has_store_selection = 0
    has_font_height_read = 0
    has_rts = 0

    count_half_round_ops = 0
    count_has_multiple_calls = 0
    count_is_current_line_last_calls = 0
    count_is_last_line_selected_calls = 0
    count_render_calls = 0
    count_control_marker_refs = 0
    count_draw_bevelf_calls = 0
    count_draw_beveled_calls = 0
    count_draw_vertical_calls = 0
    count_const42 = 0
    count_const35 = 0
    count_const36 = 0
    count_const695 = 0

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

    n = l
    gsub(/[^A-Z0-9]/, "", n)

    if (l ~ /^NEWGRID_DRAWGRIDFRAMEALT:/ || l ~ /^NEWGRID_DRAWGRIDFRAMEAL[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /MOVE\.W (26|\$14)\(A0\),D[0-7]/) {
        has_font_height_read = 1
    }
    if (l ~ /ASR\.(L|W) #1,D[0-7]/ || n ~ /ASR1ROUNDTOWARDZERO/) {
        count_half_round_ops++
    }

    if (l ~ /^(JSR|BSR(\.W)?) / && (n ~ /DISPTEXTHASMULTIPLELINES/ || n ~ /DISPTEXTHASMULT/)) {
        count_has_multiple_calls++
    }
    if (l ~ /^(JSR|BSR(\.W)?) / && (n ~ /DISPTEXTISCURRENTLINELAST/ || n ~ /DISPTEXTISCURRE/)) {
        count_is_current_line_last_calls++
    }
    if (l ~ /^(JSR|BSR(\.W)?) / && (n ~ /DISPTEXTISLASTLINESELECTED/ || n ~ /DISPTEXTISLASTL/)) {
        count_is_last_line_selected_calls++
    }
    if (l ~ /^(JSR|BSR(\.W)?) / && (n ~ /DISPTEXTRENDERCURRENTLINE/ || n ~ /DISPTEXTRENDERC/)) {
        count_render_calls++
    }
    if (l !~ /^XREF / && n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) {
        count_control_marker_refs++
    }

    if (l ~ /^(JSR|BSR(\.W)?) / && n ~ /DRAWBEVELF/) {
        count_draw_bevelf_calls++
    }
    if (l ~ /^(JSR|BSR(\.W)?) / && n ~ /DRAWBEVELE/) {
        count_draw_beveled_calls++
    }
    if (l ~ /^(JSR|BSR(\.W)?) / && n ~ /DRAWVERTIC/) {
        count_draw_vertical_calls++
    }

    if (l ~ /^MOVEQ(\.L)? (#2|#\$2),D0$/ || l ~ /^MOVEQ (#2|#\$2),D0$/) {
        row_limit_seed = 1
    }
    if (row_limit_seed && l ~ /^CMP\.L D0,D[67]$/) {
        has_row_limit2 = 1
        row_limit_seed = 0
    } else if (row_limit_seed && l !~ /^(MOVEQ|CMP\.L)/) {
        row_limit_seed = 0
    }

    if (l ~ /^MOVE\.L D0,(-24\(A5\)|\$1C\(A7\))$/) {
        has_saved_final_is_last = 1
    }
    if (l ~ /^MOVE\.W D0,(52\(A3\)|\$34\(A3\))$/) {
        has_store_selection = 1
    }

    if (l ~ /#42([^0-9]|$)|#\$2A([^A-Z0-9]|$)|\(\$2A\)/) {
        count_const42++
    }
    if (l ~ /#35([^0-9]|$)|#\$23([^A-Z0-9]|$)|\(\$23\)/) {
        count_const35++
    }
    if (l ~ /#36([^0-9]|$)|#\$24([^A-Z0-9]|$)|\(\$24\)/) {
        count_const36++
    }
    if (l ~ /#695([^0-9]|$)|#\$2B7([^A-Z0-9]|$)|\(\$2B7\)|PEA 695\.W/) {
        count_const695++
    }

    if (l == "RTS") {
        has_rts = 1
    }

    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROW_LIMIT2=" has_row_limit2
    print "HAS_SAVED_FINAL_IS_LAST=" has_saved_final_is_last
    print "HAS_STORE_SELECTION=" has_store_selection
    print "HAS_FONT_HEIGHT_READ=" has_font_height_read
    print "HAS_RTS=" has_rts
    print "COUNT_HALF_ROUND_OPS=" count_half_round_ops
    print "COUNT_HAS_MULTIPLE_CALLS=" count_has_multiple_calls
    print "COUNT_IS_CURRENT_LINE_LAST_CALLS=" count_is_current_line_last_calls
    print "COUNT_IS_LAST_LINE_SELECTED_CALLS=" count_is_last_line_selected_calls
    print "COUNT_RENDER_CALLS=" count_render_calls
    print "COUNT_CONTROL_MARKER_REFS=" count_control_marker_refs
    print "COUNT_DRAW_BEVELF_CALLS=" count_draw_bevelf_calls
    print "COUNT_DRAW_BEVELED_CALLS=" count_draw_beveled_calls
    print "COUNT_DRAW_VERTICAL_CALLS=" count_draw_vertical_calls
    print "COUNT_CONST42=" count_const42
    print "COUNT_CONST35=" count_const35
    print "COUNT_CONST36=" count_const36
    print "COUNT_CONST695=" count_const695
}
