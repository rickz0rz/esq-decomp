BEGIN {
    has_any_label = 0
    has_primary_template = 0
    has_secondary_template = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_alt_time_buffer = 0
    has_normalize_cycle = 0
    has_entry_cycle_table = 0
    has_retry_cap_60 = 0
    has_primary_line_head = 0
    has_primary_line_tail = 0
    has_match_index = 0
    has_clock_entry_index = 0
    has_status_suffix = 0
    has_current_match_saved = 0
    has_context_base = 0
    has_set_rast = 0
    has_left_align = 0
    has_center_align = 0
    has_short_name = 0
    has_get_entry = 0
    has_draw_channel_banner = 0
    has_format_entry_time = 0
    has_now_showing = 0
    has_next_showing = 0
    has_tomorrow_label = 0
    has_today_label = 0
    has_tonight_label = 0
    has_build_channel_label = 0
    has_channel_label_ready = 0
    has_trim_text = 0
    has_draw_inset = 0
    has_get_rast_port = 0
    get_height_count = 0
    build_context_count = 0
    has_select_brush = 0
    has_update_serial_shadow = 0
    has_rect_fill = 0
    has_build_status_line = 0
    has_blit = 0
    has_copper_drop = 0
    has_copper_rise = 0
    has_enable_highlight = 0
    has_disable_highlight = 0
    has_pen_override = 0
    has_banner_char_reset = 0
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

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/ || u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_any_label = 1
    if (u ~ /TEXTDISP_PRIMARYSEARCHTEXT/) has_primary_template = 1
    if (u ~ /TEXTDISP_SECONDARYSEARCHTEXT/) has_secondary_template = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/ || u ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIB/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOC/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVI/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/) has_build_clock_entry = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSALTTIMEBUFF/) has_alt_time_buffer = 1
    if (u ~ /DISPLIB_NORMALIZEVALUEBYSTEP/) has_normalize_cycle = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSENTRYCYCLET/) has_entry_cycle_table = 1
    if (u ~ /#60/ || u ~ /#\$3C/ || u ~ /\(\$3C\)\.W/) has_retry_cap_60 = 1
    if (u ~ /ESQIFF_PRIMARYLINEHEADPTR/) has_primary_line_head = 1
    if (u ~ /ESQIFF_PRIMARYLINETAILPTR/) has_primary_line_tail = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSMATCHINDEX/) has_match_index = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSCLOCKENTRYI/) has_clock_entry_index = 1
    if (u ~ /CLEANUP_ALIGNEDSTATUSSUFFIXBUFF/) has_status_suffix = 1
    if (u ~ /TEXTDISP_CURRENTMATCHINDEXSAVED/) has_current_match_saved = 1
    if (u ~ /WDISP_DISPLAYCONTEXTBASE/) has_context_base = 1
    if (u ~ /_LVOSETRAST/) has_set_rast = 1
    if (u ~ /TEXTDISP_LEFTALIGNTOKEN/) has_left_align = 1
    if (u ~ /TEXTDISP_CENTERALIGNTOKEN/) has_center_align = 1
    if (u ~ /TEXTDISP_BUILDENTRYSHORTNAME/) has_short_name = 1
    if (u ~ /ESQDISP_GETENTRYPOINTERBYMODE/) has_get_entry = 1
    if (u ~ /TEXTDISP_DRAWCHANNELBANNER/) has_draw_channel_banner = 1
    if (u ~ /TEXTDISP_FORMATENTRYTIME/) has_format_entry_time = 1
    if (u ~ /GLOBAL_STR_ALIGNED_NOW_SHOWING/) has_now_showing = 1
    if (u ~ /GLOBAL_STR_ALIGNED_NEXT_SHOWING/) has_next_showing = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TOMORROW_AT/) has_tomorrow_label = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TODAY_AT/) has_today_label = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TONIGHT_AT/) has_tonight_label = 1
    if (u ~ /TEXTDISP_BUILDCHANNELLABEL/) has_build_channel_label = 1
    if (u ~ /TEXTDISP_CHANNELLABELREADYFLAG/) has_channel_label_ready = 1
    if (u ~ /TEXTDISP_TRIMTEXTTOPIXELWIDTH/ || u ~ /TEXTDISP_TRIMTEXTTOPIXELW/) has_trim_text = 1
    if (u ~ /TEXTDISP_DRAWINSETRECTFRAME/ || u ~ /TEXTDISP_DRAWINSETRECTFRA/) has_draw_inset = 1
    if (u ~ /TLIBA3_GETVIEWMODERASTPORT/) has_get_rast_port = 1
    if (u ~ /TLIBA3_GETVIEWMODEHEIGHT/) get_height_count++
    if (u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/ || u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIE/ || u ~ /GROUP_AD_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/ || u ~ /GROUP_AD_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIE/) build_context_count++
    if (u ~ /ESQFUNC_SELECTANDAPPLYBRUSHFORCU/ || u ~ /GROUP_AD_JMPTBL_ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY/ || u ~ /GROUP_AD_JMPTBL_ESQFUNC_SELECTANDAPPLYBRUSHFORCU/) has_select_brush = 1
    if (u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTR/ || u ~ /GROUP_AD_JMPTBL_SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE/) has_update_serial_shadow = 1
    if (u ~ /_LVORECTFILL/) has_rect_fill = 1
    if (u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_status_line = 1
    if (u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTP/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/) has_blit = 1
    if (u ~ /ESQIFF_RUNCOPPERDROPTRANSITION/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERDROPTRANSITION/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERDROPTRANS/) has_copper_drop = 1
    if (u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANS/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPER/ || u ~ /ESQIFF_RUNCOPPERRISETRANSITION/) has_copper_rise = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT/ || u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGH/) has_enable_highlight = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT/ || u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHI/) has_disable_highlight = 1
    if (u ~ /TEXTDISP_LINEPENOVERRIDESTATEWOR/ || u ~ /TEXTDISP_LINEPENOVERRIDEENABLEDF/ ||
        u ~ /TEXTDISP_LINEPENOVERRIDESTATEWORD/ || u ~ /TEXTDISP_LINEPENOVERRIDEENABLEDFLAG/) has_pen_override = 1
    if (u ~ /TEXTDISP_BANNERCHARSELECTED/ && (u ~ /#100/ || u ~ /#\$64/ || u ~ /CLEANUP3_BANNER_CHAR_NONE/)) has_banner_char_reset = 1
    if (u ~ /TEXTDISP_BANNERCHARFALLBACK/ && (u ~ /#49/ || u ~ /#\$31/ || u ~ /'1'/)) has_banner_char_reset = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ANY_LABEL=" has_any_label
    print "HAS_TEMPLATE_SOURCE_SELECTION=" (has_primary_template && has_secondary_template)
    print "HAS_PREPARE_CLOCK_BUFFERS=" (has_find_char && has_build_clock_entry && has_alt_time_buffer)
    print "HAS_ENTRY_CYCLE_SCAN=" (has_normalize_cycle && has_entry_cycle_table)
    print "HAS_ENTRY_SCAN_RETRY_CAP=" has_retry_cap_60
    print "HAS_FGNO_TEMPLATE_PATHS=" (has_primary_line_head && has_primary_line_tail && has_match_index && has_clock_entry_index)
    print "HAS_STATUS_STATE_GLOBALS=" (has_status_suffix && has_current_match_saved)
    print "HAS_CONTEXT_CLEAR_AND_DROP=" (has_context_base && has_set_rast && has_copper_drop)
    print "HAS_CONTEXT_SWITCHES=" (build_context_count >= 2)
    print "HAS_BRUSH_AND_SERIAL_SETUP=" (has_select_brush && has_update_serial_shadow)
    print "HAS_EMPTY_BANNER_FASTPATH=" (has_draw_channel_banner && has_enable_highlight && has_status_suffix)
    print "HAS_SELECTION_AND_SHORTNAME_PATH=" (has_short_name && has_get_entry && has_left_align)
    print "HAS_SPECIAL_SUFFIX_PATH=" (has_format_entry_time && has_now_showing && has_next_showing)
    print "HAS_DAY_SUFFIX_PATH=" (has_format_entry_time && has_tomorrow_label && has_today_label && has_tonight_label)
    print "HAS_CENTER_SUFFIX_PATH=" has_center_align
    print "HAS_STATUS_LINE_REBUILD=" (has_build_channel_label && has_channel_label_ready && has_build_status_line)
    print "HAS_BANNER_CHAR_RESET=" has_banner_char_reset
    print "HAS_FINAL_TEXT_DRAW_SETUP=" (has_pen_override && has_trim_text && has_draw_inset)
    print "HAS_MODE2_FILL=" (has_get_rast_port && get_height_count >= 2 && has_rect_fill)
    print "HAS_BLIT_AND_COPPER_RISE=" (has_blit && has_copper_rise)
    print "HAS_PRE53_DISABLE_HIGHLIGHT=" has_disable_highlight
    print "HAS_RETURN=" has_return
}
