BEGIN {
    has_entry = 0
    has_update_shadow = 0
    has_clear_match = 0
    has_play_next = 0
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

    if (u ~ /^TEXTDISP_RESETSELECTIONANDREFRESH:/ || u ~ /^TEXTDISP_RESETSELECTIONANDRE[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE") > 0 || index(u, "SCRIPT_UPDATESERIALSHADOWFR") > 0) has_update_shadow = 1
    if (index(u, "TEXTDISP_CURRENTMATCHINDEX") > 0) has_clear_match = 1
    if (index(u, "TEXTDISP2_JMPTBL_ESQIFF_PLAYNEXTEXTERNALASSETFRAME") > 0 || index(u, "TEXTDISP2_JMPTBL_ESQIFF_PLAYNEXTEXTERNAL") > 0 || index(u, "TEXTDISP2_JMPTBL_ESQIFF_PLAYNEXT") > 0) has_play_next = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_UPDATE_SHADOW=" has_update_shadow
    print "HAS_CLEAR_MATCH=" has_clear_match
    print "HAS_PLAY_NEXT=" has_play_next
    print "HAS_RETURN=" has_return
}
