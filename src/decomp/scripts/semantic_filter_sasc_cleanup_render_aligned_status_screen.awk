BEGIN {
    has_any_label = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_normalize_cycle = 0
    has_primary_line_head = 0
    has_primary_line_tail = 0
    has_build_short_name = 0
    has_draw_channel_banner = 0
    has_format_entry_time = 0
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
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/ || u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_any_label = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/ || u ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIB/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOC/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVI/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/) has_build_clock_entry = 1
    if (u ~ /DISPLIB_NORMALIZEVALUEBYSTEP/) has_normalize_cycle = 1
    if (u ~ /ESQIFF_PRIMARYLINEHEADPTR/) has_primary_line_head = 1
    if (u ~ /ESQIFF_PRIMARYLINETAILPTR/) has_primary_line_tail = 1
    if (u ~ /TEXTDISP_BUILDENTRYSHORTNAME/) has_build_short_name = 1
    if (u ~ /TEXTDISP_DRAWCHANNELBANNER/) has_draw_channel_banner = 1
    if (u ~ /TEXTDISP_FORMATENTRYTIME/) has_format_entry_time = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TOMORROW_AT/) has_tomorrow_label = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TODAY_AT/) has_today_label = 1
    if (u ~ /GLOBAL_STR_ALIGNED_TONIGHT_AT/) has_tonight_label = 1
    if (u ~ /TEXTDISP_BUILDCHANNELLABEL/) has_build_channel_label = 1
    if (u ~ /TEXTDISP_CHANNELLABELREADYFLAG/) has_channel_label_ready = 1
    if (u ~ /TEXTDISP_TRIMTEXTTOPIXELWIDTH/) has_trim_text = 1
    if (u ~ /TEXTDISP_DRAWINSETRECTFRAME/) has_draw_inset = 1
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
    if (u == "RTS") has_return = 1
}
END {
    if (has_find_char && has_build_clock_entry) {
        has_prepare_clock_buffers = 1
    }
    print "HAS_ANY_LABEL=" has_any_label
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_PREPARE_CLOCK_BUFFERS=" has_prepare_clock_buffers
    print "HAS_BUILD_CLOCK_ENTRY=" has_build_clock_entry
    print "HAS_NORMALIZE_CYCLE=" has_normalize_cycle
    print "HAS_PRIMARY_LINE_HEAD=" has_primary_line_head
    print "HAS_PRIMARY_LINE_TAIL=" has_primary_line_tail
    print "HAS_BUILD_SHORT_NAME=" has_build_short_name
    print "HAS_DRAW_CHANNEL_BANNER=" has_draw_channel_banner
    print "HAS_FORMAT_ENTRY_TIME=" has_format_entry_time
    print "HAS_TOMORROW_LABEL=" has_tomorrow_label
    print "HAS_TODAY_LABEL=" has_today_label
    print "HAS_TONIGHT_LABEL=" has_tonight_label
    print "HAS_BUILD_CHANNEL_LABEL=" has_build_channel_label
    print "HAS_CHANNEL_LABEL_READY=" has_channel_label_ready
    print "HAS_TRIM_TEXT=" has_trim_text
    print "HAS_DRAW_INSET=" has_draw_inset
    print "HAS_GET_RAST_PORT=" has_get_rast_port
    print "HAS_GET_HEIGHT_MULTI=" (get_height_count >= 2)
    print "HAS_BUILD_CONTEXT_MULTI=" (build_context_count >= 2)
    print "HAS_SELECT_BRUSH=" has_select_brush
    print "HAS_UPDATE_SERIAL_SHADOW=" has_update_serial_shadow
    print "HAS_RECT_FILL=" has_rect_fill
    print "HAS_BUILD_STATUS_LINE=" has_build_status_line
    print "HAS_BLIT=" has_blit
    print "HAS_COPPER_DROP=" has_copper_drop
    print "HAS_COPPER_RISE=" has_copper_rise
    print "HAS_ENABLE_HIGHLIGHT=" has_enable_highlight
    print "HAS_DISABLE_HIGHLIGHT=" has_disable_highlight
    print "HAS_RETURN=" has_return
}
