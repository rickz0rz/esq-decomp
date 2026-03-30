BEGIN {
    has_entry = 0
    has_get_aux = 0
    has_get_entry = 0
    has_window_test = 0
    has_format_time = 0
    has_skip_class3 = 0
    has_find_token = 0
    has_sprintf = 0
    has_append = 0
    has_build_aligned = 0
    has_highlight = 0
    has_default_channel_store = 0
    saw_channel_range_table = 0
    saw_channel_day_index = 0
    saw_channel_day_mask = 0
    saw_channel_mask_test = 0
    has_channel_bitmap_gate = 0
    saw_banner_selected = 0
    saw_banner_selected_flag = 0
    saw_banner_fallback_flag = 0
    has_banner_flag_select = 0
    saw_now_showing_literal = 0
    saw_prefix_empty_a = 0
    has_now_showing_title_path = 0
    saw_prefix_empty_b = 0
    saw_primary_search_token = 0
    has_channel_fallback_path = 0
    saw_space_strip_cmp = 0
    saw_title_null_term = 0
    saw_channel_abbrev_prefix = 0
    saw_spacer_triple_a = 0
    has_program_title_compaction = 0
    saw_prefix_empty_c = 0
    saw_weather_msg_ptr = 0
    has_weather_fallback = 0
    saw_spacer_triple_b = 0
    saw_char_format = 0
    has_time_suffix_path = 0
    has_primary_search_banner_reset = 0
    has_return = 0
    track_primary_search_reset = 0
    saw_zero_before_program_title_gate = 0
    saw_30_immediate = 0
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

    if (u ~ /^TEXTDISP_BUILDNOWSHOWINGSTATUSLINE:/ || u ~ /^TEXTDISP_BUILDNOWSHOWINGSTATUSL[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXP") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAU") > 0) has_get_aux = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOI") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPO") > 0) has_get_entry = 1
    if (index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHINTIMEWINDOW") > 0 || index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHI") > 0) has_window_test = 1
    if (index(u, "TEXTDISP_FORMATENTRYTIMEFORINDEX") > 0 || index(u, "TEXTDISP_FORMATENTRYTIMEF") > 0) has_format_time = 1
    if (index(u, "STR_SKIPCLASS3CHARS") > 0 || index(u, "STR_SKIPCLASS3C") > 0) has_skip_class3 = 1
    if (index(u, "TEXTDISP_FINDCONTROLTOKEN") > 0 || index(u, "TEXTDISP_FINDCONTRO") > 0) has_find_token = 1
    if (index(u, "WDISP_SPRINTF") > 0 || index(u, "WDISP_SPRI") > 0) has_sprintf = 1
    if (index(u, "STRING_APPENDATNULL") > 0) has_append = 1
    if (index(u, "TEXTDISP_JMPTBL_CLEANUP_BUILDALIGNEDSTATUSLINE") > 0 || index(u, "TEXTDISP_JMPTBL_CLEANUP_BUILDALI") > 0 || index(u, "CLEANUP_BUILDALIGNEDSTATUSLINE") > 0) has_build_aligned = 1
    if (index(u, "SCRIPT_SETUPHIGHLIGHTEFFECT") > 0 || index(u, "SCRIPT_SETUPHIGHLIGHTEF") > 0) has_highlight = 1
    if (u ~ /^MOVEQ(\.L)? #48([,[:space:]]|$)/ || u ~ /^MOVEQ(\.L)? #\$30([,[:space:]]|$)/) saw_30_immediate = 1
    if (saw_30_immediate && index(u, "TEXTDISP_PRIMARYCHANNELCODE") > 0 && u ~ /^MOVE\.W /) {
        has_default_channel_store = 1
    }
    if (index(u, "GLOBAL_STR_TEXTDISP_C_3") > 0) saw_channel_range_table = 1
    if (index(u, "CLOCK_CURRENTDAYOFWEEKINDEX") > 0) saw_channel_day_index = 1
    if (u ~ /^ASL\.L / || index(u, "BSET ") > 0) saw_channel_day_mask = 1
    if (u ~ /^AND\.L /) saw_channel_mask_test = 1
    if (saw_channel_range_table && saw_channel_day_index && saw_channel_day_mask && saw_channel_mask_test) {
        has_channel_bitmap_gate = 1
    }
    if (index(u, "TEXTDISP_BANNERCHARSELECTED") > 0) saw_banner_selected = 1
    if (index(u, "TEXTDISP_BANNERSELECTEDISSPECIAL") > 0) saw_banner_selected_flag = 1
    if (index(u, "TEXTDISP_BANNERFALLBACKISSPECIAL") > 0) saw_banner_fallback_flag = 1
    if (saw_banner_selected && saw_banner_selected_flag && saw_banner_fallback_flag) {
        has_banner_flag_select = 1
    }
    if (index(u, "GLOBAL_STR_ALIGNED_NOW_SHOWING") > 0) saw_now_showing_literal = 1
    if (index(u, "SCRIPT_ALIGNEDPREFIXEMPTYA") > 0) saw_prefix_empty_a = 1
    if (saw_now_showing_literal && saw_prefix_empty_a && has_format_time && has_skip_class3) {
        has_now_showing_title_path = 1
    }
    if (index(u, "SCRIPT_ALIGNEDPREFIXEMPTYB") > 0) saw_prefix_empty_b = 1
    if (index(u, "TEXTDISP_PRIMARYSEARCHTEXT") > 0) saw_primary_search_token = 1
    if (saw_prefix_empty_b && saw_primary_search_token && has_primary_search_banner_reset) {
        has_channel_fallback_path = 1
    }
    if (u ~ /^CMP\.B .*#32$/ || u ~ /^CMP\.B .*#\$20$/ || u ~ /^MOVEQ(\.L)? #32([,[:space:]]|$)/ || u ~ /^MOVEQ(\.L)? #\$20([,[:space:]]|$)/) {
        saw_space_strip_cmp = 1
    }
    if ((u ~ /^MOVE\.B D0,\(A0\)$/) || index(u, "CLR.B $24(") > 0) saw_title_null_term = 1
    if (index(u, "SCRIPT_ALIGNEDCHANNELABBREVPREFIX") > 0 || index(u, "SCRIPT_ALIGNEDCHANNELABBREVPREFI") > 0) saw_channel_abbrev_prefix = 1
    if (index(u, "SCRIPT_SPACERTRIPLEA") > 0) saw_spacer_triple_a = 1
    if (saw_space_strip_cmp && saw_title_null_term && saw_channel_abbrev_prefix && saw_spacer_triple_a) {
        has_program_title_compaction = 1
    }
    if (index(u, "SCRIPT_ALIGNEDPREFIXEMPTYC") > 0) saw_prefix_empty_c = 1
    if (index(u, "P_TYPE_WEATHERBOTTOMLINEMSGPTR") > 0) saw_weather_msg_ptr = 1
    if (saw_prefix_empty_c && saw_weather_msg_ptr) has_weather_fallback = 1
    if (index(u, "SCRIPT_SPACERTRIPLEB") > 0) saw_spacer_triple_b = 1
    if (index(u, "SCRIPT_ALIGNEDCHARFORMAT") > 0) saw_char_format = 1
    if (saw_spacer_triple_b && saw_char_format && has_sprintf) has_time_suffix_path = 1
    if (index(u, "TEXTDISP_PRIMARYSEARCHTEXT") > 0) {
        track_primary_search_reset = 1
        saw_zero_before_program_title_gate = 0
    }
    if (track_primary_search_reset &&
        (u ~ /^MOVEQ(\.L)? #0([,[:space:]]|$)/ ||
         u ~ /^MOVEQ(\.L)? #\$0([,[:space:]]|$)/ ||
         u ~ /^CLR\.L([[:space:]]|$)/)) {
        saw_zero_before_program_title_gate = 1
    }
    if (track_primary_search_reset && u ~ /^TST\.L /) {
        has_primary_search_banner_reset = saw_zero_before_program_title_gate
        track_primary_search_reset = 0
    }
    if (u == "RTS") has_return = 1
    if (u !~ /^MOVEQ(\.L)? #48([,[:space:]]|$)/ && u !~ /^MOVEQ(\.L)? #\$30([,[:space:]]|$)/) {
        saw_30_immediate = 0
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET_AUX=" has_get_aux
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_WINDOW_TEST=" has_window_test
    print "HAS_FORMAT_TIME=" has_format_time
    print "HAS_SKIP_CLASS3=" has_skip_class3
    print "HAS_FIND_TOKEN=" has_find_token
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_APPEND=" has_append
    print "HAS_BUILD_ALIGNED=" has_build_aligned
    print "HAS_HIGHLIGHT=" has_highlight
    print "HAS_DEFAULT_CHANNEL_STORE=" has_default_channel_store
    print "HAS_CHANNEL_BITMAP_GATE=" has_channel_bitmap_gate
    print "HAS_BANNER_FLAG_SELECT=" has_banner_flag_select
    print "HAS_NOW_SHOWING_TITLE_PATH=" has_now_showing_title_path
    print "HAS_CHANNEL_FALLBACK_PATH=" has_channel_fallback_path
    print "HAS_PROGRAM_TITLE_COMPACTION=" has_program_title_compaction
    print "HAS_WEATHER_FALLBACK=" has_weather_fallback
    print "HAS_TIME_SUFFIX_PATH=" has_time_suffix_path
    print "HAS_PRIMARY_SEARCH_BANNER_RESET=" has_primary_search_banner_reset
    print "HAS_RETURN=" has_return
}
