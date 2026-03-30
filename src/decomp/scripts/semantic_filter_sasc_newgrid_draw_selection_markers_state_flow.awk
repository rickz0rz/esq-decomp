BEGIN {
    has_entry=0
    has_draw_bg=0
    has_set_markers=0
    has_primary_marker_guard=0
    has_primary_width_store=0
    has_secondary_marker_guard=0
    has_secondary_width_store=0
    has_layout_x_base=0
    has_layout_y_font_fetch=0
    has_render_top=0
    has_last_line_gate=0
    has_selected_gate=0
    has_render_alt=0
    has_render_bottom=0
    has_left_marker_draw=0
    has_right_marker_draw=0
    has_final_last_check=0
    has_rowkind_gate=0
    has_placeholder_gate=0
    has_bevel_call=0
    has_return_last=0
    has_const42=0
    has_const29=0
    has_const36=0
    has_const89=0
    has_const695=0
    has_rts=0

    textlen_calls=0
    move_calls=0
    text_calls=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    u=trim($0)
    if (u=="") next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWSELECTIONMARKERS:/ || u ~ /^NEWGRID_DRAWSELECTIONMARKERS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDCELLBACKGROUND/) has_draw_bg=1
    if (n ~ /NEWGRIDSETSELECTIONMARKERS/) has_set_markers=1

    if ((u ~ /^TST\.B / || u ~ /^MOVE\.B .*D0$/) && !has_primary_width_store) has_primary_marker_guard=1
    if (n ~ /LVOTEXTLENGTH/ && !has_primary_width_store) {
        textlen_calls++
        has_primary_width_store=1
    }
    if (has_primary_width_store && (u ~ /^TST\.B / || u ~ /^MOVE\.B .*D0$/)) has_secondary_marker_guard=1
    if (n ~ /LVOTEXTLENGTH/ && has_primary_width_store) {
        textlen_calls++
        if (textlen_calls >= 2) has_secondary_width_store=1
    }

    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNWIDTHPX/) has_layout_x_base=1
    if (n ~ /NEWGRIDROWHEIGHTPX/ || u ~ /MOVEA\.L 52\(A1\),A0/ || u ~ /MOVE\.L \$34\(A2\),A0/ || u ~ /MOVE\.L \$34\(A0\),A0/ || u ~ /MOVE\.W \$14\(A0\),D2/ || u ~ /MOVE\.W 26\(A0\),D4/) has_layout_y_font_fetch=1

    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/ ) has_render_top=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/) has_last_line_gate=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/) has_selected_gate=1

    if ((u ~ /^MOVE\.L -16\(A5\),D0/ || u ~ /^MOVE\.L \$38\(A7\),-\(A7\)/) && has_selected_gate) has_render_alt=1
    if ((u ~ /^MOVE\.L -20\(A5\),D0/ || u ~ /^MOVE\.L \$34\(A7\),-\(A7\)/) && has_selected_gate) has_render_bottom=1

    if (n ~ /LVOMOVE/) {
        move_calls++
    }
    if (n ~ /LVOTEXT/ && n !~ /TEXTLENGTH/) {
        text_calls++
    }

    if (move_calls >= 2 && text_calls >= 2) has_left_marker_draw=1
    if (move_calls >= 4 && text_calls >= 4) has_right_marker_draw=1

    if ((n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/) && has_left_marker_draw) has_final_last_check=1
    if ((u ~ /^MOVEQ #3,D0/ || u ~ /^MOVEQ\.L #\$3,D0/ || u ~ /^SUBQ\.W #\$3,D0/ || u ~ /^SUBQ\.W #3,D0/ || u ~ /^CMP\.W D0,D6/ || u ~ /^MOVE\.L D6,D0/) && has_final_last_check) has_rowkind_gate=1
    if (n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFLAG/ || n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFL/) has_placeholder_gate=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZONTALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZO/) has_bevel_call=1
    if ((u ~ /^MOVE\.L -32\(A5\),D0/ || u ~ /^MOVE\.L \$28\(A7\),D0/) && (has_final_last_check || has_bevel_call)) has_return_last=1

    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/) has_const42=1
    if (u ~ /#29([^0-9]|$)/ || u ~ /#\$1D/) has_const29=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/) has_const36=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/) has_const89=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /695\.W/ || u ~ /\(\$2B7\)\.W/) has_const695=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_GRID_CELL_BACKGROUND_CALL="has_draw_bg
    print "HAS_SET_SELECTION_MARKERS_CALL="has_set_markers
    print "HAS_PRIMARY_MARKER_GUARD="has_primary_marker_guard
    print "HAS_PRIMARY_WIDTH_STORE="has_primary_width_store
    print "HAS_SECONDARY_MARKER_GUARD="has_secondary_marker_guard
    print "HAS_SECONDARY_WIDTH_STORE="has_secondary_width_store
    print "HAS_LAYOUT_X_BASE="has_layout_x_base
    print "HAS_LAYOUT_Y_FONT_FETCH="has_layout_y_font_fetch
    print "HAS_RENDER_TOP="has_render_top
    print "HAS_LAST_LINE_GATE="has_last_line_gate
    print "HAS_SELECTED_GATE="has_selected_gate
    print "HAS_RENDER_ALT="has_render_alt
    print "HAS_RENDER_BOTTOM="has_render_bottom
    print "HAS_LEFT_MARKER_DRAW="has_left_marker_draw
    print "HAS_RIGHT_MARKER_DRAW="has_right_marker_draw
    print "HAS_FINAL_LAST_CHECK="has_final_last_check
    print "HAS_ROWKIND_GATE="has_rowkind_gate
    print "HAS_PLACEHOLDER_GATE="has_placeholder_gate
    print "HAS_BEVEL_CALL="has_bevel_call
    print "HAS_RETURN_LAST="has_return_last
    print "HAS_TWO_TEXTLEN_CALLS="(textlen_calls >= 2)
    print "HAS_FOUR_MOVE_CALLS="(move_calls >= 4)
    print "HAS_FOUR_TEXT_CALLS="(text_calls >= 4)
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_29="has_const29
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_695="has_const695
    print "HAS_RTS="has_rts
}
