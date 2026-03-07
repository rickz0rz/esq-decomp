BEGIN {
    has_entry=0
    has_latch_global=0
    has_update_preset=0
    has_set_layout=0
    has_draw_entry=0
    has_set_line_index=0
    has_sprintf=0
    has_layout_append=0
    has_draw_frame_variant2=0
    has_visible_count=0
    has_const4=0
    has_const5=0
    has_const2=0
    has_const3=0
    has_const_minus1=0
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

    if (u ~ /^NEWGRID_HANDLEDETAILGRIDSTATE:/ || u ~ /^NEWGRID_HANDLEDETAILGRIDSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDETAILGRIDSTATELATCH/) has_latch_global=1
    if (n ~ /NEWGRIDUPDATEPRESETENTRY/) has_update_preset=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUTPARAMS/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUT/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/) has_set_layout=1
    if (n ~ /NEWGRIDDRAWGRIDENTRY/) has_draw_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETCURRENTLINEINDEX/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETCURRENT/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETCURR/) has_set_line_index=1
    if (n ~ /PARSEINIJMPTBLWDISPSPRINTF/) has_sprintf=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPENDTOBUFFER/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTANDAPPEND/ || n ~ /NEWGRID2JMPTBLDISPTEXTLAYOUTA/) has_layout_append=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEVARIANT2/) has_draw_frame_variant2=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLE/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/) has_visible_count=1
    if (u ~ /#4([^0-9]|$)/ || u ~ /#\$04/ || u ~ /#\$4([^0-9A-F]|$)/ || u ~ /4\.[Ww]/ || u ~ /\(\$4\)/) has_const4=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#2([^0-9]|$)/ || u ~ /#\$02/ || u ~ /#\$2([^0-9A-F]|$)/ || u ~ /2\.[Ww]/ || u ~ /\(\$2\)/) has_const2=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LATCH_GLOBAL="has_latch_global
    print "HAS_UPDATE_PRESET_CALL="has_update_preset
    print "HAS_SET_LAYOUT_PARAMS_CALL="has_set_layout
    print "HAS_DRAW_GRID_ENTRY_CALL="has_draw_entry
    print "HAS_SET_CURRENT_LINE_INDEX_CALL="has_set_line_index
    print "HAS_SPRINTF_CALL="has_sprintf
    print "HAS_LAYOUT_APPEND_CALL="has_layout_append
    print "HAS_DRAW_FRAME_VARIANT2_CALL="has_draw_frame_variant2
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
