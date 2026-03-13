BEGIN {
    has_entry=0
    has_state_latch=0
    has_set_layout=0
    has_draw_entry=0
    has_set_line=0
    has_build=0
    has_layout_append=0
    has_draw_variant3=0
    has_visible_count=0
    has_const612=0
    has_const20=0
    has_const48=0
    has_const78=0
    has_constm1=0
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

    if (u ~ /^NEWGRID_HANDLESHOWTIMESSTATE:/ || u ~ /^NEWGRID_HANDLESHOWTIMESSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSHOWTIMESWORKFLOWSTATELATCH/ || n ~ /NEWGRIDSHOWTIMESWORKFLOWSTATEL/) has_state_latch=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUTPARAMS/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/ || n ~ /DISPTEXTSETLAYOUTPARAMS/ || n ~ /DISPTEXTSETLAYOUT/) has_set_layout=1
    if (n ~ /NEWGRIDDRAWGRIDENTRY/) has_draw_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETCURRENTLINEINDEX/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETCURRENTL/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETCURR/ || n ~ /DISPTEXTSETCURRENTLINEINDEX/ || n ~ /DISPTEXTSETCURRENTLINE/) has_set_line=1
    if (n ~ /NEWGRIDBUILDSHOWTIMESTEXT/ || n ~ /NEWGRIDBUILDSHOWTIMESTEX/) has_build=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/ || n ~ /DISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /DISPTEXTLAYOUTANDAPPEND/) has_layout_append=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEVARIANT3/ || n ~ /NEWGRIDDRAWGRIDFRAMEVARIAN/) has_draw_variant3=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/ || n ~ /DISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /DISPTEXTCOMPUTEVISIBLE/) has_visible_count=1
    if (u ~ /#612/ || u ~ /#\$264/ || u ~ /612\.[Ww]/ || u ~ /\$264/) has_const612=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/ || u ~ /20\.[Ww]/ || u ~ /\(\$14\)/) has_const20=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)/) has_const48=1
    if (u ~ /#78([^0-9]|$)/ || u ~ /#\$4E/ || u ~ /78\.[Ww]/ || u ~ /\(\$4E\)/) has_const78=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_STATE_LATCH_GLOBAL="has_state_latch
    print "HAS_SET_LAYOUT_CALL="has_set_layout
    print "HAS_DRAW_ENTRY_CALL="has_draw_entry
    print "HAS_SET_LINE_CALL="has_set_line
    print "HAS_BUILD_TEXT_CALL="has_build
    print "HAS_LAYOUT_APPEND_CALL="has_layout_append
    print "HAS_DRAW_VARIANT3_CALL="has_draw_variant3
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_CONST_612="has_const612
    print "HAS_CONST_20="has_const20
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_78="has_const78
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
