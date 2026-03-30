BEGIN {
    has_label = 0
    has_ui_busy_gate = 0
    has_clock_mode_compare = 0
    has_adjust24_call = 0
    has_extra_time_format = 0
    has_grid_time_format = 0
    setapen_count = 0
    rectfill_count = 0
    has_bevel_call = 0
    has_font_height_load = 0
    has_center_adjust = 0
    has_move_call = 0
    has_text_call = 0
    has_blt_call = 0
    has_const_35 = 0
    has_const_33 = 0
    has_const_34 = 0
    has_const_36 = 0
    has_const_192 = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWCLOCKBANNER[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GLOBAL_UIBUSYFLAG/ && u ~ /D0/ || u ~ /TST\.W GLOBAL_UIBUSYFLAG/) has_ui_busy_gate = 1
    if (u ~ /GLOBAL_REF_STR_USE_24_HR_CLOCK/ || u ~ /CMP\.B D1,D0/ || u ~ /CMP\.B .*#89/ || u ~ /CMP\.B .*#\$59/) has_clock_mode_compare = 1
    if (u ~ /PARSEINI_ADJUSTHOURSTO24HRFORMAT/ || u ~ /PARSEINI_ADJUSTH/) has_adjust24_call = 1
    if (u ~ /GLOBAL_STR_EXTRA_TIME_FORMAT/ && u ~ /WDISP_SPRINTF/ || u ~ /GLOBAL_STR_EXTRA_TIME_FORMAT/) has_extra_time_format = 1
    if (u ~ /GLOBAL_STR_GRID_TIME_FORMAT/ && u ~ /WDISP_SPRINTF/ || u ~ /GLOBAL_STR_GRID_TIME_FORMAT/) has_grid_time_format = 1
    if (u ~ /_LVOSETAPEN/) setapen_count++
    if (u ~ /_LVORECTFILL/) rectfill_count++
    if (u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/ || u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPR/) has_bevel_call = 1
    if (u ~ /MOVE\.L \$34\(A5\),A0/ || u ~ /MOVEA\.L 52\(A1\),A0/ || u ~ /MOVE\.W \$14\(A0\),D6/ || u ~ /MOVE\.W 26\(A0\),D0/) has_font_height_load = 1
    if (u ~ /ADDQ\.L #\$1,D0/ || u ~ /ADDQ\.L #1,D1/) has_center_adjust = 1
    if (u ~ /_LVOMOVE/) has_move_call = 1
    if (u ~ /_LVOTEXT/) has_text_call = 1
    if (u ~ /GRAPHICS_BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/) has_blt_call = 1
    if (u ~ /#35/ || u ~ /#\$23/ || u ~ /\(\$23\)\.W/) has_const_35 = 1
    if (u ~ /#33/ || u ~ /#\$21/ || u ~ /\(\$21\)\.W/) has_const_33 = 1
    if (u ~ /#34/ || u ~ /#\$22/ || u ~ /\(\$22\)\.W/) has_const_34 = 1
    if (u ~ /#36/ || u ~ /#\$24/ || u ~ /\(\$24\)\.W/) has_const_36 = 1
    if (u ~ /#192/ || u ~ /#\$C0/ || u ~ /\(\$C0\)\.W/ || u ~ /PEA 192\.W/ || u ~ /192\.W/) has_const_192 = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_UI_BUSY_GATE=" has_ui_busy_gate
    print "HAS_CLOCK_MODE_COMPARE=" has_clock_mode_compare
    print "HAS_ADJUST24_CALL=" has_adjust24_call
    print "HAS_EXTRA_TIME_FORMAT=" has_extra_time_format
    print "HAS_GRID_TIME_FORMAT=" has_grid_time_format
    print "SETAPEN_COUNT_AT_LEAST_3=" (setapen_count >= 3)
    print "RECTFILL_COUNT_AT_LEAST_2=" (rectfill_count >= 2)
    print "HAS_BEVEL_CALL=" has_bevel_call
    print "HAS_FONT_HEIGHT_LOAD=" has_font_height_load
    print "HAS_CENTER_ADJUST=" has_center_adjust
    print "HAS_MOVE_CALL=" has_move_call
    print "HAS_TEXT_CALL=" has_text_call
    print "HAS_BLT_CALL=" has_blt_call
    print "HAS_CONST_35=" has_const_35
    print "HAS_CONST_33=" has_const_33
    print "HAS_CONST_34=" has_const_34
    print "HAS_CONST_36=" has_const_36
    print "HAS_CONST_192=" has_const_192
    print "HAS_RETURN=" has_return
}
