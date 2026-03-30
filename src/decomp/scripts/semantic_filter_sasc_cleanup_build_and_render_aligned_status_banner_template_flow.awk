BEGIN {
    has_entry_label = 0
    has_alias_label = 0
    has_retry_loop = 0
    has_retry_cap = 0
    has_cycle_store = 0
    has_mode53_disable = 0
    has_slot0_brush = 0
    has_slot1_clear = 0
    has_empty_banner_path = 0
    has_selected_special_suffix = 0
    has_selected_time_suffix = 0
    has_centered_schedule_suffix = 0
    has_code_f_head_path = 0
    has_code_g_tail_path = 0
    has_code_n_clock_path = 0
    has_code_o_alt_path = 0
    has_line_build = 0
    has_trim_draw = 0
    has_mid_fill = 0
    has_blit_rise = 0
    has_return = 0

    saw_normalize_step = 0
    saw_cycle_table = 0
    saw_cycle_store = 0
    saw_cycle_entry_ptr = 0
    saw_cycle_copy = 0
    saw_head_ptr = 0
    saw_tail_ptr = 0
    saw_clock_buffer = 0
    saw_alt_buffer = 0
    saw_now_showing = 0
    saw_next_showing = 0
    saw_compute_banner_index = 0
    saw_adjust_month = 0
    saw_normalize_month = 0
    saw_today = 0
    saw_tonight = 0
    saw_tomorrow = 0
    saw_center_token = 0
    saw_schedule_table = 0
    saw_build_channel_label = 0
    saw_build_status_line = 0
    saw_mode53 = 0
    saw_disable = 0
    saw_slot0_brush = 0
    saw_slot1_clear = 0
    saw_empty_banner = 0
    saw_highlight_enable = 0
    saw_trim = 0
    saw_frame = 0
    saw_get_rast = 0
    saw_get_height = 0
    saw_rect_fill = 0
    saw_blit = 0
    saw_rise = 0
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

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/) has_entry_label = 1
    if (u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_alias_label = 1

    if (u ~ /DISPLIB_NORMALIZEVALUEBYSTEP/) saw_normalize_step = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLET/ || u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLETABLE/) saw_cycle_table = 1
    if (saw_normalize_step && saw_cycle_table) has_retry_loop = 1
    if (u ~ /#60/ || u ~ /#\$3C/ || u ~ /PEA \(\$3C\)\.W/) has_retry_cap = 1
    if (((u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLET/ || u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLETABLE/) &&
         u ~ /MOVE\.W /) ||
        u ~ /MOVE\.W D[0-7],\$0\(A0,D[0-7]\.L\)/ ||
        u ~ /MOVE\.W D[0-7],\(A1\)/) {
        saw_cycle_store = 1
    }
    if (u ~ /LEA \$38\(A0\),A1/ || u ~ /MOVEA?\.L 56\(A0,D[0-7]\.L\),A0/ || u ~ /MOVE\.L \(A1\),-\(A7\)/) {
        saw_cycle_entry_ptr = 1
    }
    if (u ~ /CLEANUP3_COPYSTRING/ || u ~ /MOVE\.B \(A0\)\+,\(A1\)\+/) {
        saw_cycle_copy = 1
    }
    if (saw_cycle_store && saw_cycle_entry_ptr && saw_cycle_copy) has_cycle_store = 1

    if (u ~ /#53/ || u ~ /#\$35/ || u ~ /PEA \(\$35\)\.W/) saw_mode53 = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHIGH/ || u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHI/) saw_disable = 1
    if (saw_mode53 && saw_disable) has_mode53_disable = 1

    if (u ~ /ESQFUNC_SELECTANDAPPLYBRUSHFORCU/) saw_slot0_brush = 1
    if (u ~ /_LVOSETRAST/) saw_slot1_clear = 1
    if (saw_slot0_brush) has_slot0_brush = 1
    if (saw_slot1_clear) has_slot1_clear = 1

    if (u ~ /TEXTDISP_DRAWCHANNELBANNER/) saw_empty_banner = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGH/) saw_highlight_enable = 1
    if (saw_empty_banner && saw_highlight_enable) has_empty_banner_path = 1

    if (u ~ /ESQIFF_PRIMARYLINEHEADPTR/) saw_head_ptr = 1
    if (u ~ /ESQIFF_PRIMARYLINETAILPTR/) saw_tail_ptr = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSCLOCKENTRYB/ || u ~ /CLEANUP_ALIGNEDSTATUSCLOCKENTRYBUFFER/) saw_clock_buffer = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSALTTIMEBUFF/ || u ~ /CLEANUP_ALIGNEDSTATUSALTTIMEBUFFER/) saw_alt_buffer = 1

    if (saw_head_ptr && saw_clock_buffer) has_code_f_head_path = 1
    if (saw_tail_ptr && saw_clock_buffer) has_code_g_tail_path = 1
    if (saw_clock_buffer) has_code_n_clock_path = 1
    if (saw_alt_buffer) has_code_o_alt_path = 1

    if (u ~ /ALIGNED_NOW_SHOWING/) saw_now_showing = 1
    if (u ~ /ALIGNED_NEXT_SHOWING/) saw_next_showing = 1
    if (saw_now_showing && saw_next_showing && u ~ /TEXTDISP_FORMATENTRYTIME/) has_selected_special_suffix = 1

    if (u ~ /DST_COMPUTEBANNERINDEX/) saw_compute_banner_index = 1
    if (u ~ /DATETIME_ADJUSTMONTHINDEX/) saw_adjust_month = 1
    if (u ~ /DATETIME_NORMALIZEMONTHRANGE/) saw_normalize_month = 1
    if (u ~ /ALIGNED_TODAY_AT/) saw_today = 1
    if (u ~ /ALIGNED_TONIGHT_AT/) saw_tonight = 1
    if (u ~ /ALIGNED_TOMORROW_AT/) saw_tomorrow = 1
    if (saw_compute_banner_index && saw_adjust_month && saw_normalize_month &&
        saw_today && saw_tonight && saw_tomorrow) has_selected_time_suffix = 1

    if (u ~ /TEXTDISP_CENTERALIGNTOKEN/) saw_center_token = 1
    if (u ~ /SCRIPT_STRCHANNELLABEL_TUESDAYSF/ || u ~ /SCRIPT_STRCHANNELLABEL_TUESDAYSFRIDAYS/) saw_schedule_table = 1
    if (saw_center_token && saw_schedule_table) has_centered_schedule_suffix = 1

    if (u ~ /TEXTDISP_BUILDCHANNELLABEL/) saw_build_channel_label = 1
    if (u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) saw_build_status_line = 1
    if (saw_build_channel_label && saw_build_status_line) has_line_build = 1

    if (u ~ /TEXTDISP_TRIMTEXTTOPIXELW/) saw_trim = 1
    if (u ~ /TEXTDISP_DRAWINSETRECTFRA/) saw_frame = 1
    if (saw_trim && saw_frame) has_trim_draw = 1

    if (u ~ /TLIBA3_GETVIEWMODERASTPORT/) saw_get_rast = 1
    if (u ~ /TLIBA3_GETVIEWMODEHEIGHT/) saw_get_height = 1
    if (u ~ /_LVORECTFILL/) saw_rect_fill = 1
    if (saw_get_rast && saw_get_height && saw_rect_fill) has_mid_fill = 1

    if (u ~ /BLTBITMAPRASTP/ || u ~ /BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/) saw_blit = 1
    if (u ~ /ESQIFF_RUNCOPPERRISETRANS/ || u ~ /ESQIFF_RUNCOPPERRISETRA/) saw_rise = 1
    if (saw_blit && saw_rise) has_blit_rise = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY_LABEL=" has_entry_label
    print "HAS_ALIAS_LABEL=" has_alias_label
    print "HAS_RETRY_LOOP=" has_retry_loop
    print "HAS_RETRY_CAP=" has_retry_cap
    print "HAS_CYCLE_STORE=" has_cycle_store
    print "HAS_MODE53_DISABLE=" has_mode53_disable
    print "HAS_SLOT0_BRUSH=" has_slot0_brush
    print "HAS_SLOT1_CLEAR=" has_slot1_clear
    print "HAS_EMPTY_BANNER_PATH=" has_empty_banner_path
    print "HAS_CODE_F_HEAD_PATH=" has_code_f_head_path
    print "HAS_CODE_G_TAIL_PATH=" has_code_g_tail_path
    print "HAS_CODE_N_CLOCK_PATH=" has_code_n_clock_path
    print "HAS_CODE_O_ALT_PATH=" has_code_o_alt_path
    print "HAS_SELECTED_SPECIAL_SUFFIX=" has_selected_special_suffix
    print "HAS_SELECTED_TIME_SUFFIX=" has_selected_time_suffix
    print "HAS_CENTERED_SCHEDULE_SUFFIX=" has_centered_schedule_suffix
    print "HAS_LINE_BUILD=" has_line_build
    print "HAS_TRIM_DRAW=" has_trim_draw
    print "HAS_MID_FILL=" has_mid_fill
    print "HAS_BLIT_RISE=" has_blit_rise
    print "HAS_RETURN=" has_return
}
