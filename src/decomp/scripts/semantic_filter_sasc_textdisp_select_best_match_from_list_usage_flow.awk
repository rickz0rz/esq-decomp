BEGIN {
    h_entry = 0
    h_init_selected_sentinel = 0
    h_tag_compare = 0
    h_channel_gate = 0
    h_weekday_gate = 0
    h_candidate_loop = 0
    h_candidate_store = 0
    h_find_mode1 = 0
    h_find_mode2 = 0
    h_find_mode3 = 0
    h_find_mode0 = 0
    h_group_primary = 0
    h_group_secondary = 0
    h_time_call_ge_2 = 0
    h_special_gate = 0
    h_mode2_fallback_mark = 0
    h_mode2_fallback_carry = 0
    h_mode0_fallback_entry_store = 0
    h_mode3_requery = 0
    h_positive_selected = 0
    h_positive_fallback = 0
    h_negative_selected = 0
    h_negative_fallback = 0
    h_previous_usage_store = 0
    h_last_match_store = 0
    h_findmode_early_return = 0
    h_finalize_3d_guard = 0
    h_finalize_helper_reload = 0
    h_finalize_usage_bump = 0
    h_channel68_return = 0
    h_return_error = 0
    h_return_found = 0
    h_return_ok = 0

    time_calls = 0
    saw_weekday_table = 0
    saw_weekday_index = 0
    saw_weekday_mask = 0
    saw_weekday_branch = 0
    saw_candidate_table = 0
    saw_candidate_load = 0
    saw_mode0_gate = 0
    saw_mode2_call = 0
    saw_mode3_call = 0
    saw_finalize_3d_cmp = 0
    saw_finalize_selected_entry = 0
    saw_finalize_selected_char = 0
    saw_finalize_reload_selected = 0
    prev = ""
    prev2 = ""
    prev3 = ""
    prev4 = ""
    prev5 = ""
}

function toupper_line(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = toupper_line($0)
    if (l == "") next

    if (l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/ || l ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST[A-Z0-9_]*:/) h_entry = 1
    if (l ~ /BANNERCHARSELECTED/ && (l ~ /#\$64/ || l ~ /#100/)) h_init_selected_sentinel = 1

    if ((l ~ /TEXTDISP_TAG_SPT_SELECT/ || prev ~ /TEXTDISP_TAG_SPT_SELECT/) &&
        (l ~ /CMP\.B/ || prev ~ /CMP\.B/ || l ~ /MOVE\.B #\$8/ || prev ~ /MOVE\.B #\$8/)) h_tag_compare = 1

    if (l ~ /GLOBAL_STR_TEXTDISP_C_3/) saw_weekday_table = 1
    if (l ~ /CLOCK_CURRENTDAYOFWEEKINDEX/) saw_weekday_index = 1
    if (l ~ /ASL\.L D0,D1/ || l ~ /BSET D0,D2/ || l ~ /AND\.L D[0-7],D[0-7]/) saw_weekday_mask = 1
    if ((l ~ /(BNE|BEQ)\.[BSWL]?/ || l ~ /(BNE|BEQ) /) &&
        (prev ~ /TST\.L D[0-7]/ || prev ~ /AND\.L D[0-7],D[0-7]/ || prev2 ~ /AND\.L D[0-7],D[0-7]/)) saw_weekday_branch = 1
    if (saw_weekday_table && saw_weekday_index && saw_weekday_mask && saw_weekday_branch) {
        h_weekday_gate = 1
        h_channel_gate = 1
    }

    if (l ~ /CANDIDATE_LOOP/ || l ~ /ADDQ\.W #1,D5/ || l ~ /ADDQ\.L #1,D5/ || l ~ /ADDQ\.L #\$1,D5/) h_candidate_loop = 1
    if (l ~ /TEXTDISP_CANDIDATEINDEXLIST/) saw_candidate_table = 1
    if (saw_candidate_table && l ~ /MOVE\.B .*D0/) saw_candidate_load = 1
    if (saw_candidate_load && l ~ /MOVE\.W D0,TEXTDISP_CURRENTMATCHINDEX/) h_candidate_store = 1

    if (l ~ /SBEFILTERACTIVEFLAG/) saw_mode0_gate = 1
    if (l ~ /(JSR|BSR).*FINDENTRYMATCHINDEX/ || l ~ /FINDENTRYMATCHINDEX/) {
        if (l ~ /PEA 1\.W/ || l ~ /PEA \(\$1\)\.W/ || prev ~ /PEA 1\.W/ || prev ~ /PEA \(\$1\)\.W/ || prev2 ~ /PEA 1\.W/ || prev2 ~ /PEA \(\$1\)\.W/) h_find_mode1 = 1
        if (l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/ || prev ~ /PEA 2\.W/ || prev ~ /PEA \(\$2\)\.W/ || prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/) {
            h_find_mode2 = 1
            saw_mode2_call = 1
        }
        if (l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/ || prev ~ /PEA 3\.W/ || prev ~ /PEA \(\$3\)\.W/ || prev2 ~ /PEA 3\.W/ || prev2 ~ /PEA \(\$3\)\.W/) {
            h_find_mode3 = 1
            saw_mode3_call = 1
        }
        if (saw_mode0_gate &&
            ((l ~ /CLR\.L -\(A7\)/) || (prev ~ /CLR\.L -\(A7\)/) || (prev2 ~ /CLR\.L -\(A7\)/) ||
             (l ~ /CLR\.L \(A7\)/) || (prev ~ /CLR\.L \(A7\)/) || (prev2 ~ /CLR\.L \(A7\)/))) h_find_mode0 = 1
    }

    if (saw_mode2_call &&
        (l ~ /BANNERFALLBACKVALIDFLAG/ || prev ~ /BANNERFALLBACKVALIDFLAG/) &&
        (l ~ /#\$1/ || l ~ /#1/ || prev ~ /#\$1/ || prev ~ /#1/)) h_mode2_fallback_mark = 1
    if ((l ~ /MOVE\.W -4\(A5\),-16\(A5\)/ ||
         l ~ /MOVE\.W -4\(A5\),D0/ || l ~ /MOVE\.W D0,-16\(A5\)/ ||
         l ~ /MOVE\.L \$4C\(A7\),D0/ || l ~ /MOVE\.L D0,\$44\(A7\)/ || l ~ /MOVE\.L D1,\$44\(A7\)/) &&
        (saw_mode2_call || prev ~ /PEA 2\.W/ || prev ~ /PEA \(\$2\)\.W/ ||
         prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/ ||
         prev ~ /CMP\.L D1,D0/ || prev ~ /CMP\.W D1,D0/ ||
         prev2 ~ /CMP\.L D1,D0/ || prev2 ~ /CMP\.W D1,D0/)) h_mode2_fallback_carry = 1

    if (saw_mode0_gate &&
        (l ~ /BANNERFALLBACKENTRYIND/ || prev ~ /BANNERFALLBACKENTRYIND/ || prev2 ~ /BANNERFALLBACKENTRYIND/) &&
        (l ~ /CURRENTMATCHINDEX/ || prev ~ /CURRENTMATCHINDEX/ || prev2 ~ /CURRENTMATCHINDEX/ || prev3 ~ /CURRENTMATCHINDEX/)) h_mode0_fallback_entry_store = 1
    if ((l ~ /MOVE\.W D0,-4\(A5\)/ || l ~ /MOVE\.L D0,\$4C\(A7\)/) &&
        (saw_mode3_call || prev ~ /PEA 3\.W/ || prev ~ /PEA \(\$3\)\.W/ ||
         prev2 ~ /PEA 3\.W/ || prev2 ~ /PEA \(\$3\)\.W/ ||
         prev ~ /FINDENTRYMATCHINDEX/ || prev2 ~ /FINDENTRYMATCHINDEX/)) h_mode3_requery = 1

    if (l ~ /PRIMARYTITLEPTRTABLE/) h_group_primary = 1
    if (l ~ /SECONDARYTITLEPTRTABLE/) h_group_secondary = 1

    if (l ~ /(JSR|BSR).*COMPUTETIMEOFFSET/ || l ~ /COMPUTETIMEOFFSET/) time_calls++
    if (time_calls >= 2) h_time_call_ge_2 = 1

    if ((l ~ /ACTIVEGROUPID/ || prev ~ /ACTIVEGROUPID/ || prev2 ~ /ACTIVEGROUPID/) &&
        (l ~ /CLOCK_HALFHOURSLOTINDEX/ || prev ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
        (l ~ /MOVE\.B D[0-7],-23\(A5\)/ || l ~ /MOVE\.B D[0-7],\$38\(A7\)/ || l ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
         l ~ /BANNERSELECTEDISSPECIAL/ || l ~ /BANNERFALLBACKISSPECIAL/ ||
         prev ~ /MOVE\.B D[0-7],-23\(A5\)/ || prev ~ /MOVE\.B D[0-7],\$38\(A7\)/ || prev ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
         prev ~ /BANNERSELECTEDISSPECIAL/ || prev ~ /BANNERFALLBACKISSPECIAL/)) h_special_gate = 1

    if (l ~ /BANNERSELECTEDVALIDFLAG/) h_positive_selected = 1
    if (l ~ /MOVE\.W D0,-20\(A5\)/ || l ~ /MOVE\.W D0,\$30\(A7\)/) h_positive_fallback = 1
    if ((l ~ /BANNERSELECTEDENTRYIND/ || l ~ /BANNERCHARSELECTED/) &&
        (prev ~ /CMP\.W/ || prev ~ /CMP\.L/ || prev2 ~ /CMP\.W/ || prev2 ~ /CMP\.L/)) h_negative_selected = 1
    if (l ~ /MOVE\.W D0,-22\(A5\)/ || l ~ /MOVE\.W D0,\$2E\(A7\)/) h_negative_fallback = 1

    if (l ~ /MOVE\.W 0\(A0,D1\.L\),-12\(A5\)/ || l ~ /MOVE\.W D0,\$2C\(A7\)/) h_previous_usage_store = 1
    if (l ~ /MOVE\.W D0,-6\(A5\)/ || l ~ /MOVE\.W D1,\$48\(A7\)/ || l ~ /MOVE\.W D0,\$48\(A7\)/) h_last_match_store = 1

    if ((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) &&
        (prev ~ /FINDMODEACTIVEFLAG/ || prev2 ~ /FINDMODEACTIVEFLAG/ ||
         prev ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev ~ /SUBQ\.[BW] #1,D[0-7]/ ||
         prev2 ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev2 ~ /SUBQ\.[BW] #1,D[0-7]/)) h_findmode_early_return = 1

    if (l ~ /CMPI?\.W #\$3D/ || l ~ /CMPI?\.W #61/ || l ~ /CMP\.W #\$3D/ || l ~ /CMP\.W #61/) saw_finalize_3d_cmp = 1
    if (saw_finalize_3d_cmp &&
        (l ~ /BANNERCHARSELECTED/ || prev ~ /BANNERCHARSELECTED/ || prev2 ~ /BANNERCHARSELECTED/) &&
        (l ~ /#\$64/ || l ~ /#100/ || prev ~ /#\$64/ || prev ~ /#100/)) h_finalize_3d_guard = 1

    if (l ~ /BANNERSELECTEDENTRYIND/) saw_finalize_selected_entry = 1
    if (saw_finalize_selected_entry &&
        (l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
         prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ || prev ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
         prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/ || prev2 ~ /TEXTDISP_GETACTIVETITLEPTR/)) saw_finalize_reload_selected = 1
    if (saw_finalize_selected_entry &&
        (l ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || l ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
         l ~ /PRIMARYTITLEPTRTABLE/ || l ~ /SECONDARYTITLEPTRTABLE/ ||
         prev ~ /PRIMARYTITLEPTRTABLE/ || prev ~ /SECONDARYTITLEPTRTABLE/ ||
         prev2 ~ /PRIMARYTITLEPTRTABLE/ || prev2 ~ /SECONDARYTITLEPTRTABLE/)) h_finalize_helper_reload = 1
    if (l ~ /MOVE\.B TEXTDISP_BANNERCHARSELECTED/ || l ~ /BANNERCHARSELECTED/) saw_finalize_selected_char = 1
    if (saw_finalize_reload_selected && saw_finalize_selected_char &&
        (l ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || l ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ ||
         l ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || l ~ /MOVE\.W D1,0\(A0,D3\.L\)/ ||
         prev ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ ||
         prev ~ /ADDQ\.W #1,0\(A0,D0\.L\)/ || prev ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/)) h_finalize_usage_bump = 1

    if (l ~ /MOVEQ\.L #\$44,D6/ || l ~ /MOVEQ #68,D6/ || l ~ /CHANNELCODE = 68/) h_channel68_return = 1
    if (l ~ /MOVEQ\.L #\$1,D0/ || l ~ /MOVEQ #1,D0/) h_return_error = 1
    if ((l ~ /MOVEQ\.L #\$2,D0/ || l ~ /MOVEQ #2,D0/) &&
        prev !~ /FINDMODEACTIVEFLAG/ && prev2 !~ /FINDMODEACTIVEFLAG/) h_return_found = 1
    if (l ~ /MOVEQ\.L #\$0,D0/ || l ~ /MOVEQ #0,D0/) h_return_ok = 1

    prev5 = prev4
    prev4 = prev3
    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_INIT_SELECTED_SENTINEL=" h_init_selected_sentinel
    print "HAS_TAG_COMPARE=" h_tag_compare
    print "HAS_CHANNEL_GATE=" h_channel_gate
    print "HAS_WEEKDAY_GATE=" h_weekday_gate
    print "HAS_CANDIDATE_LOOP=" h_candidate_loop
    print "HAS_CANDIDATE_STORE=" h_candidate_store
    print "HAS_FIND_MODE1=" h_find_mode1
    print "HAS_FIND_MODE2=" h_find_mode2
    print "HAS_FIND_MODE3=" h_find_mode3
    print "HAS_FIND_MODE0=" h_find_mode0
    print "HAS_GROUP_PRIMARY_PATH=" h_group_primary
    print "HAS_GROUP_SECONDARY_PATH=" h_group_secondary
    print "TIME_OFFSET_CALL_COUNT_GE_2=" h_time_call_ge_2
    print "HAS_SPECIAL_GATE=" h_special_gate
    print "HAS_MODE2_FALLBACK_MARK=" h_mode2_fallback_mark
    print "HAS_MODE2_FALLBACK_CARRY=" h_mode2_fallback_carry
    print "HAS_MODE0_FALLBACK_ENTRY_STORE=" h_mode0_fallback_entry_store
    print "HAS_MODE3_REQUERY=" h_mode3_requery
    print "HAS_POSITIVE_SELECTED_PATH=" h_positive_selected
    print "HAS_POSITIVE_FALLBACK_PATH=" h_positive_fallback
    print "HAS_NEGATIVE_SELECTED_PATH=" h_negative_selected
    print "HAS_NEGATIVE_FALLBACK_PATH=" h_negative_fallback
    print "HAS_PREVIOUS_USAGE_STORE=" h_previous_usage_store
    print "HAS_LAST_MATCH_STORE=" h_last_match_store
    print "HAS_FINDMODE_EARLY_RETURN=" h_findmode_early_return
    print "HAS_FINALIZE_3D_GUARD=" h_finalize_3d_guard
    print "HAS_FINALIZE_HELPER_RELOAD=" h_finalize_helper_reload
    print "HAS_FINALIZE_USAGE_BUMP=" h_finalize_usage_bump
    print "HAS_CHANNEL68_RETURN_PATH=" h_channel68_return
    print "HAS_RETURN_ERROR=" h_return_error
    print "HAS_RETURN_FOUND=" h_return_found
    print "HAS_RETURN_OK=" h_return_ok
}
