BEGIN {
    has_entry = 0
    has_sprintf = 0
    has_match = 0
    has_ui_guard = 0
    has_disable_enable = 0
    has_setapen = 0
    has_rectfill = 0
    has_display_text = 0
    has_append = 0
    has_return_branch = 0
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

    if (u ~ /^ESQIFF2_SHOWVERSIONMISMATCHOVERLAY:/ || u ~ /^ESQIFF2_SHOWVERSIONMISMATCHO[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "GROUP_AM_JMPTBL_WDISP_SPRINTF") > 0 || index(u, "WDISP_SPRINTF") > 0) has_sprintf = 1
    if (index(u, "ESQSHARED_JMPTBL_ESQ_WILDCARDMATCH") > 0 || index(u, "WILDCARDMATCH") > 0 || index(u, "WILDCARDMAT") > 0) has_match = 1
    if (index(u, "GLOBAL_UIBUSYFLAG") > 0 || index(u, "ED_DIAGNOSTICSSCREENACTIVE") > 0) has_ui_guard = 1
    if (index(u, "_LVODISABLE") > 0 || index(u, "_LVOENABLE") > 0 || index(u, "DISABLE") > 0 || index(u, "ENABLE") > 0) has_disable_enable = 1
    if (index(u, "_LVOSETAPEN") > 0 || index(u, "SETAPEN") > 0) has_setapen = 1
    if (index(u, "_LVORECTFILL") > 0 || index(u, "RECTFILL") > 0) has_rectfill = 1
    if (index(u, "ESQPARS_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION") > 0 || index(u, "DISPLAYTEXTATPOSITION") > 0 || index(u, "DISPLAYTE") > 0) has_display_text = 1
    if (index(u, "GROUP_AR_JMPTBL_STRING_APPENDATNULL") > 0 || index(u, "APPENDATNULL") > 0 || index(u, "APPENDATN") > 0) has_append = 1
    if (u ~ /^BEQ\.[SWB] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || u ~ /^BEQ\.[SWB] ___ESQIFF2_SHOWVERSIONMISMATCHO/ || u ~ /^BRA\.[SWB] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || u ~ /^JMP ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_MATCH=" has_match
    print "HAS_UI_GUARD=" has_ui_guard
    print "HAS_DISABLE_ENABLE=" has_disable_enable
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_DISPLAY_TEXT=" has_display_text
    print "HAS_APPEND=" has_append
    print "HAS_RETURN_BRANCH=" has_return_branch
}
