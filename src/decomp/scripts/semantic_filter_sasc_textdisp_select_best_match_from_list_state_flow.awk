BEGIN {
    has_entry = 0
    has_init_selected = 0
    has_init_fallback = 0
    has_init_best_pos = 0
    has_init_best_neg = 0
    has_init_prev_usage = 0
    has_spt_compare = 0
    has_spt_mask_store = 0
    has_channel_default48 = 0
    has_channel_range = 0
    has_weekday_gate = 0
    has_candidate_loop = 0
    has_candidate_index_store = 0
    find_mode1_calls = 0
    find_mode2_calls = 0
    find_mode3_calls = 0
    find_mode0_calls = 0
    time_offset_calls = 0
    has_title_resolution = 0
    has_special_flag_path = 0
    has_min_index_path = 0
    has_mode2_fallback_mark = 0
    has_mode2_fallback_carry = 0
    has_mode3_requery = 0
    has_usage_fetch = 0
    has_positive_selected = 0
    has_positive_fallback = 0
    has_negative_selected = 0
    has_negative_fallback = 0
    has_prev_usage_store = 0
    has_last_match_store = 0
    has_findmode_return = 0
    has_mode0_fallback_store = 0
    has_finalize_gate = 0
    has_finalize_sentinel = 0
    has_finalize_usage_reload = 0
    has_finalize_helper_reload = 0
    has_finalize_usage_bump = 0
    has_normalize_channel = 0
    has_default68_return = 0
    has_return0 = 0
    has_return1 = 0
    has_return2 = 0
    has_rts = 0

    saw_weekday_table = 0
    saw_weekday_index = 0
    saw_weekday_mask = 0
    saw_spt_prefix = 0
    saw_candidate_table = 0
    saw_candidate_load = 0
    saw_mode2_pea = 0
    saw_mode3_pea = 0
    saw_mode0_push = 0
    saw_selected_compare = 0
    saw_fallback_compare = 0
    saw_finalize_selected = 0
    saw_special_activegroup = 0
    saw_special_halfhour = 0
    saw_special_store = 0

    prev1 = ""
    prev2 = ""
    prev3 = ""
    prev4 = ""
    prev5 = ""
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST:/ || u ~ /^TEXTDISP_SELECTBESTMATCHFROMLIST[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /MOVEB64TEXTDISPBANNERCHARSELECTED/) {
        has_init_selected = 1
    }
    if (n ~ /MOVEW31/ && (n ~ /48A7/ || n ~ /6A5/ || n ~ /TEXTDISPBANNERCHARFALLBACK/)) {
        has_init_fallback = 1
    }
    if (n ~ /MOVEW5A1/ && (n ~ /30A7/ || n ~ /20A5/)) {
        has_init_best_pos = 1
    }
    if (n ~ /MOVEWFFFFFA5F/ || (n ~ /MOVEWFA5F/ && (n ~ /2EA7/ || n ~ /22A5/))) {
        has_init_best_neg = 1
    }
    if (n ~ /MOVEWFFFFFFFA/ || (n ~ /MOVEWFFFA/ && (n ~ /2CA7/ || n ~ /12A5/))) {
        has_init_prev_usage = 1
    }

    if (u ~ /TEXTDISP_TAG_SPT_SELECT/ || u ~ /CMP\.B \(A1\)\+,D1/ || u ~ /CMP\.B D0,D1/) {
        saw_spt_prefix = 1
    }
    if (saw_spt_prefix && (u ~ /TST\.B D0/ || u ~ /TST\.B D1/ || u ~ /MOVE\.B \(A0\)\+,D1/ || u ~ /MOVE\.B \(A2\),D0/)) {
        has_spt_compare = 1
    }
    if (u ~ /MOVE\.B #\$8,-13\(A5\)/ || u ~ /MOVE\.B #\$8,\$2B\(A7\)/) {
        has_spt_mask_store = 1
    }

    if ((u ~ /MOVEQ(\.L)? #\$30,D6/ || u ~ /MOVEQ(\.L)? #48,D6/) &&
        (prev1 ~ /TST\.W D6/ || prev2 ~ /TST\.W D6/)) {
        has_channel_default48 = 1
    }
    if ((u ~ /CMP\.W D0,D6/ || u ~ /CMP\.W D6,D0/) &&
        (prev1 ~ /MOVEQ(\.L)? #\$30,D0/ || prev1 ~ /MOVEQ(\.L)? #\$43,D0/ ||
         prev1 ~ /MOVEQ(\.L)? #\$48,D0/ || prev1 ~ /MOVEQ(\.L)? #\$4D,D0/ ||
         prev1 ~ /MOVEQ(\.L)? #48,D0/ || prev1 ~ /MOVEQ(\.L)? #67,D0/ ||
         prev1 ~ /MOVEQ(\.L)? #72,D0/ || prev1 ~ /MOVEQ(\.L)? #77,D0/)) {
        has_channel_range = 1
    }

    if (u ~ /GLOBAL_STR_TEXTDISP_C_3/) {
        saw_weekday_table = 1
    }
    if (u ~ /CLOCK_CURRENTDAYOFWEEKINDEX/) {
        saw_weekday_index = 1
    }
    if (u ~ /ASL\.L D0,D1/ || u ~ /BSET D0,D2/) {
        saw_weekday_mask = 1
    }
    if (saw_weekday_table && saw_weekday_index && saw_weekday_mask &&
        (u ~ /AND\.L D[0-7],D[0-7]/ || u ~ /TST\.L D[0-7]/ || u ~ /BNE\./ || u ~ /BEQ\./)) {
        has_weekday_gate = 1
    }

    if (u ~ /CANDIDATE_LOOP/ || u ~ /ADDQ\.[WL] #1,D5/ || u ~ /ADDQ\.[WL] #\$1,D5/) {
        has_candidate_loop = 1
    }
    if (u ~ /TEXTDISP_CANDIDATEINDEXLIST/) {
        saw_candidate_table = 1
    }
    if (saw_candidate_table && u ~ /MOVE\.B .*D0/) {
        saw_candidate_load = 1
    }
    if (saw_candidate_load &&
        (u ~ /MOVE\.W D0,TEXTDISP_CURRENTMATCHINDEX/ || u ~ /MOVE\.B .*TEXTDISP_CURRENTMATCHINDEX/)) {
        has_candidate_index_store = 1
    }

    if (u ~ /PEA 2\.W/ || u ~ /PEA \(\$2\)\.W/) {
        saw_mode2_pea = 1
    }
    if (u ~ /PEA 3\.W/ || u ~ /PEA \(\$3\)\.W/) {
        saw_mode3_pea = 1
    }
    if (u ~ /CLR\.L -\(A7\)/ || u ~ /CLR\.L \(A7\)/) {
        saw_mode0_push = 1
    }
    if (u ~ /(JSR|BSR).*TEXTDISP_FINDENTRYMATCHINDEX/ || u ~ /TEXTDISP_FINDENTRYMATCHINDEX/) {
        if (prev1 ~ /PEA 1\.W/ || prev1 ~ /PEA \(\$1\)\.W/ ||
            prev2 ~ /PEA 1\.W/ || prev2 ~ /PEA \(\$1\)\.W/) {
            find_mode1_calls++
        }
        if (saw_mode2_pea) {
            find_mode2_calls++
            saw_mode2_pea = 0
        }
        if (saw_mode3_pea) {
            find_mode3_calls++
            saw_mode3_pea = 0
        }
        if (saw_mode0_push) {
            find_mode0_calls++
            saw_mode0_push = 0
        }
    }

    if (u ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || u ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
        u ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/ || u ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/) {
        has_title_resolution = 1
    }
    if (u ~ /(JSR|BSR).*TEXTDISP_COMPUTETIMEOFFSET/ || u ~ /TEXTDISP_COMPUTETIMEOFFSET/) {
        time_offset_calls++
    }

    if (u ~ /ACTIVEGROUPID/) {
        saw_special_activegroup = 1
    }
    if (u ~ /CLOCK_HALFHOURSLOTINDEX/) {
        saw_special_halfhour = 1
    }
    if (u ~ /MOVE\.B D[0-7],-23\(A5\)/ || u ~ /MOVE\.L D[0-7],\$38\(A7\)/ ||
        u ~ /MOVE\.B D[0-7],TEXTDISP_BANNERSELECTEDISSPECIAL/ || u ~ /MOVE\.B D[0-7],TEXTDISP_BANNERFALLBACKISSPECIAL/ ||
        u ~ /MOVE\.B -23\(A5\),TEXTDISP_BANNERSELECTEDISSPECIAL/ || u ~ /MOVE\.B -23\(A5\),TEXTDISP_BANNERFALLBACKISSPECIAL/) {
        saw_special_store = 1
    }
    if ((saw_special_activegroup && saw_special_halfhour && saw_special_store) ||
        ((u ~ /CLOCK_HALFHOURSLOTINDEX/ || prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
         (u ~ /TST\.[WL] D0/ || u ~ /TST\.L D[0-7]/ || prev1 ~ /TST\.[WL] D0/ || prev1 ~ /TST\.L D[0-7]/) &&
         (u ~ /MOVE\.B D[0-7],-23\(A5\)/ || u ~ /MOVE\.L D[0-7],\$38\(A7\)/ || u ~ /MOVE\.B D[0-7],TEXTDISP_BANNERSELECTEDISSPECIAL/ || u ~ /MOVE\.B D[0-7],TEXTDISP_BANNERFALLBACKISSPECIAL/ ||
          prev1 ~ /MOVE\.B D[0-7],-23\(A5\)/ || prev1 ~ /MOVE\.L D[0-7],\$38\(A7\)/))) {
        has_special_flag_path = 1
    }

    if ((u ~ /MOVEQ(\.L)? #1,D0/ || u ~ /MOVEQ(\.L)? #1,D[0-7]/ ||
         u ~ /MOVE\.L D0,\$3C\(A7\)/ || u ~ /MOVE\.L D0,\$3C\(A7\)/ || u ~ /MOVEQ\.L #0,D0/ || u ~ /MOVE\.W CLOCK_HALFHOURSLOTINDEX/) &&
        (u ~ /CLOCK_HALFHOURSLOTINDEX/ || prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/ ||
         u ~ /CMP\.L D0,D1/ || u ~ /CMP\.L D0,D[12]/ || prev1 ~ /CMP\.L D0,D1/ || prev1 ~ /CMP\.L D0,D[12]/)) {
        has_min_index_path = 1
    }

    if ((u ~ /MOVE\.B #\$1,TEXTDISP_BANNERFALLBACKVALIDFLAG/ || u ~ /MOVE\.B #1,TEXTDISP_BANNERFALLBACKVALIDFLAG/) &&
        (prev1 ~ /CMP\.[WL] D1,D0/ || prev1 ~ /CMP\.[WL] D1,D[0-7]/ || prev2 ~ /PEA 2\.W/ || prev2 ~ /PEA \(\$2\)\.W/ || find_mode2_calls > 0)) {
        has_mode2_fallback_mark = 1
    }
    if ((u ~ /MOVE\.W -4\(A5\),-16\(A5\)/ ||
         u ~ /MOVE\.W -4\(A5\),D0/ || u ~ /MOVE\.W D0,-16\(A5\)/ ||
         u ~ /MOVE\.L \$4C\(A7\),D0/ || u ~ /MOVE\.L D0,\$44\(A7\)/ || u ~ /MOVE\.L D1,\$44\(A7\)/) &&
        (find_mode2_calls > 0 || saw_mode2_pea || prev1 ~ /CMP\.L D1,D0/ || prev1 ~ /CMP\.W D1,D0/ ||
         prev2 ~ /CMP\.L D1,D0/ || prev2 ~ /CMP\.W D1,D0/)) {
        has_mode2_fallback_carry = 1
    }
    if ((u ~ /MOVE\.W D0,-4\(A5\)/ || u ~ /MOVE\.L D0,\$4C\(A7\)/) &&
        (find_mode3_calls > 0 || saw_mode3_pea || prev1 ~ /PEA 3\.W/ || prev1 ~ /PEA \(\$3\)\.W/ ||
         prev2 ~ /PEA 3\.W/ || prev2 ~ /PEA \(\$3\)\.W/ ||
         prev1 ~ /TEXTDISP_FINDENTRYMATCHINDEX/ || prev2 ~ /TEXTDISP_FINDENTRYMATCHINDEX/)) {
        has_mode3_requery = 1
    }

    if (u ~ /(JSR|BSR).*TEXTDISP_GETUSAGECOUNT/ || u ~ /TEXTDISP_GETUSAGECOUNT/ ||
        ((u ~ /ADDI?\.L #400,D[0-7]/ || u ~ /ADD\.L #\$190,D[0-7]/) &&
         (prev1 ~ /MOVEA\.L/ || prev1 ~ /MOVE\.L D0,A0/ || prev2 ~ /MOVEA\.L/ || prev2 ~ /MOVE\.L D0,A0/))) {
        has_usage_fetch = 1
    }

    if (u ~ /TEXTDISP_BANNERSELECTEDVALIDFLAG/ && (u ~ /MOVE\.B/ || prev1 ~ /MOVEQ(\.L)? #1,D[0-7]/)) {
        has_positive_selected = 1
    }
    if (u ~ /TEXTDISP_BANNERFALLBACKVALIDFLAG/ && (u ~ /MOVE\.B/ || prev1 ~ /MOVEQ(\.L)? #1,D[0-7]/)) {
        has_positive_fallback = 1
    }

    if (u ~ /TST\.B TEXTDISP_BANNERSELECTEDVALIDFLAG/ || u ~ /MOVE\.B TEXTDISP_BANNERSELECTEDVALIDFLAG/) {
        saw_selected_compare = 1
    }
    if (saw_selected_compare &&
        (u ~ /TEXTDISP_BANNERSELECTEDENTRYINDE/ || u ~ /TEXTDISP_BANNERSELECTEDISSPECIAL/ || u ~ /TEXTDISP_BANNERCHARSELECTED/)) {
        has_negative_selected = 1
        saw_selected_compare = 0
    }

    if (u ~ /TST\.B TEXTDISP_BANNERFALLBACKVALIDFLAG/ || u ~ /MOVE\.B TEXTDISP_BANNERFALLBACKVALIDFLAG/) {
        saw_fallback_compare = 1
    }
    if (saw_fallback_compare &&
        (u ~ /TEXTDISP_BANNERFALLBACKENTRYINDE/ || u ~ /TEXTDISP_BANNERFALLBACKISSPECIAL/ || u ~ /TEXTDISP_BANNERCHARFALLBACK/)) {
        has_negative_fallback = 1
        saw_fallback_compare = 0
    }

    if ((u ~ /MOVE\.W 0\(A0,D1\.L\),-12\(A5\)/ || u ~ /MOVE\.W D0,\$2C\(A7\)/) &&
        (prev1 ~ /ADDI?\.L #400,D1/ || prev1 ~ /ADD\.L #\$190,D1/ || prev2 ~ /ADDI?\.L #400,D1/ || prev2 ~ /ADD\.L #\$190,D1/ ||
         prev1 ~ /MOVE\.W \$28\(A7\),D0/ || prev2 ~ /MOVE\.W \$28\(A7\),D0/ || prev3 ~ /MOVE\.W \$28\(A7\),D0/)) {
        has_prev_usage_store = 1
    }
    if (u ~ /MOVE\.W D0,-6\(A5\)/ || u ~ /MOVE\.W D1,\$48\(A7\)/ || u ~ /MOVE\.W D0,\$48\(A7\)/) {
        has_last_match_store = 1
    }
    if ((u ~ /MOVEQ(\.L)? #\$2,D0/ || u ~ /MOVEQ(\.L)? #2,D0/) &&
        (prev1 ~ /SUBQ\.[BW] #1,D[0-7]/ || prev2 ~ /SUBQ\.[BW] #1,D[0-7]/ ||
         prev1 ~ /SUBQ\.[BW] #\$1,D[0-7]/ || prev2 ~ /SUBQ\.[BW] #\$1,D[0-7]/ ||
         prev1 ~ /TEXTDISP_FINDMODEACTIVEFLAG/ || prev2 ~ /TEXTDISP_FINDMODEACTIVEFLAG/ ||
         prev1 ~ /BNE\./ || prev2 ~ /BNE\./)) {
        has_findmode_return = 1
    }
    if ((u ~ /TEXTDISP_BANNERFALLBACKENTRYINDE/ || prev1 ~ /TEXTDISP_BANNERFALLBACKENTRYINDE/) && find_mode0_calls > 0) {
        has_mode0_fallback_store = 1
    }

    if (u ~ /CMPI\.W #\$31/ || u ~ /CMP\.W #\$31/ || u ~ /CMPI\.W #49/) {
        has_finalize_gate = 1
    }
    if ((u ~ /MOVEQ(\.L)? #\$64,D0/ || u ~ /MOVEQ(\.L)? #100,D0/ || u ~ /MOVE\.B D0,TEXTDISP_BANNERCHARSELECTED/) &&
        (prev1 ~ /CMPI\.W #\$3D/ || prev1 ~ /CMP\.W #\$3D/ || prev1 ~ /CMPI\.W #61/ || prev2 ~ /CMPI\.W #\$3D/ || prev2 ~ /CMP\.W #61/)) {
        has_finalize_sentinel = 1
    }

    if (u ~ /TEXTDISP_BANNERSELECTEDENTRYINDE/) {
        saw_finalize_selected = 1
    }
    if (saw_finalize_selected &&
        (u ~ /TEXTDISP_GETACTIVETITLEPTR/ || u ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/ || u ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/)) {
        has_finalize_usage_reload = 1
    }
    if (saw_finalize_selected &&
        (u ~ /(JSR|BSR).*TEXTDISP_GETACTIVETITLEPTR/ || u ~ /TEXTDISP_GETACTIVETITLEPTR/ ||
         u ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/ || u ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/)) {
        has_finalize_helper_reload = 1
    }
    if ((u ~ /ADDQ\.W #1,0\(A0,D1\.L\)/ || u ~ /MOVE\.W D1,\$0\(A0,D3\.L\)/ || u ~ /MOVE\.W D1,0\(A0,D3\.L\)/) &&
        (prev1 ~ /ADD\.L #\$190,D[13]/ || prev2 ~ /ADD\.L #\$190,D[13]/ || prev1 ~ /ADDI?\.L #400,D1/ || prev2 ~ /ADDI?\.L #400,D1/)) {
        has_finalize_usage_bump = 1
    }

    if ((u ~ /MOVEQ(\.L)? #\$3A,D0/ || u ~ /MOVEQ(\.L)? #58,D0/ ||
         u ~ /MOVEQ(\.L)? #\$44,D0/ || u ~ /MOVEQ(\.L)? #68,D0/ ||
         u ~ /MOVEQ(\.L)? #\$4E,D0/ || u ~ /MOVEQ(\.L)? #78,D0/) &&
        (prev1 ~ /CMP\.W D0,D6/ || prev2 ~ /CMP\.W D0,D6/ || prev3 ~ /CMP\.W D0,D6/)) {
        has_normalize_channel = 1
    }
    if ((u ~ /MOVEQ(\.L)? #\$44,D6/ || u ~ /MOVEQ(\.L)? #68,D6/) &&
        (prev1 ~ /CMP\.W D0,D6/ || prev2 ~ /CMP\.W D0,D6/ || prev3 ~ /CMP\.W D0,D6/)) {
        has_default68_return = 1
    }

    if (u ~ /MOVEQ(\.L)? #0,D0/ || u ~ /MOVEQ(\.L)? #\$0,D0/) {
        has_return0 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$1,D0/ || u ~ /MOVEQ(\.L)? #1,D0/) {
        has_return1 = 1
    }
    if (u ~ /MOVEQ(\.L)? #\$2,D0/ || u ~ /MOVEQ(\.L)? #2,D0/) {
        has_return2 = 1
    }
    if (u == "RTS") {
        has_rts = 1
    }

    prev5 = prev4
    prev4 = prev3
    prev3 = prev2
    prev2 = prev1
    prev1 = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INIT_SELECTED_SENTINEL=" has_init_selected
    print "HAS_INIT_FALLBACK_SENTINEL=" has_init_fallback
    print "HAS_INIT_BEST_POS_SENTINEL=" has_init_best_pos
    print "HAS_INIT_BEST_NEG_SENTINEL=" has_init_best_neg
    print "HAS_INIT_PREV_USAGE_SENTINEL=" has_init_prev_usage
    print "HAS_SPT_COMPARE_LOOP=" has_spt_compare
    print "HAS_SPT_MASK_STORE=" has_spt_mask_store
    print "HAS_CHANNEL_DEFAULT48=" has_channel_default48
    print "HAS_CHANNEL_RANGE_GATE=" has_channel_range
    print "HAS_WEEKDAY_GATE=" has_weekday_gate
    print "HAS_CANDIDATE_LOOP=" has_candidate_loop
    print "HAS_CANDIDATE_INDEX_STORE=" has_candidate_index_store
    print "FIND_MODE1_CALLS=" find_mode1_calls
    print "FIND_MODE2_CALLS=" find_mode2_calls
    print "FIND_MODE3_CALLS=" find_mode3_calls
    print "FIND_MODE0_CALLS=" find_mode0_calls
    print "TIME_OFFSET_CALLS_GE_3=" (time_offset_calls >= 3)
    print "HAS_TITLE_RESOLUTION=" has_title_resolution
    print "HAS_SPECIAL_FLAG_PATH=" has_special_flag_path
    print "HAS_MIN_INDEX_PATH=" has_min_index_path
    print "HAS_MODE2_FALLBACK_MARK=" has_mode2_fallback_mark
    print "HAS_MODE2_FALLBACK_CARRY=" has_mode2_fallback_carry
    print "HAS_MODE3_REQUERY=" has_mode3_requery
    print "HAS_USAGE_FETCH=" has_usage_fetch
    print "HAS_POSITIVE_SELECTED_UPDATE=" has_positive_selected
    print "HAS_POSITIVE_FALLBACK_UPDATE=" has_positive_fallback
    print "HAS_NEGATIVE_SELECTED_UPDATE=" has_negative_selected
    print "HAS_NEGATIVE_FALLBACK_UPDATE=" has_negative_fallback
    print "HAS_PREV_USAGE_STORE=" has_prev_usage_store
    print "HAS_LAST_MATCH_STORE=" has_last_match_store
    print "HAS_FINDMODE_EARLY_RETURN=" has_findmode_return
    print "HAS_MODE0_FALLBACK_STORE=" has_mode0_fallback_store
    print "HAS_FINALIZE_GATE=" has_finalize_gate
    print "HAS_FINALIZE_SENTINEL_RESET=" has_finalize_sentinel
    print "HAS_FINALIZE_USAGE_RELOAD=" has_finalize_usage_reload
    print "HAS_FINALIZE_HELPER_RELOAD=" has_finalize_helper_reload
    print "HAS_FINALIZE_USAGE_BUMP=" has_finalize_usage_bump
    print "HAS_NORMALIZE_CHANNEL_PATH=" has_normalize_channel
    print "HAS_DEFAULT68_RETURN=" has_default68_return
    print "HAS_RETURN0=" has_return0
    print "HAS_RETURN1=" has_return1
    print "HAS_RETURN2=" has_return2
    print "HAS_RTS=" has_rts
}
