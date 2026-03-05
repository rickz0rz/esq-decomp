BEGIN {
    has_entry = 0
    has_ui_guard = 0
    has_jumptable = 0
    has_disable_enable = 0
    has_bitmap_swap = 0
    has_rectfill = 0
    has_setdrmd = 0
    has_error_sprintf = 0
    has_file_sprintf = 0
    has_plane_mask = 0
    has_busy_flag = 0
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
    u = toupper(line)

    if (u ~ /^ESQIFF2_SHOWATTENTIONOVERLAY:/ || u ~ /^ESQIFF2_SHOWATTENTIONOVER[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "GLOBAL_UIBUSYFLAG") > 0 || index(u, "ED_DIAGNOSTICSSCREENACTIVE") > 0) has_ui_guard = 1
    if (index(u, "__SWITCH_ESQIFF2_SHOWATTENTIONOVERLAY_") > 0 || u ~ /^JMP \$[0-9A-F]+\(\PC,D[0-7]\.[WL]\)$/ || u ~ /^JMP \.LAB_0B28\+2\(PC,D[0-7]\.[WL]\)$/) has_jumptable = 1
    if (index(u, "DISABLE") > 0 || index(u, "ENABLE") > 0) has_disable_enable = 1
    if (index(u, "GLOBAL_REF_696_400_BITMAP") > 0 || u ~ /^MOVE\.L A3,\$4\(A[0-7]\)$/ || u ~ /^MOVE\.L -[0-9]+\(A5\),4\(A[0-7]\)$/) has_bitmap_swap = 1
    if (index(u, "RECTFILL") > 0) has_rectfill = 1
    if (index(u, "SETDRMD") > 0) has_setdrmd = 1
    if (index(u, "GLOBAL_STR_REPORT_ERROR_CODE_FOR") > 0 || index(u, "GLOBAL_STR_REPORT_ERROR_CODE_FORMATTED") > 0) has_error_sprintf = 1
    if (index(u, "GLOBAL_STR_FILE_WIDTH_COLORS_FOR") > 0 || index(u, "GLOBAL_STR_FILE_WIDTH_COLORS_FORMATTED") > 0 || index(u, "GLOBAL_STR_FILE_PERCENT_S") > 0) has_file_sprintf = 1
    if (index(u, "PLANEMASKFORINDEX") > 0 || index(u, "PLANEMASKFO") > 0) has_plane_mask = 1
    if (index(u, "COI_ATTENTIONOVERLAYBUSYFLAG") > 0) has_busy_flag = 1
    if (index(u, "DISPLAYTEXTATPOSITION") > 0 || index(u, "DISPLAYTE") > 0) has_display_text = 1
    if (u ~ /^BLE\.[SWB] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || u ~ /^BEQ\.[SWB] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || u ~ /^BRA\.[SWB] ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || u ~ /^JMP ESQIFF2_SHOWATTENTIONOVERLAY_RETURN$/ || u ~ /^BLE\.[SWB] ___ESQIFF2_SHOWATTENTIONOVERLAY__/ || u ~ /^BEQ\.[SWB] ___ESQIFF2_SHOWATTENTIONOVERLAY__/ || u == "RTS") has_return_branch = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_UI_GUARD=" has_ui_guard
    print "HAS_JUMPTABLE=" has_jumptable
    print "HAS_DISABLE_ENABLE=" has_disable_enable
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_ERROR_SPRINTF=" has_error_sprintf
    print "HAS_FILE_SPRINTF=" has_file_sprintf
    print "HAS_PLANE_MASK=" has_plane_mask
    print "HAS_BUSY_FLAG=" has_busy_flag
    print "HAS_DISPLAY_TEXT=" has_display_text
    print "HAS_RETURN_BRANCH=" has_return_branch
}
