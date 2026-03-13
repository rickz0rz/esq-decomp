BEGIN {
    has_entry=0
    has_draw_grid_frame=0
    has_has_multiple=0
    has_is_last=0
    has_is_last_sel=0
    has_render_line=0
    has_bevel_top_right=0
    has_beveled_frame=0
    has_bevel_top=0
    has_vertical_pair=0
    has_control_marker=0
    has_const695=0
    has_const42=0
    has_const35=0
    has_const36=0
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

    if (u ~ /^NEWGRID_DRAWGRIDFRAMEALT:/ || u ~ /^NEWGRID_DRAWGRIDFRAMEAL[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_draw_grid_frame=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLELINES/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULT/ || n ~ /DISPTEXTHASMULTIPLELINES/ || n ~ /DISPTEXTHASMULT/) has_has_multiple=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/ || n ~ /DISPTEXTISCURRENTLINELAST/ || n ~ /DISPTEXTISCURRE/) has_is_last=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/ || n ~ /DISPTEXTISLASTLINESELECTED/ || n ~ /DISPTEXTISLASTL/) has_is_last_sel=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/ || n ~ /DISPTEXTRENDERCURRENTLINE/ || n ~ /DISPTEXTRENDERC/) has_render_line=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel_top_right=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDFRAME/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDF/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELE/) has_beveled_frame=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOP/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel_top=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELPAIR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELP/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTIC/) has_vertical_pair=1
    if (n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) has_control_marker=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/ || u ~ /PEA 695\.W/) has_const695=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) has_const42=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /\(\$23\)/) has_const35=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /\(\$24\)/) has_const36=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_GRID_FRAME_CALL="has_draw_grid_frame
    print "HAS_HAS_MULTIPLE_LINES_CALL="has_has_multiple
    print "HAS_IS_CURRENT_LINE_LAST_CALL="has_is_last
    print "HAS_IS_LAST_LINE_SELECTED_CALL="has_is_last_sel
    print "HAS_RENDER_CURRENT_LINE_CALL="has_render_line
    print "HAS_BEVEL_TOP_RIGHT_CALL="has_bevel_top_right
    print "HAS_BEVELED_FRAME_CALL="has_beveled_frame
    print "HAS_BEVEL_TOP_CALL="has_bevel_top
    print "HAS_VERTICAL_PAIR_CALL="has_vertical_pair
    print "HAS_CONTROL_MARKER_GLOBAL="has_control_marker
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_36="has_const36
    print "HAS_RTS="has_rts
}
