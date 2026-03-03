BEGIN {
    has_entry = 0
    has_ui_guard = 0
    has_jumptable = 0
    has_disable_enable = 0
    has_rectfill = 0
    has_setdrmd = 0
    has_error_sprintf = 0
    has_file_sprintf = 0
    has_plane_mask = 0
    has_display_text = 0
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

    if (uline ~ /^ESQIFF2_SHOWATTENTIONOVERLAY:/) has_entry = 1
    if (uline ~ /^TST\.W GLOBAL_UIBUSYFLAG$/ || uline ~ /^TST\.W ED_DIAGNOSTICSSCREENACTIVE$/) has_ui_guard = 1
    if (uline ~ /^\.LAB_0B28:$/ || uline ~ /^JMP \.LAB_0B28\+2\(PC,D0\.W\)$/) has_jumptable = 1
    if (uline ~ /^JSR _LVODISABLE\(A6\)$/ || uline ~ /^JSR _LVOENABLE\(A6\)$/) has_disable_enable = 1
    if (uline ~ /^JSR _LVORECTFILL\(A6\)$/) has_rectfill = 1
    if (uline ~ /^JSR _LVOSETDRMD\(A6\)$/) has_setdrmd = 1
    if (uline ~ /^PEA GLOBAL_STR_REPORT_ERROR_CODE_FORMATTED$/) has_error_sprintf = 1
    if (uline ~ /^PEA GLOBAL_STR_FILE_WIDTH_COLORS_FORMATTED$/ || uline ~ /^PEA GLOBAL_STR_FILE_PERCENT_S$/) has_file_sprintf = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_BRUSH_PLANEMASKFORINDEX\(PC\)$/) has_plane_mask = 1
    if (uline ~ /^JSR ESQPARS_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION\(PC\)$/) has_display_text = 1
    if (uline ~ /^BEQ\.[SW] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || uline ~ /^BLE\.[SW] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || uline ~ /^BRA\.[SW] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || uline ~ /^JMP ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/) has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_UI_GUARD=" has_ui_guard
    print "HAS_JUMPTABLE=" has_jumptable
    print "HAS_DISABLE_ENABLE=" has_disable_enable
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_ERROR_SPRINTF=" has_error_sprintf
    print "HAS_FILE_SPRINTF=" has_file_sprintf
    print "HAS_PLANE_MASK=" has_plane_mask
    print "HAS_DISPLAY_TEXT=" has_display_text
    print "HAS_RETURN_BRANCH=" has_return_branch
}
