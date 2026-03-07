BEGIN {
    has_entry=0
    has_set_row_color=0
    has_setapen=0
    has_rectfill=0
    has_is_last=0
    has_has_multiple=0
    has_vertical_bevel=0
    has_last_selected=0
    has_render_line=0
    has_horizontal_bevel=0
    has_control_marker=0
    has_const695=0
    has_const42=0
    has_const6=0
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

    if (u ~ /^NEWGRID_DRAWGRIDFRAMEVARIANT4:/ || u ~ /^NEWGRID_DRAWGRIDFRAMEVARIANT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSETROWCOLOR/) has_set_row_color=1
    if (n ~ /LVOSETAPEN/) has_setapen=1
    if (n ~ /LVORECTFILL/) has_rectfill=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/) has_is_last=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLELINES/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLE/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULT/) has_has_multiple=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTIC/) has_vertical_bevel=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/) has_last_selected=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/) has_render_line=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZONTALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZO/) has_horizontal_bevel=1
    if (n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) has_control_marker=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/) has_const695=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) has_const42=1
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/ || u ~ /6\.[Ww]/ || u ~ /\(\$6\)/) has_const6=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SET_ROW_COLOR_CALL="has_set_row_color
    print "HAS_SETAPEN_CALL="has_setapen
    print "HAS_RECTFILL_CALL="has_rectfill
    print "HAS_IS_CURRENT_LINE_LAST_CALL="has_is_last
    print "HAS_HAS_MULTIPLE_LINES_CALL="has_has_multiple
    print "HAS_VERTICAL_BEVEL_CALL="has_vertical_bevel
    print "HAS_IS_LAST_LINE_SELECTED_CALL="has_last_selected
    print "HAS_RENDER_CURRENT_LINE_CALL="has_render_line
    print "HAS_HORIZONTAL_BEVEL_CALL="has_horizontal_bevel
    print "HAS_CONTROL_MARKER_GLOBAL="has_control_marker
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_6="has_const6
    print "HAS_RTS="has_rts
}
