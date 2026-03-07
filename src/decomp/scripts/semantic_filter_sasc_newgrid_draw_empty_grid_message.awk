BEGIN {
    has_entry=0
    has_draw_frame=0
    has_fmt_clock=0
    has_append=0
    has_bevel=0
    has_set_pen=0
    has_set_drmd=0
    has_text_len=0
    has_move=0
    has_text=0
    has_validate=0
    has_msg_prefix=0
    has_colstart=0
    has_colwidth=0
    has_const33=0
    has_const35=0
    has_const36=0
    has_const65=0
    has_const695=0
    has_const17=0
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

    if (u ~ /^NEWGRID_DRAWEMPTYGRIDMESSAGE:/ || u ~ /^NEWGRID_DRAWEMPTYGRIDMESS[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_draw_frame=1
    if (n ~ /NEWGRID2JMPTBLCLEANUPFORMATCLOCKFORMATENTRY/ || n ~ /NEWGRID2JMPTBLCLEANUPFORMATCLOCKF/ || n ~ /NEWGRID2JMPTBLCLEANUPFORMATCL/) has_fmt_clock=1
    if (n ~ /PARSEINIJMPTBLSTRINGAPPENDATNULL/ || n ~ /PARSEINIJMPTBLSTRINGAPPENDATN/ || n ~ /STRINGAPPENDATNULL/) has_append=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel=1
    if (n ~ /LVOSETAPEN/) has_set_pen=1
    if (n ~ /LVOSETDRMD/) has_set_drmd=1
    if (n ~ /LVOTEXTLENGTH/) has_text_len=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/ || n ~ /NEWGRIDVALIDATESELECTIONCO/) has_validate=1
    if (n ~ /SCRIPTPTRMOVIESUMMARYFORPREFIX/ || n ~ /SCRIPTPTRMOVIESUMMARYFORP/) has_msg_prefix=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/ || n ~ /NEWGRIDCOLUMNSTARTXP/) has_colstart=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/ || n ~ /NEWGRIDCOLUMNWIDTHP/) has_colwidth=1
    if (u ~ /#33([^0-9]|$)/ || u ~ /#\$21/ || u ~ /33\.[Ww]/ || u ~ /\(\$21\)/) has_const33=1
    if (u ~ /#35([^0-9]|$)/ || u ~ /#\$23/ || u ~ /35\.[Ww]/ || u ~ /\(\$23\)/) has_const35=1
    if (u ~ /#36([^0-9]|$)/ || u ~ /#\$24/ || u ~ /36\.[Ww]/ || u ~ /\(\$24\)/) has_const36=1
    if (u ~ /#65([^0-9]|$)/ || u ~ /#\$41/ || u ~ /65\.[Ww]/ || u ~ /\(\$41\)/) has_const65=1
    if (u ~ /#695/ || u ~ /#\$2B7/ || u ~ /695\.[Ww]/ || u ~ /\$2B7/) has_const695=1
    if (u ~ /#17([^0-9]|$)/ || u ~ /#\$11/ || u ~ /17\.[Ww]/ || u ~ /\(\$11\)/) has_const17=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_FRAME_CALL="has_draw_frame
    print "HAS_FORMAT_CLOCK_CALL="has_fmt_clock
    print "HAS_APPEND_CALL="has_append
    print "HAS_BEVEL_CALL="has_bevel
    print "HAS_SET_PEN_CALL="has_set_pen
    print "HAS_SET_DRMD_CALL="has_set_drmd
    print "HAS_TEXTLENGTH_CALL="has_text_len
    print "HAS_MOVE_CALL="has_move
    print "HAS_TEXT_CALL="has_text
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_MSG_PREFIX_GLOBAL="has_msg_prefix
    print "HAS_COLSTART_GLOBAL="has_colstart
    print "HAS_COLWIDTH_GLOBAL="has_colwidth
    print "HAS_CONST_33="has_const33
    print "HAS_CONST_35="has_const35
    print "HAS_CONST_36="has_const36
    print "HAS_CONST_65="has_const65
    print "HAS_CONST_695="has_const695
    print "HAS_CONST_17="has_const17
    print "HAS_RTS="has_rts
}
