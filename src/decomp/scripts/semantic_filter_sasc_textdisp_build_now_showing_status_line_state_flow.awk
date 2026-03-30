BEGIN {
    has_entry = 0
    has_get_aux = 0
    has_get_entry = 0
    has_default_primary_channel = 0
    has_channel_day_mask = 0
    has_time_window_gate = 0
    has_banner_sentinel_switch = 0
    has_now_showing_branch = 0
    has_format_time_branch = 0
    has_primary_prefix_append = 0
    has_aux_title_token = 0
    has_channel_fallback_branch = 0
    has_primary_search_token = 0
    has_program_title_loop = 0
    has_program_title_compact = 0
    has_channel_abbrev_append = 0
    has_time_token_suffix = 0
    has_aligned_line_build = 0
    has_aligned_zero_tail_args = 0
    has_external_weather_fallback = 0
    has_highlight_effect = 0
    has_return = 0

    find_token_count = 0
    saw_primary_channel_store = 0
    saw_primary_channel_default_const = 0
    primary_channel_ref_count = 0
    saw_day_index = 0
    saw_day_table = 0
    saw_day_mask_op = 0
    saw_time_window_const = 0
    saw_time_window_cfg = 0
    saw_time_window_call = 0
    saw_banner_cmp = 0
    saw_banner_selected = 0
    saw_banner_fallback = 0
    saw_prefix_a = 0
    saw_prefix_b = 0
    saw_prefix_c = 0
    saw_primary_search_ref = 0
    saw_program_scan = 0
    saw_space_compare = 0
    saw_program_copy = 0
    saw_spacer_b = 0
    saw_format_char = 0
    saw_weather_ptr = 0
    saw_zero_tail_seed = 0
    aligned_zero_push_count = 0
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

    if (line ~ /^TEXTDISP_BUILDNOWSHOWINGSTATUSLINE:/ ||
        line ~ /^TEXTDISP_BUILDNOWSHOWINGSTATUSLI[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (index(line, "GETENTRYAUXPOINTERBYMODE") > 0 || index(line, "GETENTRYAU") > 0) has_get_aux = 1
    if (index(line, "GETENTRYPOINTERBYMODE") > 0 || index(line, "GETENTRYPO") > 0) has_get_entry = 1

    if (index(line, "TEXTDISP_PRIMARYCHANNELCODE") > 0) primary_channel_ref_count++
    if (line ~ /#\$30|#48/) {
        saw_primary_channel_default_const = 1
    }
    if (index(line, "TEXTDISP_PRIMARYCHANNELCODE") > 0 && saw_primary_channel_default_const) {
        saw_primary_channel_store = 1
    }
    if (line ~ /^MOVE\.W .*TEXTDISP_PRIMARYCHANNELCODE/ && saw_primary_channel_store) {
        has_default_primary_channel = 1
    }
    if (!has_default_primary_channel && primary_channel_ref_count >= 3 && saw_primary_channel_store) {
        has_default_primary_channel = 1
    }

    if (index(line, "CLOCK_CURRENTDAYOFWEEKINDEX") > 0) saw_day_index = 1
    if (index(line, "GLOBAL_STR_TEXTDISP_C_3") > 0) saw_day_table = 1
    if (line ~ /ASL\.L #/ || line ~ /BSET / || line ~ /AND\.L D[0-7],D[0-7]/) saw_day_mask_op = 1
    if (saw_day_index && saw_day_table && saw_day_mask_op) has_channel_day_mask = 1

    if (line ~ /#\$5A0|#1440/ || line ~ /\(\$5A0\)\.W/ || line ~ /\(1440\)\.W/ ||
        line ~ /^PEA \$?5A0\.W$/ || line ~ /^PEA 1440\.W$/) {
        saw_time_window_const = 1
    }
    if (index(line, "CONFIG_TIMEWINDOWMINUTES") > 0) saw_time_window_cfg = 1
    if (index(line, "COI_TESTENTRYWITHINTIMEWINDOW") > 0 || index(line, "COI_TESTENTRYWITHI") > 0) {
        saw_time_window_call = 1
    }
    if (saw_time_window_call && saw_time_window_const && saw_time_window_cfg) {
        has_time_window_gate = 1
    }

    if (index(line, "TEXTDISP_BANNERCHARSELECTED") > 0) saw_banner_cmp = 1
    if (index(line, "TEXTDISP_BANNERSELECTEDISSPECIAL") > 0) saw_banner_selected = 1
    if (index(line, "TEXTDISP_BANNERFALLBACKISSPECIAL") > 0) saw_banner_fallback = 1
    if (saw_banner_cmp && saw_banner_selected && saw_banner_fallback &&
        (line ~ /#\$64|#100/ || saw_banner_cmp)) {
        has_banner_sentinel_switch = 1
    }

    if (index(line, "GLOBAL_STR_ALIGNED_NOW_SHOWING") > 0) has_now_showing_branch = 1
    if (index(line, "TEXTDISP_FORMATENTRYTIMEFORINDEX") > 0 || index(line, "STR_SKIPCLASS3CHARS") > 0) {
        has_format_time_branch = 1
    }

    if (index(line, "SCRIPT_ALIGNEDPREFIXEMPTYA") > 0) saw_prefix_a = 1
    if (saw_prefix_a && index(line, "STRING_APPENDATNULL") > 0) has_primary_prefix_append = 1

    if (index(line, "SCRIPT_ALIGNEDPREFIXEMPTYB") > 0) saw_prefix_b = 1
    if (index(line, "SCRIPT_STRCHANNELLABEL_TUESDAYSFRIDAYS") > 0 ||
        index(line, "SCRIPT_STRCHANNELLABEL_TUESDAYSF") > 0) {
        has_channel_fallback_branch = saw_prefix_b ? 1 : has_channel_fallback_branch
    }
    if (index(line, "TEXTDISP_PRIMARYSEARCHTEXT") > 0) saw_primary_search_ref = 1
    if (index(line, "TEXTDISP_FINDCONTROLTOKEN") > 0) {
        find_token_count++
        if (saw_primary_search_ref) {
            has_primary_search_token = 1
        } else {
            has_aux_title_token = 1
        }
    }

    if (line ~ /^TST\.B .*\(A[0-7],D0\.L\)$/) saw_program_scan = 1
    if (line ~ /#\$20|#32/) saw_space_compare = 1
    if (saw_space_compare && line ~ /^MOVE\.B .*D0\.L\),(\(A[0-7]\)|\$[0-9A-F]+\([A-Z0-7]\))$/) {
        saw_program_copy = 1
    }
    if (saw_space_compare && line ~ /^MOVE\.B .*D0\.L\),\(A[0-7]\)$/) {
        saw_program_copy = 1
    }
    if (saw_space_compare && line ~ /^MOVE\.B .*D0\.L\),\$[0-9A-F]+\([A-Z0-7]\)$/) {
        saw_program_copy = 1
    }
    if (saw_program_scan && saw_space_compare && saw_program_copy) has_program_title_loop = 1
    if (saw_space_compare && saw_program_copy) has_program_title_compact = 1

    if (index(line, "SCRIPT_ALIGNEDCHANNELABBREVPREFIX") > 0 ||
        index(line, "SCRIPT_ALIGNEDCHANNELABBREVPREFI") > 0) {
        has_channel_abbrev_append = 1
    }

    if (index(line, "SCRIPT_SPACERTRIPLEB") > 0) saw_spacer_b = 1
    if (index(line, "SCRIPT_ALIGNEDCHARFORMAT") > 0) saw_format_char = 1
    if ((saw_spacer_b || saw_format_char) && index(line, "WDISP_SPRINTF") > 0) has_time_token_suffix = 1

    if (line ~ /^MOVEQ(\.L)? #0,D3$/ || line ~ /^MOVEQ(\.L)? #\$0,D3$/ || line == "CLR.L D3") {
        saw_zero_tail_seed = 1
        aligned_zero_push_count = 0
    } else if (saw_zero_tail_seed && line == "MOVE.L D3,-(A7)") {
        aligned_zero_push_count++
    }
    if (index(line, "CLEANUP_BUILDALIGNEDSTATUSLINE") > 0) has_aligned_line_build = 1
    if (index(line, "CLEANUP_BUILDALIGNEDSTATUSLINE") > 0 && aligned_zero_push_count >= 2) {
        has_aligned_zero_tail_args = 1
    }

    if (index(line, "P_TYPE_WEATHERBOTTOMLINEMSGPTR") > 0) saw_weather_ptr = 1
    if (index(line, "SCRIPT_ALIGNEDPREFIXEMPTYC") > 0) saw_prefix_c = 1
    if (saw_weather_ptr && saw_prefix_c) has_external_weather_fallback = 1

    if (index(line, "SCRIPT_SETUPHIGHLIGHTEFFECT") > 0) has_highlight_effect = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GET_AUX=" has_get_aux
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_DEFAULT_PRIMARY_CHANNEL=" has_default_primary_channel
    print "HAS_CHANNEL_DAY_MASK=" has_channel_day_mask
    if (!has_time_window_gate && saw_time_window_call && saw_time_window_const && saw_time_window_cfg) {
        has_time_window_gate = 1
    }
    print "HAS_TIME_WINDOW_GATE=" has_time_window_gate
    print "HAS_BANNER_SENTINEL_SWITCH=" has_banner_sentinel_switch
    print "HAS_NOW_SHOWING_BRANCH=" has_now_showing_branch
    print "HAS_FORMAT_TIME_BRANCH=" has_format_time_branch
    print "HAS_PRIMARY_PREFIX_APPEND=" has_primary_prefix_append
    print "HAS_AUX_TITLE_TOKEN=" has_aux_title_token
    print "HAS_CHANNEL_FALLBACK_BRANCH=" has_channel_fallback_branch
    print "HAS_PRIMARY_SEARCH_TOKEN=" has_primary_search_token
    print "HAS_PROGRAM_TITLE_LOOP=" has_program_title_loop
    print "HAS_PROGRAM_TITLE_COMPACT=" has_program_title_compact
    print "HAS_CHANNEL_ABBREV_APPEND=" has_channel_abbrev_append
    print "HAS_TIME_TOKEN_SUFFIX=" has_time_token_suffix
    print "HAS_ALIGNED_LINE_BUILD=" has_aligned_line_build
    print "HAS_ALIGNED_ZERO_TAIL_ARGS=" has_aligned_zero_tail_args
    print "HAS_EXTERNAL_WEATHER_FALLBACK=" has_external_weather_fallback
    print "HAS_HIGHLIGHT_EFFECT=" has_highlight_effect
    print "HAS_RETURN=" has_return
}
