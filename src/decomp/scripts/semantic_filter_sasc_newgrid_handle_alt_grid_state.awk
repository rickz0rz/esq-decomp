BEGIN {
    has_entry=0
    has_latch_global=0
    has_get_entry=0
    has_get_aux=0
    has_halfhour=0
    has_wildcard=0
    has_set_layout=0
    has_draw_entry=0
    has_visible_count=0
    has_draw_frame_alt=0
    has_draw_cell=0
    has_variant_flag=0
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

    if (u ~ /^NEWGRID_HANDLEALTGRIDSTATE:/ || u ~ /^NEWGRID_HANDLEALTGRIDSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDALTGRIDSTATELATCH/) has_latch_global=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/ || n ~ /ESQDISPGETENTRYPOINTERBYMODE/) has_get_entry=1
    if (n ~ /NEWGRID2JMPTBLESQDISPGETENTRYAUXPOINTERBYMODE/ || n ~ /NEWGRID2JMPTBLESQDISPGETENTRY/ || n ~ /ESQDISPGETENTRYAUXPOINTERBYMODE/) has_get_aux=1
    if (n ~ /NEWGRID2JMPTBLESQGETHALFHOURSLOTINDEX/ || n ~ /NEWGRID2JMPTBLESQGETHALFHOURS/) has_halfhour=1
    if (n ~ /NEWGRID2JMPTBLTLIBAFINDFIRSTWILDCARDMATCHINDEX/ || n ~ /NEWGRID2JMPTBLTLIBAFINDFIRSTW/) has_wildcard=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYOUTPARAMS/ || n ~ /NEWGRID2JMPTBLDISPTEXTSETLAYO/) has_set_layout=1
    if (n ~ /NEWGRIDDRAWGRIDENTRY/) has_draw_entry=1
    if (n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTEVISIBLELINECOUNT/ || n ~ /NEWGRID2JMPTBLDISPTEXTCOMPUTE/) has_visible_count=1
    if (n ~ /NEWGRIDDRAWGRIDFRAMEALT/) has_draw_frame_alt=1
    if (n ~ /NEWGRIDDRAWGRIDCELL/) has_draw_cell=1
    if (n ~ /NEWGRIDSHOWTIMEENTRYVARIANTFLAG/) has_variant_flag=1
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
    print "HAS_GET_ENTRY_CALL="has_get_entry
    print "HAS_GET_AUX_CALL="has_get_aux
    print "HAS_HALFHOUR_CALL="has_halfhour
    print "HAS_WILDCARD_CALL="has_wildcard
    print "HAS_SET_LAYOUT_CALL="has_set_layout
    print "HAS_DRAW_ENTRY_CALL="has_draw_entry
    print "HAS_VISIBLE_COUNT_CALL="has_visible_count
    print "HAS_DRAW_FRAME_ALT_CALL="has_draw_frame_alt
    print "HAS_DRAW_GRID_CELL_CALL="has_draw_cell
    print "HAS_VARIANT_FLAG_GLOBAL="has_variant_flag
    print "HAS_CONST_4="has_const4
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_2="has_const2
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
