BEGIN {
    has_entry=0
    has_draw_grid_frame=0
    has_is_last=0
    has_is_last_selected=0
    has_render_line=0
    has_bevel_top=0
    has_vertical_pair=0
    has_row_height=0
    has_col_start=0
    has_control_marker=0
    has_const42=0
    has_const35=0
    has_const36=0
    has_const695=0
    has_const2=0
    has_const7=0
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

    if (u ~ /^NEWGRID_DRAWGRIDHEADERROWS:/ || u ~ /^NEWGRID_DRAWGRIDHEADERROWS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_draw_grid_frame=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/ || n ~ /DISPTEXTISCURRENTLINELAST/ || n ~ /DISPTEXTISCURRENTLINE/) has_is_last=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/ || n ~ /DISPTEXTISLASTLINESELECTED/ || n ~ /DISPTEXTISLASTLINE/) has_is_last_selected=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/ || n ~ /DISPTEXTRENDERCURRENTLINE/ || n ~ /DISPTEXTRENDERCURRENT/) has_render_line=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOP/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITH/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWIT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/ || n ~ /BEVELDRAWBEVELFRAMEWITHTOP/ || n ~ /BEVELDRAWBEVELFRAMEWITH/) has_bevel_top=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELPAIR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELP/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTIC/ || n ~ /BEVELDRAWVERTICALBEVELPAIR/ || n ~ /BEVELDRAWVERTICALBEVELP/) has_vertical_pair=1
    if (n ~ /NEWGRIDROWHEIGHTPX/) has_row_height=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/) has_col_start=1
    if (n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) has_control_marker=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) has_const42=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /\(\$23\)/) has_const35=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /\(\$24\)/) has_const36=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/ || u ~ /695\.[Ww]/) has_const695=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /7\.[Ww]/ || u ~ /\(\$7\)/) has_const7=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_GRID_FRAME_CALL="has_draw_grid_frame
    print "HAS_IS_CURRENT_LINE_LAST_CALL="has_is_last
    print "HAS_IS_LAST_LINE_SELECTED_CALL="has_is_last_selected
    print "HAS_RENDER_CURRENT_LINE_CALL="has_render_line
    print "HAS_BEVEL_FRAME_WITH_TOP_CALL="has_bevel_top
    print "HAS_VERTICAL_BEVEL_PAIR_CALL="has_vertical_pair
    print "HAS_ROW_HEIGHT_GLOBAL="has_row_height
    print "HAS_COLUMN_START_GLOBAL="has_col_start
    print "HAS_CONTROL_MARKER_GLOBAL="has_control_marker
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_7="has_const7
    print "HAS_RTS="has_rts
}
