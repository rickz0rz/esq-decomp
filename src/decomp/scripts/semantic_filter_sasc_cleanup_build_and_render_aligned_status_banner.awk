BEGIN {
    has_label = 0
    has_alias = 0
    has_find_char = 0
    has_build_clock_entry = 0
    has_build_status_line = 0
    has_drop = 0
    has_viewmode_build = 0
    has_serial_shadow = 0
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
    saw_trim = 0
    saw_frame = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_BUILDANDRENDERALIGNEDSTA[A-Z0-9_]*:/) has_label = 1
    if (u ~ /^CLEANUP_RENDERALIGNEDSTATUSSCRE[A-Z0-9_]*:/) has_alias = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ || u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/ || u ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOCKFORMATENTRYIFVISIB/ || u ~ /GROUP_AD_JMPTBL_TLIBA1_BUILDCLOC/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVI/ || u ~ /TLIBA1_BUILDCLOCKFORMATENTRYIFVISIBLE/) has_build_clock_entry = 1
    if (u ~ /CLEANUP_BUILDALIGNEDSTATUSLINE/) has_build_status_line = 1
    if (u ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) has_drop = 1
    if (u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/ || u ~ /TLIBA3_BUILDDISPLAYCONTEXTFORVIE/) has_viewmode_build = 1
    if (u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE/ || u ~ /SCRIPT_UPDATESERIALSHADOWFROMCTR/) has_serial_shadow = 1
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
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_ALIAS=" has_alias
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_BUILD_CLOCK_ENTRY=" has_build_clock_entry
    print "HAS_BUILD_STATUS_LINE=" has_build_status_line
    print "HAS_COPPER_DROP=" has_drop
    print "HAS_VIEWMODE_BUILD=" has_viewmode_build
    print "HAS_SERIAL_SHADOW_UPDATE=" has_serial_shadow
    print "HAS_BANNER_OR_SHORTNAME_PATH=" has_banner_or_short_name
    print "HAS_SUFFIX_PATH=" has_suffix_path
    print "HAS_MATCH_INDEX_SAVED=" has_match_index_saved
    print "HAS_BANNER_CHAR_RESET=" has_banner_char_reset
    print "HAS_PEN_OVERRIDE_SETUP=" has_pen_override
    print "HAS_TRIM_AND_FRAME=" has_trim_and_frame
    print "HAS_MODE2_RAST_FILL=" has_mode2_rast_fill
    print "HAS_BLIT=" has_blit
    print "HAS_COPPER_RISE=" has_copper_rise
    print "HAS_RETURN=" has_return
}
