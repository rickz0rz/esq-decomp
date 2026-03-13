BEGIN {
    has_label=0
    has_setdrmd_call=0
    has_setrowcolor_call=0
    has_setapen_call=0
    has_rectfill_call=0
    has_bevel_call=0
    has_formatentry_call=0
    has_mul_call=0
    has_textlength_call=0
    has_move_call=0
    has_text_call=0
    has_validate_call=0
    has_column_start=0
    has_column_width=0
    has_const3=0
    has_const17=0
    has_const33=0
    has_const35=0
    has_const36=0
    has_const48=0
    has_const64=0
    has_const695=0
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

    if (u ~ /^NEWGRID_DRAWCLOCKFORMATHEADER:/ || u ~ /^NEWGRID_DRAWCLOCKFORMATHE[A-Z0-9_]*:/) has_label=1
    if (n ~ /LVOSETDRMD/) has_setdrmd_call=1
    if (n ~ /NEWGRIDSETROWCOLOR/) has_setrowcolor_call=1
    if (n ~ /LVOSETAPEN/) has_setapen_call=1
    if (n ~ /LVORECTFILL/) has_rectfill_call=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/ || n ~ /BEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /BEVELDRAWBEVELFRAMEWITHTOPR/ || n ~ /BEVELDRAWBEVELF/) has_bevel_call=1
    if (n ~ /NEWGRID2JMPTBLCLEANUPFORMATCLOCKFORMATENTRY/ || n ~ /NEWGRID2JMPTBLCLEANUPFORMATCLOCKFORMA/ || n ~ /NEWGRID2JMPTBLCLEANUPFORMATCLOCKF/ || n ~ /NEWGRID2JMPTBLCLEANUPFORMATCL/ || n ~ /CLEANUPFORMATCLOCKFORMATENTRY/ || n ~ /CLEANUPFORMATCLOCKFORMA/ || n ~ /CLEANUPFORMATCLOCKF/ || n ~ /CLEANUPFORMATCL/) has_formatentry_call=1
    if (n ~ /NEWGRIDJMPTBLMATHMULU32/ || n ~ /NEWGRIDJMPTBLMATHMULU/ || n ~ /MATHMULU32/ || n ~ /MATHMULU/) has_mul_call=1
    if (n ~ /LVOTEXTLENGTH/ || n ~ /TEXTLENGTH/) has_textlength_call=1
    if (n ~ /LVOMOVE/) has_move_call=1
    if (n ~ /LVOTEXT/) has_text_call=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/ || n ~ /NEWGRIDVALIDATESELECTIONCO/) has_validate_call=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNSTARTXP/) has_column_start=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/ || n ~ /NEWGRIDCOLUMNWIDTHP/) has_column_width=1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$03/ || u ~ /#\$3([^0-9A-F]|$)/ || u ~ /3\.[Ww]/ || u ~ /\(\$3\)\.[Ww]/) has_const3=1
    if (u ~ /#17([^0-9]|$)/ || u ~ /#\$11/ || u ~ /17\.[Ww]/ || u ~ /\(\$11\)\.[Ww]/) has_const17=1
    if (u ~ /#33([^0-9]|$)/ || u ~ /#\$21/ || u ~ /33\.[Ww]/ || u ~ /\(\$21\)\.[Ww]/) has_const33=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /35\.[Ww]/ || u ~ /\(\$23\)\.[Ww]/) has_const35=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /36\.[Ww]/ || u ~ /\(\$24\)\.[Ww]/) has_const36=1
    if (u ~ /#48([^0-9]|$)/ || u ~ /#\$30/ || u ~ /48\.[Ww]/ || u ~ /\(\$30\)\.[Ww]/) has_const48=1
    if (u ~ /#64([^0-9]|$)/ || u ~ /#\$40/ || u ~ /64\.[Ww]/ || u ~ /\(\$40\)\.[Ww]/) has_const64=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /695\.[Ww]/ || u ~ /\$2B7/) has_const695=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_LABEL="has_label
    print "HAS_SETDRMD_CALL="has_setdrmd_call
    print "HAS_SETROWCOLOR_CALL="has_setrowcolor_call
    print "HAS_SETAPEN_CALL="has_setapen_call
    print "HAS_RECTFILL_CALL="has_rectfill_call
    print "HAS_BEVEL_CALL="has_bevel_call
    print "HAS_FORMATENTRY_CALL="has_formatentry_call
    print "HAS_MUL_CALL="has_mul_call
    print "HAS_TEXTLENGTH_CALL="has_textlength_call
    print "HAS_MOVE_CALL="has_move_call
    print "HAS_TEXT_CALL="has_text_call
    print "HAS_VALIDATE_CALL="has_validate_call
    print "HAS_COLUMN_START="has_column_start
    print "HAS_COLUMN_WIDTH="has_column_width
    print "HAS_CONST_3="has_const3
    print "HAS_CONST_17="has_const17
    print "HAS_CONST_33="has_const33
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_48="has_const48
    print "HAS_CONST_64="has_const64
    print "HAS_CONST_695="has_const695
    print "HAS_RTS="has_rts
}
