BEGIN {
    has_label = 0
    has_alias = 0
    has_source_mode_write = 0
    has_flush_clear = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_build_status_line = 0
    has_build_channel_label = 0
    has_disable_highlight = 0
    has_brush_select = 0
    has_drop = 0
    has_viewmode_build = 0
    has_dual_viewmode_build = 0
    has_serial_shadow = 0
    has_noop = 0
    has_banner_or_short_name = 0
    has_suffix_path = 0
    has_match_index_saved = 0
    has_banner_char_reset = 0
    has_pen_override = 0
    has_trim_and_frame = 0
    has_mode2_rast_fill = 0
    has_blit = 0
    has_copper_rise = 0
    has_return = 0
    has_empty_template_banner = 0
    has_special_now_next_path = 0
    has_time_phrase_path = 0
    has_centered_schedule_suffix = 0
    set_rast_count = 0
    set_drmode_count = 0
    viewmode_build_count = 0
    viewmode_height_count = 0
    format_entry_time_count = 0
    saw_trim = 0
    saw_frame = 0
    saw_draw_banner = 0
    saw_copper_enable = 0
    saw_special_flag = 0
    saw_valid_flag = 0
    saw_now_showing = 0
    saw_next_showing = 0
    saw_today = 0
    saw_tonight = 0
    saw_tomorrow = 0
    saw_center_align = 0
    saw_schedule_table = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/) has_label = 1
    if (u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_alias = 1
    if (u ~ /TEXTDISP_CHANNELSOURCEMODE/) has_source_mode_write = 1
    if (u ~ /WDISP_ACCUMULATORFLUSHPENDING/ && (u ~ /CLR.W/ || u ~ /MOVE.W D0,/)) has_flush_clear = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/ || u ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIB/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOC/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVI/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/) has_build_clock_entry = 1
    if (u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_status_line = 1
    if (u ~ /TEXTDISP_BUILDCHANNELLABEL/) has_build_channel_label = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT/ || u ~ /ESQ_SETCOPPEREFFECT_OFFDISABLEHI/) has_disable_highlight = 1
    if (u ~ /ESQFUNC_SELECTANDAPPLYBRUSHFORCURRENTENTRY/ || u ~ /ESQFUNC_SELECTANDAPPLYBRUSHFORCU/) has_brush_select = 1
    if (u ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) has_drop = 1
    if (u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/ || u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIE/) {
        has_viewmode_build = 1
        viewmode_build_count++
        if (viewmode_build_count >= 2) has_dual_viewmode_build = 1
    }
    if (u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE/ || u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTR/) has_serial_shadow = 1
    if (u ~ /ESQ_NOOP/) has_noop = 1
    if (u ~ /TEXTDISP_DRAWCHANNELBANNER/ || u ~ /TEXTDISP_BUILDENTRYSHORTNAME/) has_banner_or_short_name = 1
    if (u ~ /ALIGNED_NOW_SHOWING/ || u ~ /ALIGNED_NEXT_SHOWING/ || u ~ /ALIGNED_TOMORROW_AT/ || u ~ /ALIGNED_TODAY_AT/ || u ~ /ALIGNED_TONIGHT_AT/ || u ~ /ALIGNEDSTATUSSUFFIXBUFFER/) has_suffix_path = 1
    if (u ~ /TEXTDISP_CURRENTMATCHINDEXSAVED/) has_match_index_saved = 1
    if (u ~ /TEXTDISP_BANNERCHARSELECTED/ && (u ~ /#100/ || u ~ /#\$64/ || u ~ /CLEANUP3_BANNER_CHAR_NONE/)) has_banner_char_reset = 1
    if (u ~ /TEXTDISP_BANNERCHARFALLBACK/ && (u ~ /#49/ || u ~ /#\$31/ || u ~ /'1'/)) has_banner_char_reset = 1
    if (u ~ /TEXTDISP_LINEPENOVERRIDESTATEWOR/ || u ~ /TEXTDISP_LINEPENOVERRIDEENABLEDF/ ||
        u ~ /TEXTDISP_LINEPENOVERRIDESTATEWORD/ || u ~ /TEXTDISP_LINEPENOVERRIDEENABLEDFLAG/) has_pen_override = 1
    if (u ~ /TEXTDISP_TRIMTEXTTOPIXELWIDTH/ || u ~ /TEXTDISP_TRIMTEXTTOPIXELW/) saw_trim = 1
    if (u ~ /TEXTDISP_DRAWINSETRECTFRAME/ || u ~ /TEXTDISP_DRAWINSETRECTFRA/) saw_frame = 1
    if (saw_trim && saw_frame) has_trim_and_frame = 1
    if (u ~ /TLIBA3_GETVIEWMODERASTPORT/ || u ~ /TLIBA3_GETVIEWMODEHEIGHT/ || u ~ /_LVORECTFILL/) has_mode2_rast_fill = 1
    if (u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTPORT/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITMAPRASTP/ || u ~ /GROUP_AD_JMPTBL_GRAPHICS_BLTBITM/) has_blit = 1
    if (u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANSITION/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPERRISETRANS/ || u ~ /GROUP_AD_JMPTBL_ESQIFF_RUNCOPPER/ || u ~ /ESQIFF_RUNCOPPERRISETRANSITION/) has_copper_rise = 1
    if (u ~ /TEXTDISP_DRAWCHANNELBANNER/) saw_draw_banner = 1
    if (u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGHLIGHT/ || u ~ /ESQ_SETCOPPEREFFECT_ONENABLEHIGH/) saw_copper_enable = 1
    if (saw_draw_banner && saw_copper_enable) has_empty_template_banner = 1
    if (u ~ /TEXTDISP_BANNERFALLBACKISSPECIALFLAG/ || u ~ /TEXTDISP_BANNERSELECTEDISSPECIAL/) saw_special_flag = 1
    if (u ~ /TEXTDISP_BANNERFALLBACKVALIDFLAG/ || u ~ /TEXTDISP_BANNERSELECTEDVALIDFLAG/) saw_valid_flag = 1
    if (u ~ /ALIGNED_NOW_SHOWING/) saw_now_showing = 1
    if (u ~ /ALIGNED_NEXT_SHOWING/) saw_next_showing = 1
    if (saw_special_flag && saw_valid_flag && saw_now_showing && saw_next_showing) has_special_now_next_path = 1
    if (u ~ /ALIGNED_TODAY_AT/) saw_today = 1
    if (u ~ /ALIGNED_TONIGHT_AT/) saw_tonight = 1
    if (u ~ /ALIGNED_TOMORROW_AT/) saw_tomorrow = 1
    if (saw_today && saw_tonight && saw_tomorrow) has_time_phrase_path = 1
    if (u ~ /TEXTDISP_CENTERALIGNTOKEN/) saw_center_align = 1
    if (u ~ /SCRIPT_STRCHANNELLABEL_TUESDAYSFRIDAYS/ || u ~ /SCRIPT_STRCHANNELLABEL_TUESDAYSF/) saw_schedule_table = 1
    if (saw_center_align && saw_schedule_table) has_centered_schedule_suffix = 1
    if (u ~ /^(JSR|BSR).*_LVOSETRAST/) set_rast_count++
    if (u ~ /^(JSR|BSR).*_LVOSETDRMD/) set_drmode_count++
    if (u ~ /^(JSR|BSR).*TLIBA3_GETVIEWMODEHEIGHT/) viewmode_height_count++
    if (u ~ /^(JSR|BSR).*TEXTDISP_FORMATENTRYTIME/) format_entry_time_count++
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_ALIAS=" has_alias
    print "HAS_SOURCE_MODE_WRITE=" has_source_mode_write
    print "HAS_FLUSH_CLEAR=" has_flush_clear
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_BUILD_CLOCK_ENTRY=" has_build_clock_entry
    print "HAS_BUILD_STATUS_LINE=" has_build_status_line
    print "HAS_BUILD_CHANNEL_LABEL=" has_build_channel_label
    print "HAS_DISABLE_HIGHLIGHT=" has_disable_highlight
    print "HAS_BRUSH_SELECT=" has_brush_select
    print "HAS_COPPER_DROP=" has_drop
    print "HAS_VIEWMODE_BUILD=" has_viewmode_build
    print "HAS_DUAL_VIEWMODE_BUILD=" has_dual_viewmode_build
    print "HAS_SERIAL_SHADOW_UPDATE=" has_serial_shadow
    print "HAS_NOOP=" has_noop
    print "HAS_BANNER_OR_SHORTNAME_PATH=" has_banner_or_short_name
    print "HAS_SUFFIX_PATH=" has_suffix_path
    print "HAS_MATCH_INDEX_SAVED=" has_match_index_saved
    print "HAS_BANNER_CHAR_RESET=" has_banner_char_reset
    print "HAS_PEN_OVERRIDE_SETUP=" has_pen_override
    print "HAS_TRIM_AND_FRAME=" has_trim_and_frame
    print "HAS_MODE2_RAST_FILL=" has_mode2_rast_fill
    print "HAS_BLIT=" has_blit
    print "HAS_COPPER_RISE=" has_copper_rise
    print "HAS_EMPTY_TEMPLATE_BANNER=" has_empty_template_banner
    print "HAS_SPECIAL_NOW_NEXT_PATH=" has_special_now_next_path
    print "HAS_TIME_PHRASE_PATH=" has_time_phrase_path
    print "HAS_CENTERED_SCHEDULE_SUFFIX=" has_centered_schedule_suffix
    print "SET_RAST_COUNT=" set_rast_count
    print "SET_DRMD_COUNT=" set_drmode_count
    print "VIEWMODE_HEIGHT_COUNT=" viewmode_height_count
    print "FORMAT_ENTRY_TIME_COUNT=" format_entry_time_count
    print "HAS_RETURN=" has_return
}
