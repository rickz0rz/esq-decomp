BEGIN {
    has_entry=0
    has_skip=0
    has_beveled=0
    has_bevel_topright=0
    has_draw_text=0
    has_colstart=0
    has_rowheight=0
    has_const35=0
    has_const19=0
    has_const1=0
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

    if (u ~ /^NEWGRID_DRAWGRIDCELL:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3C/) has_skip=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDFRAME/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELEDF/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELE/) has_beveled=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel_topright=1
    if (n ~ /NEWGRIDDRAWGRIDCELLTEXT/) has_draw_text=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNSTARTXP/) has_colstart=1
    if (n ~ /NEWGRIDROWHEIGHTPX/ || n ~ /NEWGRIDROWHEIGHTP/) has_rowheight=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /35\.[Ww]/ || u ~ /\(\$23\)/) has_const35=1
    if (u ~ /#19([^0-9]|$)/ || u ~ /#\$13/ || u ~ /19\.[Ww]/ || u ~ /\(\$13\)/) has_const19=1
    if (u ~ /#1([^0-9]|$)/ || u ~ /#\$01/ || u ~ /#\$1([^0-9A-F]|$)/ || u ~ /1\.[Ww]/ || u ~ /\(\$1\)/) has_const1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SKIPCLASS3_CALL="has_skip
    print "HAS_DRAW_BEVELED_CALL="has_beveled
    print "HAS_DRAW_TOPRIGHT_CALL="has_bevel_topright
    print "HAS_DRAW_TEXT_CALL="has_draw_text
    print "HAS_COLSTART_GLOBAL="has_colstart
    print "HAS_ROWHEIGHT_GLOBAL="has_rowheight
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_19="has_const19
    print "HAS_CONST_1="has_const1
    print "HAS_RTS="has_rts
}
