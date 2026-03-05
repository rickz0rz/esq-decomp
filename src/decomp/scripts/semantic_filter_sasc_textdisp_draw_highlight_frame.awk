BEGIN {
    has_entry = 0
    has_clear = 0
    has_build_ctx = 0
    has_copper_on = 0
    has_mulu = 0
    has_drop = 0
    has_restore = 0
    has_div = 0
    has_banner = 0
    has_setdrmd = 0
    has_draw = 0
    has_rise = 0
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

    if (u ~ /^TEXTDISP_DRAWHIGHLIGHTFRAME:/ || u ~ /^TEXTDISP_DRAWHIGHLIGHTFR[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TLIBA3_CLEARVIEWMODERASTPORT") > 0 || index(u, "TLIBA3_CLEARVIEWMODE") > 0) has_clear = 1
    if (index(u, "TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE") > 0 || index(u, "TLIBA3_BUILDDISPLAYCONTEXT") > 0) has_build_ctx = 1
    if (index(u, "WDISP_JMPTBL_ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT") > 0 || index(u, "WDISP_JMPTBL_ESQ_SETCOPPEREFF") > 0) has_copper_on = 1
    if (index(u, "MATH_MULU32") > 0) has_mulu = 1
    if (index(u, "WDISP_JMPTBL_ESQIFF_RUNCOPPERDROPTRANSITION") > 0 || index(u, "WDISP_JMPTBL_ESQIFF_RUNCOPPERDRO") > 0) has_drop = 1
    if (index(u, "WDISP_JMPTBL_ESQIFF_RESTOREBASEPALETTETRIPLES") > 0 || index(u, "WDISP_JMPTBL_ESQIFF_RESTOREBASEPA") > 0 || index(u, "WDISP_JMPTBL_ESQIFF_RESTOREBASEP") > 0) has_restore = 1
    if (index(u, "MATH_DIVS32") > 0) has_div = 1
    if (index(u, "SCRIPT_BEGINBANNERCHARTRANSITION") > 0 || index(u, "SCRIPT_BEGINBANNERCHARTR") > 0) has_banner = 1
    if (index(u, "_LVOSETDRMD") > 0) has_setdrmd = 1
    if (index(u, "TLIBA1_DRAWFORMATTEDTEXTBLOCK") > 0 || index(u, "TLIBA1_DRAWFORMATTEDTEXTB") > 0) has_draw = 1
    if (index(u, "TEXTDISP_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION") > 0 || index(u, "TEXTDISP_JMPTBL_ESQIFF_RUNCOPPERRI") > 0 || index(u, "TEXTDISP_JMPTBL_ESQIFF_RUNCOPPER") > 0) has_rise = 1
    if (index(u, "TEXTDISP_RESETSELECTIONSTATE") > 0 || index(u, "TEXTDISP_RESETSELECTIO") > 0) has_reset = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLEAR=" has_clear
    print "HAS_BUILD_CTX=" has_build_ctx
    print "HAS_COPPER_ON=" has_copper_on
    print "HAS_MULU=" has_mulu
    print "HAS_DROP=" has_drop
    print "HAS_RESTORE=" has_restore
    print "HAS_DIV=" has_div
    print "HAS_BANNER=" has_banner
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_DRAW=" has_draw
    print "HAS_RISE=" has_rise
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}
