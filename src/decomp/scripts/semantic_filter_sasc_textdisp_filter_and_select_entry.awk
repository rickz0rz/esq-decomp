BEGIN {
    has_entry = 0
    has_mode_f = 0
    has_mode_x = 0
    has_mode1 = 0
    has_mode_default_done = 0
    has_done_guard = 0
    has_filter_slot = 0
    has_filter_mode = 0
    has_filter_ppv = 0
    has_filter_sports = 0
    has_filter_match_count = 0
    has_filter_cursor = 0
    has_cursor_reset = 0
    has_cursor_bump = 0
    has_candidate_list = 0
    has_wildcard = 0
    has_count = 0
    has_get_entry = 0
    has_get_aux = 0
    has_aux_null_skip = 0
    has_window = 0
    has_hidden_bit = 0
    has_ppv_bit = 0
    has_should_open_editor = 0
    has_skip_codes = 0
    has_grid = 0
    has_grid_skip = 0
    has_half_hour = 0
    has_primary_slot_seed = 0
    has_default_slot_seed = 0
    has_half_hour_backtrack = 0
    has_sentinel = 0
    has_slot_last_guard = 0
    has_time_window = 0
    has_name_scan = 0
    has_cmp = 0
    has_testbit = 0
    has_selection_bit_accept = 0
    has_found_flag = 0
    has_set_selection = 0
    has_build_detail = 0
    has_reset = 0
    has_slot_advance = 0
    has_slot_reset = 0
    has_mode2 = 0
    has_mode3 = 0
    has_title_backtrack_loop = 0
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

    if (u ~ /^TEXTDISP_FILTERANDSELECTENTRY:/ || u ~ /^TEXTDISP_FILTERANDSELECTENT[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "#$46") > 0) has_mode_f = 1
    if (index(u, "#$58") > 0 || index(u, "SUBI.W #18,D0") > 0) has_mode_x = 1
    if (index(u, "MOVE.B #$1,TEXTDISP_FILTERMODEID") > 0) has_mode1 = 1
    if (index(u, "MOVE.B #$3,TEXTDISP_FILTERMODEID") > 0) has_mode_default_done = 1
    if (index(u, "MOVEQ #3,D1") > 0 || index(u, "SUBQ.B #$3,D0") > 0) has_done_guard = 1
    if (index(u, "TEXTDISP_FILTERCHANNELSLOTINDEX") > 0) has_filter_slot = 1
    if (index(u, "TEXTDISP_FILTERMODEID") > 0) has_filter_mode = 1
    if (index(u, "TEXTDISP_FILTERPPVSBEMATCHFLAG") > 0 || index(u, "TEXTDISP_FILTERPPVSBEMATCHFLAG") > 0) has_filter_ppv = 1
    if (index(u, "TEXTDISP_FILTERSPORTSMATCHFLAG") > 0) has_filter_sports = 1
    if (index(u, "TEXTDISP_FILTERMATCHCOUNT") > 0) has_filter_match_count = 1
    if (index(u, "TEXTDISP_FILTERCANDIDATECURSOR") > 0) has_filter_cursor = 1
    if (index(u, "CLR.W TEXTDISP_FILTERCANDIDATECURSOR") > 0) has_cursor_reset = 1
    if (index(u, "ADDQ.W #1,TEXTDISP_FILTERCANDIDATECURSOR") > 0 ||
        index(u, "MOVE.W D0,TEXTDISP_FILTERCANDIDATECURSOR") > 0) has_cursor_bump = 1
    if (index(u, "TEXTDISP_CANDIDATEINDEXLIST") > 0) has_candidate_list = 1
    if (index(u, "UNKNOWN_JMPTBL_ESQ_WILDCARDMATCH") > 0 || index(u, "UNKNOWN_JMPTBL_ESQ_WILDCAR") > 0 ||
        index(u, "ESQ_WILDCARDMATCH") > 0 || index(u, "ESQ_WILDCARDMATC") > 0) has_wildcard = 1
    if (index(u, "TEXTDISP_GETGROUPENTRYCOUNT") > 0 || index(u, "TEXTDISP_GETGROUPENTR") > 0) has_count = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYPO") > 0) has_get_entry = 1
    if (index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAUXPOINTERBYMODE") > 0 || index(u, "TLIBA1_JMPTBL_ESQDISP_GETENTRYAU") > 0) has_get_aux = 1
    if (index(u, "MOVE.L D0,-4(A5)") > 0 || index(u, "MOVE.L D0,$3C(A7)") > 0) has_aux_null_skip = 1
    if (index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHINTIMEWINDOW") > 0 || index(u, "TLIBA1_JMPTBL_COI_TESTENTRYWITHI") > 0) has_window = 1
    if (index(u, "BTST #3,27(A0)") > 0 || index(u, "BTST #$3,$1B(A0)") > 0) has_hidden_bit = 1
    if (index(u, "BTST #4,27(A0)") > 0 || index(u, "BTST #$4,$1B(A0)") > 0) has_ppv_bit = 1
    if (index(u, "TEXTDISP_SHOULDOPENEDITORFORENTR") > 0 || index(u, "TEXTDISP_SHOULDOPENEDITORFORENTRY") > 0) has_should_open_editor = 1
    if (index(u, "TEXTDISP_SKIPCONTROLCODES") > 0 || index(u, "TEXTDISP_SKIPCONTROLC") > 0) has_skip_codes = 1
    if (index(u, "TEXTDISP_JMPTBL_ESQDISP_TESTENTRYGRIDELIGIBILITY") > 0 || index(u, "TEXTDISP_JMPTBL_ESQDISP_TESTENTRYGR") > 0 ||
        index(u, "TEXTDISP_JMPTBL_ESQDISP_TESTENTR") > 0 || index(u, "ESQDISP_TESTENTRYGRIDELIGIBILITY") > 0 ||
        index(u, "ESQDISP_TESTENTRYGRIDELIGIB") > 0) has_grid = 1
    if (index(u, "BEQ.W .NEXT_CURSOR_ENTRY") > 0 || index(u, "BEQ.B ___TEXTDISP_FILTERANDSELECTENTRY__62") > 0) has_grid_skip = 1
    if (index(u, "CLOCK_HALFHOURSLOTINDEX") > 0) has_half_hour = 1
    if (index(u, "MOVE.W CLOCK_HALFHOURSLOTINDEX,D0") > 0 || index(u, "MOVE.W CLOCK_HALFHOURSLOTINDEX(A4),D0") > 0 ||
        index(u, "MOVE.W CLOCK_HALFHOURSLOTINDEX,D1") > 0 || index(u, "MOVE.W CLOCK_HALFHOURSLOTINDEX(A4),D1") > 0) has_primary_slot_seed = 1
    if (index(u, "MOVEQ #1,D0") > 0 || index(u, "MOVEQ.L #$1,D0") > 0) has_default_slot_seed = 1
    if (index(u, "SUBQ.W #1,-22(A5)") > 0 || index(u, "SUBQ.L #$1,$28(A7)") > 0) has_half_hour_backtrack = 1
    if (((prev_u == "TST.L -26(A5)") && index(u, "BNE.S .ENSURE_CHANNEL_ENTRY") > 0) ||
        ((prev_u == "TST.L $40(A7)") && index(u, "BNE.B ___TEXTDISP_FILTERANDSELECTENTRY__50") > 0)) has_title_backtrack_loop = 1
    if (index(u, "MOVE.W #$31,TEXTDISP_FILTERCHANNELSLOTINDEX") > 0 || index(u, "CMPI.W #$31,TEXTDISP_FILTERCHANNELSLOTINDEX") > 0 ||
        index(u, "MOVEQ.L #$31,D1") > 0) has_sentinel = 1
    if (index(u, "CMPI.W #$30,TEXTDISP_FILTERCHANNELSLOTINDEX") > 0 || index(u, "MOVEQ.L #$30,D1") > 0) has_slot_last_guard = 1
    if (index(u, "CONFIG_TIMEWINDOWMINUTES") > 0 || index(u, "1440.W") > 0 || index(u, "#$5A0") > 0) has_time_window = 1
    if (index(u, "TST.B (A0)+") > 0 || index(u, "ADDQ.L #$1,$1C(A7)") > 0) has_name_scan = 1
    if (index(u, "STRING_COMPARENOCASEN") > 0 || index(u, "STRING_COMPARENOCASE") > 0) has_cmp = 1
    if (index(u, "TLIBA2_JMPTBL_ESQ_TESTBIT1BASED") > 0 || index(u, "TLIBA2_JMPTBL_ESQ_TESTBIT1B") > 0 ||
        index(u, "ESQ_TESTBIT1BASED") > 0 || index(u, "ESQ_TESTBIT1BASE") > 0) has_testbit = 1
    if (index(u, "ADDQ.L #1,D0") > 0 || index(u, "ADDQ.L #$1,D0") > 0) has_selection_bit_accept = 1
    if (index(u, "MOVE.L D0,-20(A5)") > 0 || index(u, "MOVEQ.L #$1,D6") > 0) has_found_flag = 1
    if (index(u, "TEXTDISP_SETSELECTIONFIELDS") > 0 || index(u, "TEXTDISP_SETSELECTIONF") > 0) has_set_selection = 1
    if (index(u, "TEXTDISP_BUILDENTRYDETAILLINE") > 0 || index(u, "TEXTDISP_BUILDENTRYDETAI") > 0) has_build_detail = 1
    if (index(u, "TEXTDISP_RESETSELECTIONSTATE") > 0 || index(u, "TEXTDISP_RESETSELECTIO") > 0) has_reset = 1
    if (index(u, "ADDQ.W #1,TEXTDISP_FILTERCHANNELSLOTINDEX") > 0 || index(u, "MOVE.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX") > 0) has_slot_advance = 1
    if (index(u, "CLR.W TEXTDISP_FILTERCHANNELSLOTINDEX") > 0) has_slot_reset = 1
    if (index(u, "MOVE.B #$2,TEXTDISP_FILTERMODEID") > 0 || index(u, "MOVE.B D0,TEXTDISP_FILTERMODEID") > 0) has_mode2 = 1
    if (index(u, "MOVE.B #$3,TEXTDISP_FILTERMODEID") > 0 || index(u, "MOVE.B D0,TEXTDISP_FILTERMODEID") > 0) has_mode3 = 1
    if (u == "RTS") has_return = 1
    prev_u = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MODE_F=" has_mode_f
    print "HAS_MODE_X=" has_mode_x
    print "HAS_MODE1=" has_mode1
    print "HAS_MODE_DEFAULT_DONE=" has_mode_default_done
    print "HAS_DONE_GUARD=" has_done_guard
    print "HAS_FILTER_SLOT=" has_filter_slot
    print "HAS_FILTER_MODE=" has_filter_mode
    print "HAS_FILTER_PPV=" has_filter_ppv
    print "HAS_FILTER_SPORTS=" has_filter_sports
    print "HAS_FILTER_MATCH_COUNT=" has_filter_match_count
    print "HAS_FILTER_CURSOR=" has_filter_cursor
    print "HAS_CURSOR_RESET=" has_cursor_reset
    print "HAS_CURSOR_BUMP=" has_cursor_bump
    print "HAS_CANDIDATE_LIST=" has_candidate_list
    print "HAS_WILDCARD=" has_wildcard
    print "HAS_COUNT=" has_count
    print "HAS_GET_ENTRY=" has_get_entry
    print "HAS_GET_AUX=" has_get_aux
    print "HAS_AUX_NULL_SKIP=" has_aux_null_skip
    print "HAS_WINDOW=" has_window
    print "HAS_HIDDEN_BIT=" has_hidden_bit
    print "HAS_PPV_BIT=" has_ppv_bit
    print "HAS_SHOULD_OPEN_EDITOR=" has_should_open_editor
    print "HAS_SKIP_CODES=" has_skip_codes
    print "HAS_GRID=" has_grid
    print "HAS_GRID_SKIP=" has_grid_skip
    print "HAS_HALF_HOUR=" has_half_hour
    print "HAS_PRIMARY_SLOT_SEED=" has_primary_slot_seed
    print "HAS_DEFAULT_SLOT_SEED=" has_default_slot_seed
    print "HAS_HALF_HOUR_BACKTRACK=" has_half_hour_backtrack
    print "HAS_TITLE_BACKTRACK_LOOP=" has_title_backtrack_loop
    print "HAS_SENTINEL=" has_sentinel
    print "HAS_SLOT_LAST_GUARD=" has_slot_last_guard
    print "HAS_TIME_WINDOW=" has_time_window
    print "HAS_NAME_SCAN=" has_name_scan
    print "HAS_CMP=" has_cmp
    print "HAS_TESTBIT=" has_testbit
    print "HAS_SELECTION_BIT_ACCEPT=" has_selection_bit_accept
    print "HAS_FOUND_FLAG=" has_found_flag
    print "HAS_SET_SELECTION=" has_set_selection
    print "HAS_BUILD_DETAIL=" has_build_detail
    print "HAS_RESET=" has_reset
    print "HAS_SLOT_ADVANCE=" has_slot_advance
    print "HAS_SLOT_RESET=" has_slot_reset
    print "HAS_MODE2=" has_mode2
    print "HAS_MODE3=" has_mode3
    print "HAS_RETURN=" has_return
}
