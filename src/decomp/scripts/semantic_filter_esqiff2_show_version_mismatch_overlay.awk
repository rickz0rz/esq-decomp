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
    uline = toupper(line)

    if (uline ~ /^ESQIFF2_SHOWVERSIONMISMATCHOVERLAY:/) has_entry = 1
    if (uline ~ /^JSR GROUP_AM_JMPTBL_WDISP_SPRINTF\(PC\)$/) has_sprintf = 1
    if (uline ~ /^JSR ESQSHARED_JMPTBL_ESQ_WILDCARDMATCH\(PC\)$/) has_match = 1
    if (uline ~ /^TST\.W GLOBAL_UIBUSYFLAG$/ || uline ~ /^TST\.W ED_DIAGNOSTICSSCREENACTIVE$/) has_ui_guard = 1
    if (uline ~ /^JSR _LVODISABLE\(A6\)$/ || uline ~ /^JSR _LVOENABLE\(A6\)$/) has_disable_enable = 1
    if (uline ~ /^JSR _LVOSETAPEN\(A6\)$/) has_setapen = 1
    if (uline ~ /^JSR _LVORECTFILL\(A6\)$/) has_rectfill = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION\(PC\)$/) has_display_text = 1
    if (uline ~ /^JSR GROUP_AR_JMPTBL_STRING_APPENDATNULL\(PC\)$/) has_append = 1
    if (uline ~ /^BEQ\.[SW] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || uline ~ /^BRA\.[SW] ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/ || uline ~ /^JMP ESQIFF2_SHOWVERSIONMISMATCHOVERLAY_RETURN$/) has_return_branch = 1
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
