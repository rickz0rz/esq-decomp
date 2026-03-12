BEGIN {
    has_entry = 0
    has_play_next = 0
    has_draw_next = 0
    has_reset = 0
    has_return = 0
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
    u = toupper(line)

    if (u ~ /^TEXTDISP_UPDATEHIGHLIGHTORPREVIEW:/ || u ~ /^TEXTDISP_UPDATEHIGHLIGHTORPRE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TEXTDISP2_JMPTBL_ESQIFF_PLAYNEXTEXTERNALASSETFRAME") > 0 ||
        index(u, "TEXTDISP2_JMPTBL_ESQIFF_PLAYNEXT") > 0 ||
        index(u, "ESQIFF_PLAYNEXTEXTERNALASSETFRAME") > 0 ||
        index(u, "ESQIFF_PLAYNEXTEXTERNALASSETFRAM") > 0) has_play_next = 1
    if (index(u, "TEXTDISP_DRAWNEXTENTRYPREVIEW") > 0 || index(u, "TEXTDISP_DRAWNEXTENTRYPRE") > 0) has_draw_next = 1
    if (index(u, "TEXTDISP_RESETSELECTIONANDREFRESH") > 0 || index(u, "TEXTDISP_RESETSELECTIONANDRE") > 0) has_reset = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PLAY_NEXT=" has_play_next
    print "HAS_DRAW_NEXT=" has_draw_next
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}
