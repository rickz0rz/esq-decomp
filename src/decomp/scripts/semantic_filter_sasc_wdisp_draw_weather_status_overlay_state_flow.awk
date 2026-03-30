BEGIN {
    has_entry = 0
    has_fallback_gate = 0
    has_fallback_source = 0
    has_fallback_draw = 0
    has_brush_lookup_switch = 0
    has_default_brush_size = 0
    has_overlay_dup = 0
    has_overlay_scan = 0
    has_leading_empty_skip = 0
    has_line_clamp = 0
    has_overlay_reset_draw_state = 0
    has_brush_palette_path = 0
    has_accumulator_copy_path = 0
    has_status_copy_or_clear = 0
    has_status_draw = 0
    has_multiline_metrics = 0
    has_multiline_break_guard = 0
    has_paired_trim_draw = 0
    has_cleanup_release = 0
    has_return = 0

    saw_countdown_ref = 0
    saw_digit_ref = 0
    saw_ascii_zero = 0
    saw_no_data_ptr = 0
    saw_current_msg_ptr = 0
    saw_fallback_pen = 0
    saw_fallback_move = 0
    saw_fallback_text = 0

    saw_brush_index = 0
    saw_predicate_head = 0
    saw_predicate_table = 0
    brush_find_count = 0
    saw_default_width = 0
    saw_default_height = 0

    saw_replace_owned = 0
    saw_overlay_ptr = 0
    saw_delim_24 = 0
    saw_linecount_inc = 0
    saw_leading_ptr_advance = 0
    saw_leading_count_dec = 0
    saw_clamp_10 = 0
    saw_set_rast = 0
    saw_set_font = 0
    saw_setapen1 = 0
    saw_setdrmd0 = 0

    saw_align_mode_writes = 0
    saw_plane_mask_const5 = 0
    saw_plane_depth_ref = 0
    plane_mask_count = 0
    saw_palette_copy_offset = 0
    saw_palette_target = 0
    saw_capture_set = 0
    saw_flush_clear = 0
    saw_capture_clear = 0
    saw_flush_set = 0
    saw_copymem = 0
    saw_row_count_4 = 0
    saw_row_size_8 = 0
    saw_select_brush = 0

    saw_status_ptr = 0
    saw_status_clear = 0
    saw_status_copy = 0
    saw_status_pen3 = 0

    saw_font_height_ref = 0
    saw_font_baseline_ref = 0
    saw_half_helper = 0
    saw_mul = 0
    saw_div = 0
    saw_trim = 0
    trim_count = 0
    text_length_count = 0
    move_count = 0
    text_count = 0
    saw_break_cmp_yspan = 0
    saw_first_line_minus_one = 0
    saw_second_line_plus_width = 0
    saw_second_line_from_xspan = 0
    saw_lineptr_advance = 0

    saw_pool_301 = 0
    saw_pool_tag = 0
    saw_dealloc = 0
    setapen_count = 0
    setdrmd_count = 0
    pending_pen_value = -1
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^WDISP_DRAWWEATHERSTATUSOVERLAY:/ ||
        line ~ /^WDISP_DRAWWEATHERSTATUSOVERLA[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (index(line, "WEATHERSTATUSCOUNTDOWN") > 0) saw_countdown_ref = 1
    if (index(line, "WEATHERSTATUSDIGITCHAR") > 0) saw_digit_ref = 1
    if (line ~ /#\$30|#48/) saw_ascii_zero = 1
    if (index(line, "P_TYPE_WEATHERCURRENTMSGPTR") > 0) saw_current_msg_ptr = 1
    if (index(line, "NO_CURRENT_WEATHE") > 0) saw_no_data_ptr = 1
    if (line ~ /^PEA \(\$1\)\.W$/ || line ~ /^PEA 1\.W$/ || line ~ /^MOVEQ(\.L)? #\$1,D0$/ || line ~ /^MOVEQ #1,D0$/) {
        saw_fallback_pen = 1
        pending_pen_value = 1
    }
    if (line ~ /^PEA \(\$3\)\.W$/ || line ~ /^PEA 3\.W$/ || line ~ /^MOVEQ(\.L)? #\$3,D0$/ || line ~ /^MOVEQ #3,D0$/) {
        pending_pen_value = 3
    }
    if (index(line, "_LVOMOVE") > 0) {
        move_count++
        if (saw_fallback_pen && move_count >= 1) saw_fallback_move = 1
    }
    if (line ~ /_LVOTEXT(\(| |$)/ && line !~ /_LVOTEXTLENGTH/) {
        text_count++
        if (saw_fallback_move && text_count >= 1) saw_fallback_text = 1
    }

    if (index(line, "WEATHERSTATUSBRUSHINDEX") > 0) saw_brush_index = 1
    if (index(line, "WEATHERBRUSHPREDICATENAM") > 0) saw_predicate_head = 1
    if (index(line, "ESQFUNC_STR_I5") > 0) saw_predicate_table = 1
    if (index(line, "FINDBRUSHBYPREDICATE") > 0) brush_find_count++
    if (line ~ /#\$AA|#170/ || index(line, "MOVEQ.L #$55") > 0) saw_default_width = 1
    if (line ~ /#\$5A|#90/) saw_default_height = 1

    if (index(line, "REPLACEOWNEDSTRING") > 0) saw_replace_owned = 1
    if (index(line, "WEATHERSTATUSOVERLAYTEXTPT") > 0) saw_overlay_ptr = 1
    if (line ~ /#\$18|#24/) saw_delim_24 = 1
    if (line ~ /^ADDQ\.L #\$1,\$54\(A7\)$/ || line ~ /^ADDQ\.L #1,-152\(A5\)$/) saw_linecount_inc = 1
    if (line ~ /^ADDQ\.L #\$1,\$E8\(A7\)$/ || line ~ /^ADDQ\.L #1,-12\(A5\)$/) saw_leading_ptr_advance = 1
    if (line ~ /^SUBQ\.L #\$1,\$54\(A7\)$/ || line ~ /^SUBQ\.L #1,-152\(A5\)$/) saw_leading_count_dec = 1
    if (line ~ /#\$A/ || line ~ /#10([^0-9]|$)/) saw_clamp_10 = 1

    if (index(line, "_LVOSETRAST") > 0) saw_set_rast = 1
    if (index(line, "_LVOSETFONT") > 0) saw_set_font = 1
    if (index(line, "_LVOSETAPEN") > 0) {
        setapen_count++
        if (pending_pen_value == 1) saw_setapen1 = 1
        if (pending_pen_value == 3) saw_status_pen3 = 1
        pending_pen_value = -1
    }
    if (index(line, "_LVOSETDRMD") > 0) {
        saw_setdrmd0 = 1
        setdrmd_count++
    }

    if (line ~ /356\(A0\)|360\(A0\)|\$164\(A3\)|\$168\(A3\)/) saw_align_mode_writes++
    if (index(line, "BRUSH_PLANEMASKFORINDEX") > 0) plane_mask_count++
    if (line ~ /^PEA \(\$5\)\.W$/ || line ~ /^PEA 5\.W$/) saw_plane_mask_const5 = 1
    if (line ~ /184\(A0\)|\$B8\(A3\)/) saw_plane_depth_ref = 1
    if (line ~ /#\$E8|#232/ || line ~ /ADDI\.L #\$E8,D0/ || line ~ /ADD\.L #\$E8,D1/) saw_palette_copy_offset = 1
    if (index(line, "WDISP_PALETTETRIPLESRBASE") > 0) saw_palette_target = 1
    if (index(line, "ACCUMULATORCAPTUREACTIVE") > 0 && line ~ /#\$1|#1/) saw_capture_set = 1
    if (index(line, "ACCUMULATORFLUSHPENDING") > 0 && index(line, "CLR.W") == 1) saw_flush_clear = 1
    if (index(line, "ACCUMULATORCAPTUREACTIVE") > 0 && index(line, "CLR.W") == 1) saw_capture_clear = 1
    if (index(line, "ACCUMULATORFLUSHPENDING") > 0 && line ~ /#\$1|#1/) saw_flush_set = 1
    if (index(line, "_LVOCOPYMEM") > 0) saw_copymem = 1
    if (line ~ /^MOVEQ(\.L)? #\$4,D1$/ || line ~ /^MOVEQ #4,D1$/) saw_row_count_4 = 1
    if (line ~ /^PEA \(\$8\)\.W$/ || line ~ /^MOVEQ #8,D0$/ || line ~ /^MOVEQ\.L #\$8,D0$/) saw_row_size_8 = 1
    if (index(line, "SELECTBRUSHSLOT") > 0) saw_select_brush = 1

    if (index(line, "WEATHERSTATUSTEXTPTR") > 0) saw_status_ptr = 1
    if (line ~ /^CLR\.B \$60\(A7\)$/ || line ~ /^CLR\.B -140\(A5\)$/) saw_status_clear = 1
    if (line ~ /^MOVE\.B \(A0\),\(A1\)\+$/ || line ~ /^MOVE\.B \(A0\)\+,\(A1\)\+$/) saw_status_copy = 1

    if (index(line, "_LVOTEXTLENGTH") > 0) text_length_count++
    if (line ~ /20\(A0\)|26\(A0\)|\$14\(A0\)|\$1A\(A0\)|\$14,A0|\$1A,A0/) {
        if (line ~ /20\(A0\)|\$14\(A0\)|\$14,A0/) saw_font_height_ref = 1
        if (line ~ /26\(A0\)|\$1A\(A0\)|\$1A,A0/) saw_font_baseline_ref = 1
    }
    if (index(line, "HALF_TOWARD_ZERO") > 0 || line ~ /ASR\.L #1/ || line ~ /ASR\.L #\$1/) saw_half_helper = 1
    if (index(line, "MATH_MULU32") > 0) saw_mul++
    if (index(line, "MATH_DIVS32") > 0) saw_div++
    if (index(line, "TRIMTEXTTOPIXELWIDTHWORD") > 0 || index(line, "TRIMTEXTTOPIXELWIDTHWOR") > 0) {
        saw_trim = 1
        trim_count++
    }
    if (index(line, "CMP.L D6,D1") > 0 || index(line, "CMP.L D6,D2") > 0) saw_break_cmp_yspan = 1
    if (line ~ /^SUBQ\.L #\$1,D1$/ || line ~ /^SUBQ\.L #1,D1$/) saw_first_line_minus_one = 1
    if (index(line, "ADD.L D0,D1") > 0) saw_second_line_plus_width = 1
    if ((index(line, "MOVE.L D7,D1") > 0 || index(line, "MOVE.L D7,D2") > 0) && saw_second_line_plus_width) {
        saw_second_line_from_xspan = 1
    }
    if (line ~ /^MOVE\.B \(A0\)\+,D0$/ || line ~ /^TST\.B \(A0\)\+$/) saw_lineptr_advance = 1

    if (line ~ /\(\$12D\)\.W/ || line ~ /301\.W/ || line ~ /#\$12D|#301/) saw_pool_301 = 1
    if (index(line, "GLOBAL_STR_WDISP_C") > 0) saw_pool_tag = 1
    if (index(line, "MEMORY_DEALLOCATEMEMORY") > 0) saw_dealloc = 1

    if (line == "RTS") has_return = 1
}

END {
    has_fallback_gate = (saw_countdown_ref && saw_digit_ref && saw_ascii_zero)
    has_fallback_source = (saw_current_msg_ptr && saw_no_data_ptr)
    has_fallback_draw = (saw_fallback_pen && saw_fallback_move && saw_fallback_text && text_length_count >= 1)
    has_brush_lookup_switch = (saw_brush_index && saw_predicate_head && saw_predicate_table && brush_find_count == 2)
    has_default_brush_size = (saw_default_width && saw_default_height)
    has_overlay_dup = (saw_replace_owned && saw_overlay_ptr)
    has_overlay_scan = (saw_delim_24 && saw_linecount_inc)
    has_leading_empty_skip = (saw_leading_ptr_advance && saw_leading_count_dec)
    has_line_clamp = saw_clamp_10
    has_overlay_reset_draw_state = (saw_set_rast && saw_set_font && saw_setapen1 && saw_setdrmd0 &&
        setapen_count == 4 && setdrmd_count == 4)
    has_brush_palette_path = (saw_align_mode_writes >= 2 && saw_plane_mask_const5 && saw_plane_depth_ref &&
        plane_mask_count == 2 && saw_palette_copy_offset && saw_palette_target)
    has_accumulator_copy_path = (saw_capture_set && saw_flush_clear && saw_capture_clear && saw_flush_set &&
        saw_copymem && saw_row_count_4 && saw_row_size_8 && saw_select_brush)
    has_status_copy_or_clear = (saw_status_ptr && saw_status_clear && saw_status_copy)
    has_status_draw = (saw_status_pen3 && text_length_count >= 2 && move_count >= 2 && text_count >= 2)
    has_multiline_metrics = (saw_font_height_ref && saw_font_baseline_ref && saw_half_helper && saw_mul >= 2 && saw_div >= 1)
    has_multiline_break_guard = saw_break_cmp_yspan
    has_paired_trim_draw = (saw_trim && trim_count == 2 && text_length_count == 4 && move_count == 4 &&
        text_count == 4 && saw_first_line_minus_one && saw_second_line_plus_width &&
        saw_second_line_from_xspan && saw_lineptr_advance)
    has_cleanup_release = (saw_pool_301 && saw_pool_tag && saw_dealloc)

    print "HAS_ENTRY=" has_entry
    print "HAS_FALLBACK_GATE=" has_fallback_gate
    print "HAS_FALLBACK_SOURCE=" has_fallback_source
    print "HAS_FALLBACK_DRAW=" has_fallback_draw
    print "HAS_BRUSH_LOOKUP_SWITCH=" has_brush_lookup_switch
    print "HAS_DEFAULT_BRUSH_SIZE=" has_default_brush_size
    print "HAS_OVERLAY_DUP=" has_overlay_dup
    print "HAS_OVERLAY_SCAN=" has_overlay_scan
    print "HAS_LEADING_EMPTY_SKIP=" has_leading_empty_skip
    print "HAS_LINE_CLAMP=" has_line_clamp
    print "HAS_OVERLAY_RESET_DRAW_STATE=" has_overlay_reset_draw_state
    print "HAS_BRUSH_PALETTE_PATH=" has_brush_palette_path
    print "HAS_ACCUMULATOR_COPY_PATH=" has_accumulator_copy_path
    print "HAS_STATUS_COPY_OR_CLEAR=" has_status_copy_or_clear
    print "HAS_STATUS_DRAW=" has_status_draw
    print "HAS_MULTILINE_METRICS=" has_multiline_metrics
    print "HAS_MULTILINE_BREAK_GUARD=" has_multiline_break_guard
    print "HAS_PAIRED_TRIM_DRAW=" has_paired_trim_draw
    print "HAS_CLEANUP_RELEASE=" has_cleanup_release
    print "HAS_RETURN=" has_return
}
