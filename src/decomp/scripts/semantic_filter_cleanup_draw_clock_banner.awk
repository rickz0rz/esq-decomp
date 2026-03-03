BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_guard_tst = 0
    has_guard_bne = 0
    has_adjust_24 = 0
    has_sprintf = 0
    has_setapen = 0
    has_rectfill = 0
    has_bevel = 0
    has_move = 0
    has_text = 0
    has_blit = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^CLEANUP_DRAWCLOCKBANNER:/) has_label = 1
    if (uline ~ /LINK.W A5,#-12/) has_link = 1
    if (uline ~ /MOVEM.L D2-D3,-\(A7\)/) has_save = 1
    if (uline ~ /TST.W GLOBAL_UIBUSYFLAG/) has_guard_tst = 1
    if (uline ~ /BNE.W \.DONE/) has_guard_bne = 1
    if (uline ~ /GROUP_AC_JMPTBL_PARSEINI_ADJUSTHOURSTO24HRFORMAT/) has_adjust_24 = 1
    if (uline ~ /GROUP_AE_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/) has_bevel = 1
    if (uline ~ /LVOMOVE/) has_move = 1
    if (uline ~ /LVOTEXT([^A-Z]|$)/) has_text = 1
    if (uline ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/) has_blit = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_GUARD_TST=" has_guard_tst
    print "HAS_GUARD_BNE=" has_guard_bne
    print "HAS_ADJUST_24=" has_adjust_24
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_BEVEL=" has_bevel
    print "HAS_MOVE=" has_move
    print "HAS_TEXT=" has_text
    print "HAS_BLIT=" has_blit
}
