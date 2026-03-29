BEGIN {
    has_label = 0
    template_source_pos = 0
    channel_code_pos = 0
    prepare_clock_pos = 0
    entry_scan_pos = 0
    entry_retry_cap_pos = 0
    override_state_pos = 0
    reset_indices_pos = 0
    disable_highlight_pos = 0
    copper_drop_pos = 0
    build_ctx_count = 0
    first_build_ctx_pos = 0
    second_build_ctx_pos = 0
    brush_select_pos = 0
    serial_shadow_pos = 0
    second_set_rast_pos = 0
    noop_pos = 0
    set_apen_pos = 0
    match_save_pos = 0
    empty_banner_pos = 0
    highlight_enable_count = 0
    first_highlight_enable_pos = 0
    second_highlight_enable_pos = 0
    selected_char_pos = 0
    fallback_char_pos = 0
    selected_match_write_pos = 0
    selected_clock_write_pos = 0
    short_name_pos = 0
    left_align_pos = 0
    append_count = 0
    now_showing_pos = 0
    next_showing_pos = 0
    tomorrow_pos = 0
    today_pos = 0
    tonight_pos = 0
    format_time_count = 0
    center_align_pos = 0
    build_channel_label_pos = 0
    build_status_line_pos = 0
    banner_reset_pos = 0
    pen_reset_pos = 0
    trim_pos = 0
    inset_pos = 0
    get_rast_pos = 0
    get_height_count = 0
    rect_fill_pos = 0
    blit_pos = 0
    copper_rise_pos = 0
    return_pos = 0
}

function mark_first(name, value) {
    if (value == 0) {
        return NR
    }
    return value
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

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/ ||
        u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (template_source_pos == 0 &&
        (u ~ /TEXTDISP_PRIMARYSEARCHTEXT/ || u ~ /TEXTDISP_SECONDARYSEARCHTEXT/)) {
        template_source_pos = NR
    }
    if (channel_code_pos == 0 &&
        (u ~ /TEXTDISP_PRIMARYCHANNELCODE/ || u ~ /TEXTDISP_SECONDARYCHANNELCODE/)) {
        channel_code_pos = NR
    }
    if (prepare_clock_pos == 0 &&
        (u ~ /CLEANUP3_PREPARECLOCKBUFFERS/ ||
         u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /STR_FINDCHARPTR/)) {
        prepare_clock_pos = NR
    }
    if (entry_scan_pos == 0 &&
        (u ~ /DISPLIB_NORMALIZEVALUEBYSTEP/ || u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLET/)) {
        entry_scan_pos = NR
    }
    if (entry_retry_cap_pos == 0 &&
        (u ~ /#60/ || u ~ /#\$3C/ || u ~ /\(\$3C\)\.W/)) {
        entry_retry_cap_pos = NR
    }
    if (override_state_pos == 0 &&
        (u ~ /MOVE.W #\$2,\$42\(A7\)/ || u ~ /MOVE.W #2,-40\(A5\)/)) {
        override_state_pos = NR
    }
    if (reset_indices_pos == 0 &&
        u ~ /CLEANUP_ALIGNEDSTATUSMATCHINDEX/ && u ~ /CLEANUP_ALIGNEDSTATUSCLOCKENTRYI/ &&
        (u ~ /#\\$FFFFFFFF/ || u ~ /#-1/)) {
        reset_indices_pos = NR
    }
    if (disable_highlight_pos == 0 &&
        (u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHI/ ||
         u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT/)) {
        disable_highlight_pos = NR
    }
    if (copper_drop_pos == 0 &&
        (u ~ /ESQIFF_RUNCOPPERDROPTRANSITION/ ||
         u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERDROPTRANS/)) {
        copper_drop_pos = NR
    }
    if (u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIE/ ||
        u ~ /GROUP_AD_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/) {
        build_ctx_count++
        if (first_build_ctx_pos == 0) {
            first_build_ctx_pos = NR
        } else if (second_build_ctx_pos == 0) {
            second_build_ctx_pos = NR
        }
    }
    if (brush_select_pos == 0 &&
        (u ~ /ESQFUNC_SELECTANDAPPLYBRUSHFORCU/ ||
         u ~ /GROUP_AD_JMPTBL_ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY/)) {
        brush_select_pos = NR
    }
    if (serial_shadow_pos == 0 &&
        (u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTR/ ||
         u ~ /GROUP_AD_JMPTBL_SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE/)) {
        serial_shadow_pos = NR
    }
    if (second_set_rast_pos == 0 && serial_shadow_pos != 0 &&
        u ~ /_LVOSETRAST/ && NR > serial_shadow_pos) {
        second_set_rast_pos = NR
    }
    if (noop_pos == 0 && u ~ /ESQ_NOOP/) {
        noop_pos = NR
    }
    if (set_apen_pos == 0 && u ~ /_LVOSETAPEN/) {
        set_apen_pos = NR
    }
    if (match_save_pos == 0 && u ~ /TEXTDISP_CURRENTMATCHINDEXSAVED/ &&
        u ~ /TEXTDISP_CURRENTMATCHINDEX/) {
        match_save_pos = NR
    }
    if (empty_banner_pos == 0 && u ~ /TEXTDISP_DRAWCHANNELBANNER/) {
        empty_banner_pos = NR
    }
    if (u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGH/ ||
        u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT/) {
        highlight_enable_count++
        if (first_highlight_enable_pos == 0) {
            first_highlight_enable_pos = NR
        } else if (second_highlight_enable_pos == 0) {
            second_highlight_enable_pos = NR
        }
    }
    if (selected_char_pos == 0 && u ~ /TEXTDISP_BANNERCHARSELECTED/) {
        selected_char_pos = NR
    }
    if (fallback_char_pos == 0 && u ~ /TEXTDISP_BANNERCHARFALLBACK/) {
        fallback_char_pos = NR
    }
    if (selected_match_write_pos == 0 && selected_char_pos > 0 &&
        u ~ /CLEANUP_ALIGNEDSTATUSMATCHINDEX/) {
        selected_match_write_pos = NR
    }
    if (selected_clock_write_pos == 0 && selected_match_write_pos > 0 &&
        u ~ /CLEANUP_ALIGNEDSTATUSCLOCKENTRYI/) {
        selected_clock_write_pos = NR
    }
    if (short_name_pos == 0 &&
        (u ~ /TEXTDISP_BUILDENTRYSHORTNAME/ ||
         u ~ /GROUP_AD_JMPTBL_TEXTDISP_BUILDENTRYSHORTNAME/)) {
        short_name_pos = NR
    }
    if (left_align_pos == 0 && u ~ /TEXTDISP_LEFTALIGNTOKEN/) {
        left_align_pos = NR
    }
    if (u ~ /STRING_APPENDATNULL/ || u ~ /GROUP_AI_JMPTBL_STRING_APPENDATNULL/) {
        append_count++
    }
    if (now_showing_pos == 0 && u ~ /GLOBAL_STR_ALIGNED_NOW_SHOWING/) {
        now_showing_pos = NR
    }
    if (next_showing_pos == 0 && u ~ /GLOBAL_STR_ALIGNED_NEXT_SHOWING/) {
        next_showing_pos = NR
    }
    if (tomorrow_pos == 0 && u ~ /GLOBAL_STR_ALIGNED_TOMORROW_AT/) {
        tomorrow_pos = NR
    }
    if (today_pos == 0 && u ~ /GLOBAL_STR_ALIGNED_TODAY_AT/) {
        today_pos = NR
    }
    if (tonight_pos == 0 && u ~ /GLOBAL_STR_ALIGNED_TONIGHT_AT/) {
        tonight_pos = NR
    }
    if (u ~ /TEXTDISP_FORMATENTRYTIME/ ||
        u ~ /GROUP_AD_JMPTBL_TEXTDISP_FORMATENTRYTIME/) {
        format_time_count++
    }
    if (center_align_pos == 0 && u ~ /TEXTDISP_CENTERALIGNTOKEN/) {
        center_align_pos = NR
    }
    if (build_channel_label_pos == 0 &&
        (u ~ /TEXTDISP_BUILDCHANNELLABEL/ ||
         u ~ /GROUP_AD_JMPTBL_TEXTDISP_BUILDCHANNELLABEL/)) {
        build_channel_label_pos = NR
    }
    if (build_status_line_pos == 0 && u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) {
        build_status_line_pos = NR
    }
    if (banner_reset_pos == 0 &&
        u ~ /TEXTDISP_BANNERCHARSELECTED/ && (u ~ /#\\$64/ || u ~ /#100/)) {
        banner_reset_pos = NR
    }
    if (pen_reset_pos == 0 &&
        u ~ /TEXTDISP_LINEPENOVERRIDESTATEWOR/ && u ~ /CLR.W/) {
        pen_reset_pos = NR
    }
    if (trim_pos == 0 &&
        (u ~ /TEXTDISP_TRIMTEXTTOPIXELWIDTH/ ||
         u ~ /GROUP_AD_JMPTBL_TEXTDISP_TRIMTEXTTOPIXELWIDTH/)) {
        trim_pos = NR
    }
    if (inset_pos == 0 &&
        (u ~ /TEXTDISP_DRAWINSETRECTFRAME/ ||
         u ~ /GROUP_AD_JMPTBL_TEXTDISP_DRAWINSETRECTFRAME/)) {
        inset_pos = NR
    }
    if (get_rast_pos == 0 &&
        (u ~ /TLIBA3_GETVIEWMODERASTPORT/ ||
         u ~ /GROUP_AD_JMPTBL_TLIBA3_GETVIEWMODERASTPORT/)) {
        get_rast_pos = NR
    }
    if (u ~ /TLIBA3_GETVIEWMODEHEIGHT/ ||
        u ~ /GROUP_AD_JMPTBL_TLIBA3_GETVIEWMODEHEIGHT/) {
        get_height_count++
    }
    if (rect_fill_pos == 0 && u ~ /_LVORECTFILL/) {
        rect_fill_pos = NR
    }
    if (blit_pos == 0 &&
        (u ~ /BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/ ||
         u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/)) {
        blit_pos = NR
    }
    if (copper_rise_pos == 0 &&
        (u ~ /ESQIFF_RUNCOPPERRISETRANSITION/ ||
         u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANS/)) {
        copper_rise_pos = NR
    }
    if (u == "RTS") {
        return_pos = NR
    }
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_TEMPLATE_AND_CHANNEL_SETUP=" (template_source_pos > 0 && channel_code_pos > template_source_pos)
    print "HAS_CLOCK_BUFFER_PREP_AFTER_TEMPLATE=" (prepare_clock_pos > channel_code_pos)
    print "HAS_ENTRY_SCAN_WITH_RETRY_CAP=" (entry_scan_pos > prepare_clock_pos && entry_retry_cap_pos > entry_scan_pos)
    print "HAS_TEMPLATE_OVERRIDE_AND_RESET_FLOW=" (override_state_pos > entry_scan_pos && reset_indices_pos > override_state_pos)
    print "HAS_PRE_DROP_DISPLAY_PHASE=" (copper_drop_pos > 0 && (disable_highlight_pos == 0 || disable_highlight_pos < copper_drop_pos))
    print "HAS_DUAL_CONTEXT_SETUP=" (build_ctx_count >= 2 && first_build_ctx_pos > copper_drop_pos && second_build_ctx_pos > first_build_ctx_pos)
    print "HAS_BRUSH_SERIAL_AND_CLEAR_PHASE=" (brush_select_pos > first_build_ctx_pos && serial_shadow_pos > second_build_ctx_pos &&
        second_set_rast_pos > serial_shadow_pos && noop_pos > second_set_rast_pos && set_apen_pos > noop_pos)
    print "HAS_EMPTY_TEMPLATE_FASTPATH=" (empty_banner_pos > match_save_pos && first_highlight_enable_pos >= empty_banner_pos)
    print "HAS_SELECTION_SOURCE_PATH=" (selected_char_pos > empty_banner_pos && fallback_char_pos >= selected_char_pos &&
        selected_match_write_pos > fallback_char_pos && selected_clock_write_pos >= selected_match_write_pos)
    print "HAS_SHORTNAME_PREFIX_APPEND_FLOW=" (short_name_pos > selected_clock_write_pos && left_align_pos > short_name_pos && append_count >= 6)
    print "HAS_SPECIAL_NOW_NEXT_SUFFIX_FLOW=" (now_showing_pos > left_align_pos && next_showing_pos > now_showing_pos && format_time_count >= 2)
    print "HAS_DAY_SUFFIX_FLOW=" (tomorrow_pos > now_showing_pos && today_pos > tomorrow_pos && tonight_pos > today_pos)
    print "HAS_CENTER_SUFFIX_FLOW=" (center_align_pos > left_align_pos)
    print "HAS_STATUS_LINE_REBUILD_PHASE=" (build_channel_label_pos > center_align_pos && build_status_line_pos > build_channel_label_pos)
    print "HAS_FINAL_DRAW_RESET_PHASE=" (banner_reset_pos > build_status_line_pos && pen_reset_pos >= banner_reset_pos &&
        trim_pos > pen_reset_pos && inset_pos > trim_pos)
    print "HAS_MODE2_FILL_AND_PRESENT=" (get_rast_pos > inset_pos && get_height_count >= 2 && rect_fill_pos > get_rast_pos &&
        second_highlight_enable_pos > rect_fill_pos && blit_pos > second_highlight_enable_pos && copper_rise_pos > blit_pos)
    print "HAS_RETURN=" (return_pos > copper_rise_pos)
}
