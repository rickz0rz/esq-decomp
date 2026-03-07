BEGIN {
    has_entry=0
    has_draw_frame=0
    has_bevel=0
    has_set_pen=0
    has_set_draw_mode=0
    has_text_len=0
    has_move=0
    has_text=0
    has_validate=0
    has_colstart=0
    has_colwidth=0
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

    if (u ~ /^NEWGRID_DRAWGRIDMESSAGEALT:/ || u ~ /^NEWGRID_DRAWGRIDMESSAGEAL[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDDRAWGRIDFRAME/) has_draw_frame=1
    if (n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELFRAMEWITHTOPRIGHT/ || n ~ /NEWGRID2JMPTBLBEVELDRAWBEVELF/) has_bevel=1
    if (n ~ /LVOSETAPEN/) has_set_pen=1
    if (n ~ /LVOSETDRMD/) has_set_draw_mode=1
    if (n ~ /LVOTEXTLENGTH/) has_text_len=1
    if (n ~ /LVOMOVE/) has_move=1
    if (n ~ /LVOTEXT/) has_text=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate=1
    if (n ~ /NEWGRIDCOLUMNSTARTXPX/) has_colstart=1
    if (n ~ /NEWGRIDCOLUMNWIDTHPX/) has_colwidth=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_DRAW_FRAME_CALL="has_draw_frame
    print "HAS_BEVEL_CALL="has_bevel
    print "HAS_SET_PEN_CALL="has_set_pen
    print "HAS_SET_DRAW_MODE_CALL="has_set_draw_mode
    print "HAS_TEXTLEN_CALL="has_text_len
    print "HAS_MOVE_CALL="has_move
    print "HAS_TEXT_CALL="has_text
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_COLSTART_GLOBAL="has_colstart
    print "HAS_COLWIDTH_GLOBAL="has_colwidth
    print "HAS_RTS="has_rts
}
