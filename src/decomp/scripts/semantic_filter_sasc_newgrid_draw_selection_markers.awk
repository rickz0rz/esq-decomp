BEGIN {
    has_entry=0
    has_draw_bg=0
    has_set_markers=0
    has_text_length=0
    has_render_line=0
    has_is_last=0
    has_is_last_selected=0
    has_move=0
    has_text=0
    has_horizontal_bevel=0
    has_row_height=0
    has_col_start=0
    has_col_width=0
    has_control_marker=0
    has_placeholder_flag=0
    has_const42=0
    has_const29=0
    has_const36=0
    has_const89=0
    has_const695=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWSELECTIONMARKERS:/ || u ~ /^NEWGRID_DRAWSELECTIONMARKERS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDCELLBACKGROUND/) has_draw_bg=1
    if (n ~ /NEWGRIDSETSELECTIONMARKERS/) has_set_markers=1
    if (n ~ /LVOTEXTLENGTH/) has_text_length=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/) has_render_line=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/) has_is_last=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/) has_is_last_selected=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZONTALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZO/) has_horizontal_bevel=1
    if (n ~ /NEWGRIDROWHEIGHTPX/) has_row_height=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/) has_col_start=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/) has_col_width=1
    if (n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) has_control_marker=1
    if (n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFLAG/ || n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFL/) has_placeholder_flag=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) has_const42=1
    if (u ~ /#29([^0-9]|$)/ || u ~ /#\$1D/ || u ~ /\(\$1D\)/) has_const29=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /\(\$24\)/) has_const36=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /\(\$59\)/) has_const89=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/ || u ~ /695\.[Ww]/) has_const695=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_GRID_CELL_BACKGROUND_CALL="has_draw_bg
    print "HAS_SET_SELECTION_MARKERS_CALL="has_set_markers
    print "HAS_TEXT_LENGTH_CALL="has_text_length
    print "HAS_RENDER_CURRENT_LINE_CALL="has_render_line
    print "HAS_IS_CURRENT_LINE_LAST_CALL="has_is_last
    print "HAS_IS_LAST_LINE_SELECTED_CALL="has_is_last_selected
    print "HAS_MOVE_CALL="has_move
    print "HAS_TEXT_CALL="has_text
    print "HAS_HORIZONTAL_BEVEL_CALL="has_horizontal_bevel
    print "HAS_ROW_HEIGHT_GLOBAL="has_row_height
    print "HAS_COLUMN_START_GLOBAL="has_col_start
    print "HAS_COLUMN_WIDTH_GLOBAL="has_col_width
    print "HAS_CONTROL_MARKER_GLOBAL="has_control_marker
    print "HAS_PLACEHOLDER_FLAG_GLOBAL="has_placeholder_flag
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_29="has_const29
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_695="has_const695
    print "HAS_RTS="has_rts
}
