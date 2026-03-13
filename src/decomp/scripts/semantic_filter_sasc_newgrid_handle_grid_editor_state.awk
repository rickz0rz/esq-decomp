BEGIN {
    has_entry=0
    has_state_global=0
    has_set_layout=0
    has_layout_append=0
    has_visible_count=0
    has_draw_frame_rows=0
    has_const612=0
    has_const20=0
    has_const4=0
    has_const5=0
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

    if (u ~ /^NEWGRID_HANDLEGRIDEDITORSTATE:/ || u ~ /^NEWGRID_HANDLEGRIDEDITORSTA[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDGRIDEDITORWORKFLOWSTATE/ || n ~ /NEWGRIDGRIDEDITORWORKFLOWS/) has_state_global=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUTPARAMS/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUTP/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/ || n ~ /DISPTEXTSETLAYOUTPARAMS/ || n ~ /DISPTEXTSETLAYOUT/) has_set_layout=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/ || n ~ /DISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /DISPTEXTLAYOUTANDAPPEND/) has_layout_append=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLEL/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/ || n ~ /DISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /DISPTEXTCOMPUTEVISIBLE/) has_visible_count=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEANDROWS/ || n ~ /NEWGRIDDRAWGRIDFRAMEANDROW/) has_draw_frame_rows=1
    if (u ~ /#612/ || u ~ /#\$264/ || u ~ /612\.[Ww]/ || u ~ /\$264/) has_const612=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/ || u ~ /20\.[Ww]/ || u ~ /\(\$14\)/) has_const20=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#-1/ || u ~ /#\$FFFFFFFF/ || u ~ /#\$FF/ || n ~ /MOVEQLFFA/) has_constm1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_STATE_GLOBAL="has_state_global
    print "HAS_SET_LAYOUT_CALL="has_set_layout
    print "HAS_LAYOUT_APPEND_CALL="has_layout_append
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_DRAW_FRAME_ROWS_CALL="has_draw_frame_rows
    print "HAS_CONST_612="has_const612
    print "HAS_CONST_20="has_const20
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_MINUS1="has_constm1
    print "HAS_RTS="has_rts
}
