BEGIN {
    has_entry=0
    has_set_row_color=0
    has_set_pen=0
    has_rectfill=0
    has_beveled=0
    has_topright=0
    has_colstart=0
    has_colwidth=0
    has_rowheight=0
    has_cfg=0
    has_const3=0
    has_const36=0
    has_const695=0
    has_const89=0
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

    if (u ~ /^NEWGRID_DRAWGRIDCELLBACKGROUND:/ || u ~ /^NEWGRID_DRAWGRIDCELLBACKGR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSETROWCOLOR/) has_set_row_color=1
    if (n ~ /LVOSETAPEN/) has_set_pen=1
    if (n ~ /LVORECTFILL/) has_rectfill=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDFRAME/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELE/) has_beveled=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_topright=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNSTARTXP/) has_colstart=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/ || n ~ /NEWGRIDCOLUMNWIDTHP/) has_colwidth=1
    if (n ~ /NEWGRIDROWHEIGHTPX/ || n ~ /NEWGRIDROWHEIGHTP/) has_rowheight=1
    if (n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELFLAG/ || n ~ /CONFIGNEWGRIDPLACEHOLDERBEVELF/) has_cfg=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)/) has_const3=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /36\.[Ww]/ || u ~ /\(\$24\)/) has_const36=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /695\.[Ww]/ || u ~ /\$2B7/) has_const695=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SETROWCOLOR_CALL="has_set_row_color
    print "HAS_SETAPEN_CALL="has_set_pen
    print "HAS_RECTFILL_CALL="has_rectfill
    print "HAS_DRAW_BEVELED_CALL="has_beveled
    print "HAS_DRAW_TOPRIGHT_CALL="has_topright
    print "HAS_COLSTART_GLOBAL="has_colstart
    print "HAS_COLWIDTH_GLOBAL="has_colwidth
    print "HAS_ROWHEIGHT_GLOBAL="has_rowheight
    print "HAS_BEVEL_CFG_GLOBAL="has_cfg
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_89="has_const89
    print "HAS_RTS="has_rts
}
