BEGIN {
    has_entry=0
    draw_grid_frame_calls=0
    has_multiple_calls=0
    is_current_line_last_calls=0
    is_last_line_selected_calls=0
    render_current_line_calls=0
    bevel_top_family_calls=0
    beveled_frame_calls=0
    vertical_pair_calls=0
    control_marker_refs=0
    const695_refs=0
    const42_refs=0
    const35_refs=0
    const36_refs=0
    const2_refs=0
    selection_store=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function is_call(u) {
    return (u ~ /^(JSR|BSR(\.W)?) /)
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWGRIDFRAMEALT:/ || u ~ /^NEWGRID_DRAWGRIDFRAMEAL[A-Z0-9_]*:/) has_entry=1
    if (is_call(u) && u ~ /NEWGRID_DRAWGRIDFRAME([^A-Z0-9_]|$)/) draw_grid_frame_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLELINES/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULT/ || n ~ /DISPTEXTHASMULTIPLELINES/ || n ~ /DISPTEXTHASMULT/)) has_multiple_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/ || n ~ /DISPTEXTISCURRENTLINELAST/ || n ~ /DISPTEXTISCURRE/)) is_current_line_last_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/ || n ~ /DISPTEXTISLASTLINESELECTED/ || n ~ /DISPTEXTISLASTL/)) is_last_line_selected_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/ || n ~ /DISPTEXTRENDERCURRENTLINE/ || n ~ /DISPTEXTRENDERC/)) render_current_line_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOP([^R]|$)/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHT$/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF([^A-Z0-9_]|$)/)) bevel_top_family_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDFRAME/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDF/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELE([^A-Z0-9_]|$)/)) beveled_frame_calls++
    if (is_call(u) && (n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELPAIR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVELP/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTIC/)) vertical_pair_calls++
    if (u ~ /^ADD\.L DISPTEXT_CONTROLMARKERXOFFSETPX/ || u ~ /^ADD\.L DISPTEXTCONTROLMARKERXOFFSETPX/) control_marker_refs++
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/ || u ~ /PEA 695\.W/) const695_refs++
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) const42_refs++
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /\(\$23\)/) const35_refs++
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /\(\$24\)/) const36_refs++
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$2([^A-F0-9]|$)/ || u ~ /\(\$2\)\.W/) const2_refs++
    if (u ~ /MOVE\.W D0,52\(A3\)/ || u ~ /MOVE\.W D0,\$34\(A3\)/) selection_store=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "DRAW_GRID_FRAME_CALLS="draw_grid_frame_calls
    print "HAS_MULTIPLE_LINES_CALLS="has_multiple_calls
    print "IS_CURRENT_LINE_LAST_CALLS="is_current_line_last_calls
    print "IS_LAST_LINE_SELECTED_CALLS="is_last_line_selected_calls
    print "RENDER_CURRENT_LINE_CALLS="render_current_line_calls
    print "BEVEL_TOP_FAMILY_CALLS="bevel_top_family_calls
    print "BEVELED_FRAME_CALLS="beveled_frame_calls
    print "VERTICAL_PAIR_CALLS="vertical_pair_calls
    print "CONTROL_MARKER_REFS="control_marker_refs
    print "CONST_695_REFS="const695_refs
    print "CONST_42_REFS="const42_refs
    print "CONST_35_REFS="const35_refs
    print "CONST_36_REFS="const36_refs
    print "CONST_2_REFS="const2_refs
    print "HAS_SELECTION_STORE="selection_store
    print "HAS_RTS="has_rts
}
