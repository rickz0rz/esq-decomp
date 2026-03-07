BEGIN {
    has_entry=0
    has_skipclass3=0
    has_appendn=0
    has_appendnull=0
    has_draw_frame=0
    has_bevel=0
    has_textlen=0
    has_move=0
    has_text=0
    has_validate=0
    has_const17=0
    has_const67=0
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

    if (u ~ /^NEWGRID_DRAWSHOWTIMESPROMPT:/ || u ~ /^NEWGRID_DRAWSHOWTIMESPROMP[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3CHARS/ || n ~ /NEWGRID2JMPTBLSTRSKIPCLASS3/) has_skipclass3=1
    if (n ~ /NEWGRID2JMPTBLSTRINGAPPENDN/) has_appendn=1
    if (n ~ /PARSEINIJMPTBLSTRINGAPPENDATNULL/ || n ~ /PARSEINIJMPTBLSTRINGAPPENDATN/) has_appendnull=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_draw_frame=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAME/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel=1
    if (n ~ /LVOTEXTLENGTH/) has_textlen=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate=1
    if (u ~ /#17([^0-9]|$)/ || u ~ /#\$11/ || u ~ /17\.[Ww]/) has_const17=1
    if (u ~ /#67([^0-9]|$)/ || u ~ /#\$43/ || u ~ /67\.[Ww]/ || u ~ /\(\$43\)/) has_const67=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_SKIPCLASS3_CALL="has_skipclass3
    print "HAS_APPENDN_CALL="has_appendn
    print "HAS_APPENDATNULL_CALL="has_appendnull
    print "HAS_DRAW_FRAME_CALL="has_draw_frame
    print "HAS_BEVEL_CALL="has_bevel
    print "HAS_TEXTLEN_CALL="has_textlen
    print "HAS_MOVE_CALL="has_move
    print "HAS_TEXT_CALL="has_text
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_CONST_17="has_const17
    print "HAS_CONST_67="has_const67
    print "HAS_RTS="has_rts
}
