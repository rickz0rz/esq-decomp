BEGIN {
    has_entry=0
    has_is_last=0
    count_is_last=0
    has_initial_is_last_branch=0
    has_loop_is_last_branch=0
    has_set_row_color=0
    has_setapen=0
    has_rectfill=0
    has_total_lines=0
    has_measure_line=0
    has_has_multiple=0
    has_last_selected=0
    has_render_line=0
    has_vertical_bevel=0
    has_horizontal_bevel=0
    has_control_marker=0
    has_row_height=0
    has_const695=0
    has_const612=0
    has_const42=0
    has_const2=0
    has_selection_code_store=0
    has_rts=0
    last_call=""
    render_seen=0
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
    if (u ~ /^(XREF|XDEF|END) / || u == "END") next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_DRAWGRIDFRAMEANDROWS:/ || u ~ /^NEWGRID_DRAWGRIDFRAMEANDROWS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINELAST/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISCURRE/ || n ~ /DISPTEXTISCURRENTLINELAST/ || n ~ /DISPTEXTISCURRENTLINE/ || n ~ /DISPTEXTISCURRE/) {
        has_is_last=1
        count_is_last++
        last_call="is_last_" count_is_last
    }
    if (n ~ /NEWGRIDSETROWCOLOR/) {
        has_set_row_color=1
        last_call="set_row_color"
    }
    if (n ~ /LVOSETAPEN/) {
        has_setapen=1
        last_call="setapen"
    }
    if (n ~ /LVORECTFILL/) {
        has_rectfill=1
        last_call="rectfill"
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTGETTOTALLINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTGETTOTALLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTGETTOTA/ || n ~ /DISPTEXTGETTOTALLINECOUNT/ || n ~ /DISPTEXTGETTOTALLINE/ || n ~ /DISPTEXTGETTOTA/) {
        has_total_lines=1
        last_call="total_lines"
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTMEASURECURRENTLINELENGTH/ || n ~ /NEWGRID2JMPTBLDISPTEXTMEASURECURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTMEASURE/ || n ~ /DISPTEXTMEASURECURRENTLINELENGTH/ || n ~ /DISPTEXTMEASURECURRENT/ || n ~ /DISPTEXTMEASURE/) {
        has_measure_line=1
        last_call="measure_line"
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLELINES/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULTIPLE/ || n ~ /NEWGRID2JMPTBLDISPTEXTHASMULT/ || n ~ /DISPTEXTHASMULTIPLELINES/ || n ~ /DISPTEXTHASMULTIPLE/ || n ~ /DISPTEXTHASMULT/) {
        has_has_multiple=1
        last_call="has_multiple"
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINESELECTED/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTISLASTL/ || n ~ /DISPTEXTISLASTLINESELECTED/ || n ~ /DISPTEXTISLASTLINE/ || n ~ /DISPTEXTISLASTL/) {
        has_last_selected=1
        last_call="last_selected"
    }
    if (n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENTLINE/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERCURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTRENDERC/ || n ~ /DISPTEXTRENDERCURRENTLINE/ || n ~ /DISPTEXTRENDERCURRENT/ || n ~ /DISPTEXTRENDERC/) {
        has_render_line=1
        render_seen=1
        last_call="render_line"
    }
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWVERTICALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWVERTIC/ || n ~ /BEVELDRAWVERTICALBEVEL/ || n ~ /BEVELDRAWVERTIC/) has_vertical_bevel=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZONTALBEVEL/ || n ~ /NEWGRID2JMPTBLBEVELDRAWHORIZO/ || n ~ /BEVELDRAWHORIZONTALBEVEL/ || n ~ /BEVELDRAWHORIZO/) has_horizontal_bevel=1
    if (n ~ /DISPTEXTCONTROLMARKERXOFFSETPX/) has_control_marker=1
    if (n ~ /NEWGRIDROWHEIGHTPX/) has_row_height=1
    if (u ~ /#695([^0-9]|$)/ || u ~ /#\$2B7/ || u ~ /\(\$2B7\)/) has_const695=1
    if (u ~ /#612([^0-9]|$)/ || u ~ /#\$264/ || u ~ /\(\$264\)/) has_const612=1
    if (u ~ /#42([^0-9]|$)/ || u ~ /#\$2A/ || u ~ /\(\$2A\)/) has_const42=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /MOVE\.W .*52\(A3\)/ || u ~ /MOVE\.W .*\$34\(A3\)/) has_selection_code_store=1
    if (u ~ /^BNE(\.[A-Z])?[ \t]/ || u ~ /^BNE$/) {
        if (last_call == "is_last_1") has_initial_is_last_branch=1
        if (last_call == "is_last_2") has_loop_is_last_branch=1
    }
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_IS_CURRENT_LINE_LAST_CALL="has_is_last
    print "COUNT_IS_CURRENT_LINE_LAST_CALLS="count_is_last
    print "HAS_INITIAL_IS_LAST_BRANCH="has_initial_is_last_branch
    print "HAS_LOOP_IS_LAST_BRANCH="has_loop_is_last_branch
    print "HAS_SET_ROW_COLOR_CALL="has_set_row_color
    print "HAS_SETAPEN_CALL="has_setapen
    print "HAS_RECTFILL_CALL="has_rectfill
    print "HAS_GET_TOTAL_LINE_COUNT_CALL="has_total_lines
    print "HAS_MEASURE_LINE_LENGTH_CALL="has_measure_line
    print "HAS_HAS_MULTIPLE_LINES_CALL="has_has_multiple
    print "HAS_IS_LAST_LINE_SELECTED_CALL="has_last_selected
    print "HAS_RENDER_CURRENT_LINE_CALL="has_render_line
    print "HAS_VERTICAL_BEVEL_CALL="has_vertical_bevel
    print "HAS_HORIZONTAL_BEVEL_CALL="has_horizontal_bevel
    print "HAS_CONTROL_MARKER_GLOBAL="has_control_marker
    print "HAS_ROW_HEIGHT_GLOBAL="has_row_height
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_612="has_const612
    print "HAS_CONST_42="has_const42
    print "HAS_CONST_2="has_const2
    print "HAS_SELECTION_CODE_STORE="has_selection_code_store
    print "HAS_RTS="has_rts
}
