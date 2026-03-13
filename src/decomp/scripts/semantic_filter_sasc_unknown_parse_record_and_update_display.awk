BEGIN {
    has_wildcard_call = 0
    has_replace_call = 0
    has_display_call = 0
    has_overlay_ptr = 0
    has_countdown = 0
    has_color = 0
    has_brush = 0
    has_diag = 0
    has_rts_or_jmp = 0
}

function trim(s,    t) {
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

    if (u ~ /UNKNOWN_JMPTBL_ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATCH/) has_wildcard_call = 1
    if (u ~ /ESQPROTO_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPROTO_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_call = 1
    if (u ~ /UNKNOWN_JMPTBL_DISPLIB_DISPLAYT/ || u ~ /UNKNOWN_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION/) has_display_call = 1
    if (u ~ /WDISP_WEATHERSTATUSOVERLAYTEXTPTR/ || u ~ /WDISP_WEATHERSTATUSOVERLAYTEXTPT/) has_overlay_ptr = 1
    if (u ~ /WDISP_WEATHERSTATUSCOUNTDOWN/) has_countdown = 1
    if (u ~ /WDISP_WEATHERSTATUSCOLORCODE/) has_color = 1
    if (u ~ /WDISP_WEATHERSTATUSBRUSHINDEX/) has_brush = 1
    if (u ~ /ED_DIAGNOSTICSSCREENACTIVE/) has_diag = 1
    if (u ~ /^RTS$/ || u ~ /^JMP / || u ~ /^JSR / || u ~ /^BSR / || u ~ /^BSR\.W /) has_rts_or_jmp = 1
}

END {
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_DISPLAY_CALL=" has_display_call
    print "HAS_OVERLAY_PTR=" has_overlay_ptr
    print "HAS_COUNTDOWN=" has_countdown
    print "HAS_COLOR=" has_color
    print "HAS_BRUSH=" has_brush
    print "HAS_DIAG_TEST=" has_diag
    print "HAS_RTS_OR_JMP=" has_rts_or_jmp
}
