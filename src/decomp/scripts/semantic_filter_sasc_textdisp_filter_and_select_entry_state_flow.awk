BEGIN {
    has_entry = 0
    has_input_invalidate = 0
    has_mode_f_setup = 0
    has_default_mode3 = 0
    has_scan_init = 0
    has_scan_fetch = 0
    has_hidden_gate = 0
    has_ppv_gate = 0
    has_sports_gate = 0
    has_name_filter_gate = 0
    has_record_match = 0
    has_cursor_seed = 0
    has_no_match_sentinel = 0
    has_aux_fetch = 0
    has_primary_backtrack = 0
    has_time_window = 0
    has_skip_codes = 0
    has_grid_gate = 0
    has_title_compare = 0
    has_selection_bit_gate = 0
    has_commit_selection = 0
    has_build_detail = 0
    has_cursor_advance = 0
    has_slot_advance = 0
    has_mode2_transition = 0
    has_mode3_transition = 0
    has_reset = 0
    has_return = 0

    saw_ppv_tag = 0
    saw_sbe_tag = 0
    saw_sports_tag = 0
    saw_scan_count = 0
    saw_mode_primary = 0
    saw_cursor_clear = 0
    saw_half_hour = 0
    saw_compare_name_loop = 0

    phase_mode_f_setup = 0
    phase_scan_init = 0
    phase_record_match = 0
    phase_cursor_seed = 0
    phase_primary_backtrack = 0
    phase_time_window = 0
    phase_grid_gate = 0
    phase_title_compare = 0
    phase_selection_commit = 0
    phase_slot_advance = 0
    phase_mode2_transition = 0
    phase_mode3_transition = 0
    phase_reset = 0

    prev1 = ""
    prev2 = ""
    prev3 = ""
    prev4 = ""
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
    if (line == "") {
        next
    }

    if (line ~ /^TEXTDISP_FILTERANDSELECTENTRY:/ ||
        line ~ /^TEXTDISP_FILTERANDSELECTENT[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if ((line ~ /^MOVEQ(\.L)? #0,D7$/ || line ~ /^MOVEQ(\.L)? #\$0,D7$/) &&
        (prev1 ~ /^MOVE\.L A3,D0$/ || prev2 ~ /^MOVE\.L A3,D0$/ ||
         prev1 ~ /^TST\.B \(A0\)$/ || prev2 ~ /^TST\.B \(A0\)$/)) {
        has_input_invalidate = 1
    }

    if (line ~ /SCRIPT_FILTERTAG_PPV/) {
        saw_ppv_tag = 1
    }
    if (line ~ /SCRIPT_FILTERTAG_SBE/) {
        saw_sbe_tag = 1
    }
    if (line ~ /SCRIPT_FILTERTAG_SPORTS/) {
        saw_sports_tag = 1
    }
    if (line ~ /TEXTDISP_FILTERCHANNELSLOTINDEX/ && line ~ /^CLR\.W /) {
        saw_mode_primary = 1
    }
    if (line ~ /MOVE\.B #\$1,TEXTDISP_FILTERMODEID/ || line ~ /MOVE\.B #1,TEXTDISP_FILTERMODEID/) {
        saw_mode_primary = 1
    }
    if (saw_mode_primary && saw_ppv_tag && saw_sbe_tag && saw_sports_tag) {
        has_mode_f_setup = 1
        if (!phase_mode_f_setup) {
            print "PHASE_MODE_F_SETUP"
            phase_mode_f_setup = 1
        }
    }

    if (line ~ /MOVE\.B #\$3,TEXTDISP_FILTERMODEID/ || line ~ /MOVE\.B #3,TEXTDISP_FILTERMODEID/) {
        has_default_mode3 = 1
        if ((prev1 ~ /SUBQ\.W #1,D0/ || prev2 ~ /SUBQ\.W #1,D0/ ||
             prev3 ~ /SUBQ\.W #1,D0/ || prev1 ~ /CMPI\.W #\$30,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
             prev2 ~ /CMPI\.W #\$30,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
             prev1 ~ /CMPI\.W #48,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
             prev2 ~ /CMPI\.W #48,TEXTDISP_FILTERCHANNELSLOTINDEX/)) {
            has_mode3_transition = 1
            if (!phase_mode3_transition) {
                print "PHASE_MODE3_TRANSITION"
                phase_mode3_transition = 1
            }
        }
    }

    if (line ~ /TEXTDISP_GETGROUPENTRYCOUNT/) {
        saw_scan_count = 1
    }
    if (saw_scan_count &&
        (line ~ /^MOVE\.W D0,TEXTDISP_FILTERMATCHCOUNT(\(A4\))?$/ ||
         line ~ /^CLR\.W TEXTDISP_FILTERMATCHCOUNT(\(A4\))?$/)) {
        has_scan_init = 1
        if (!phase_scan_init) {
            print "PHASE_SCAN_INIT"
            phase_scan_init = 1
        }
    }

    if (line ~ /GETENTRYPOINTERBYMODE/ || line ~ /GETENTRYPO$/ || line ~ /GETENTRYPO[A-Z0-9]*/) {
        has_scan_fetch = 1
    }
    if (line ~ /BTST #3,27\(A0\)/ || line ~ /BTST #\$3,\$1B\(A0\)/) {
        has_hidden_gate = 1
    }
    if ((line ~ /TEXTDISP_FILTERPPVSBEMATCHFLAG/ || prev1 ~ /TEXTDISP_FILTERPPVSBEMATCHFLAG/ ||
         prev2 ~ /TEXTDISP_FILTERPPVSBEMATCHFLAG/) &&
        (line ~ /BTST #4,27\(A0\)/ || line ~ /BTST #\$4,\$1B\(A0\)/ ||
         prev1 ~ /BTST #4,27\(A0\)/ || prev1 ~ /BTST #\$4,\$1B\(A0\)/ ||
         prev2 ~ /BTST #4,27\(A0\)/ || prev2 ~ /BTST #\$4,\$1B\(A0\)/)) {
        has_ppv_gate = 1
    }
    if (line ~ /TEXTDISP_SHOULDOPENEDITORFORENTR/ || line ~ /TEXTDISP_SHOULDOPENEDITORFORENTRY/) {
        has_sports_gate = 1
    }
    if ((line ~ /ESQ_WILDCARDMATCH/ || line ~ /UNKNOWN_JMPTBL_ESQ_WILDCARDMATCH/ ||
         line ~ /UNKNOWN_JMPTBL_ESQ_WILDCAR/) &&
        (prev1 ~ /ADDA\.W #12,A0/ || prev2 ~ /ADDA\.W #12,A0/ ||
         prev1 ~ /ADDA\.L #12,A0/ || prev2 ~ /ADDA\.L #12,A0/ ||
         prev1 ~ /ADD\.W #\$C,A0/ || prev2 ~ /ADD\.W #\$C,A0/ ||
         prev1 ~ /ADD\.W #12,A0/ || prev2 ~ /ADD\.W #12,A0/ ||
         prev1 ~ /TAGTEXT/ || prev2 ~ /TAGTEXT/)) {
        has_name_filter_gate = 1
    }

    if (((line ~ /TEXTDISP_FILTERMATCHCOUNT/ || prev1 ~ /TEXTDISP_FILTERMATCHCOUNT/ || prev2 ~ /TEXTDISP_FILTERMATCHCOUNT/) &&
         (line ~ /TEXTDISP_CANDIDATEINDEXLIST/ || prev1 ~ /TEXTDISP_CANDIDATEINDEXLIST/ || prev2 ~ /TEXTDISP_CANDIDATEINDEXLIST/)) ||
        ((line ~ /MOVE\.B D[0-7],\$0\(A[01],D[12]\.L\)/ || line ~ /MOVE\.B D[01],\(A0\)/ || line ~ /MOVE\.B D1,\(A0\)/) &&
         (prev1 ~ /TEXTDISP_CANDIDATEINDEXLIST/ || prev2 ~ /TEXTDISP_CANDIDATEINDEXLIST/))) {
        has_record_match = 1
        if (!phase_record_match) {
            print "PHASE_RECORD_MATCH"
            phase_record_match = 1
        }
    }

    if (line ~ /CLOCK_HALFHOURSLOTINDEX/) {
        saw_half_hour = 1
    }
    if (line ~ /^CLR\.W TEXTDISP_FILTERCANDIDATECURSOR(\(A4\))?$/) {
        saw_cursor_clear = 1
    }
    if (saw_cursor_clear &&
        (line ~ /MOVE\.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
         line ~ /MOVE\.W CLOCK_HALFHOURSLOTINDEX,D0/ ||
         line ~ /MOVEQ(\.L)? #1,D0/ || line ~ /MOVEQ(\.L)? #\$1,D0/ ||
         prev1 ~ /MOVEQ(\.L)? #1,D0/ || prev1 ~ /MOVEQ(\.L)? #\$1,D0/ ||
         prev1 ~ /MOVE\.W CLOCK_HALFHOURSLOTINDEX,D0/ || prev1 ~ /MOVE\.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
         prev2 ~ /MOVE\.W CLOCK_HALFHOURSLOTINDEX,D0/ || prev2 ~ /MOVE\.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX/)) {
        has_cursor_seed = 1
    }
    if (line ~ /MOVE\.W #\$31,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
        line ~ /MOVEQ\.L #\$31,D1/ || line ~ /CMPI\.W #\$31,TEXTDISP_FILTERCHANNELSLOTINDEX/) {
        has_no_match_sentinel = 1
    }

    if (line ~ /GETENTRYAUXPOINTERBYMODE/ || line ~ /GETENTRYAU$/ || line ~ /GETENTRYAU[A-Z0-9]*/) {
        has_aux_fetch = 1
    }
    if ((saw_half_hour || prev1 ~ /CLOCK_HALFHOURSLOTINDEX/ || prev2 ~ /CLOCK_HALFHOURSLOTINDEX/) &&
        (line ~ /SUBQ\.W #1,-22\(A5\)/ || line ~ /SUBQ\.W #\$1,-22\(A5\)/ ||
         line ~ /SUBQ\.L #\$1,\$28\(A7\)/ || line ~ /SUBQ\.L #1,\$28\(A7\)/)) {
        has_primary_backtrack = 1
        if (!phase_primary_backtrack) {
            print "PHASE_PRIMARY_BACKTRACK"
            phase_primary_backtrack = 1
        }
    }

    if (line ~ /TESTENTRYWITHINTIMEWINDOW/ || line ~ /TESTENTRYWITHI/ || line ~ /COI_TESTENTRYWITHI/) {
        has_time_window = 1
        if (!phase_time_window) {
            print "PHASE_TIME_WINDOW_VALIDATE"
            phase_time_window = 1
        }
    }
    if (line ~ /TEXTDISP_SKIPCONTROLCODES/) {
        has_skip_codes = 1
    }
    if (line ~ /TESTENTRYGRIDELIGIBILITY/) {
        has_grid_gate = 1
        if (!phase_grid_gate) {
            print "PHASE_GRID_GATE"
            phase_grid_gate = 1
        }
    }

    if (line ~ /^TST\.B \(A0\)\+?$/ || line ~ /^TST\.B \(A0\)$/) {
        saw_compare_name_loop = 1
    }
    if (line ~ /STRING_COMPARENOCASEN/ || line ~ /STRING_COMPARENOCASE/) {
        has_title_compare = 1
        if (saw_compare_name_loop && !phase_title_compare) {
            print "PHASE_TITLE_COMPARE"
            phase_title_compare = 1
        }
    }
    if (line ~ /ESQ_TESTBIT1BASED/ || line ~ /TLIBA2_JMPTBL_ESQ_TESTBIT1BASED/ ||
        line ~ /TLIBA2_JMPTBL_ESQ_TESTBIT1B/) {
        has_selection_bit_gate = 1
    }
    if (line ~ /TEXTDISP_SETSELECTIONFIELDS/) {
        has_commit_selection = 1
        if (!phase_selection_commit) {
            print "PHASE_SELECTION_COMMIT"
            phase_selection_commit = 1
        }
    }
    if (line ~ /TEXTDISP_BUILDENTRYDETAILLINE/) {
        has_build_detail = 1
    }

    if (line ~ /ADDQ\.W #1,TEXTDISP_FILTERCANDIDATECURSOR/ ||
        ((line ~ /MOVE\.W D[01],TEXTDISP_FILTERCANDIDATECURSOR/ ||
          line ~ /MOVE\.W D0,TEXTDISP_FILTERCANDIDATECURSOR/ ||
          line ~ /MOVE\.W D1,TEXTDISP_FILTERCANDIDATECURSOR/ ||
          line ~ /MOVE\.W D0,TEXTDISP_FILTERCANDIDATECURSOR\(A4\)/ ||
          line ~ /MOVE\.W D1,TEXTDISP_FILTERCANDIDATECURSOR\(A4\)/) &&
         (prev1 ~ /ADDQ\.W #1,D0/ || prev1 ~ /ADDQ\.W #1,D1/ ||
          prev1 ~ /ADDQ\.W #\$1,D0/ || prev1 ~ /ADDQ\.W #\$1,D1/ ||
          prev2 ~ /ADDQ\.W #1,D0/ || prev2 ~ /ADDQ\.W #1,D1/ ||
          prev2 ~ /ADDQ\.W #\$1,D0/ || prev2 ~ /ADDQ\.W #\$1,D1/))) {
        has_cursor_advance = 1
    }
    if ((line ~ /ADDQ\.W #1,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
         line ~ /ADDQ\.W #\$1,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
         line ~ /ADDQ\.W #1,TEXTDISP_FILTERCHANNELSLOTINDEX\(A4\)/ ||
         line ~ /ADDQ\.W #\$1,TEXTDISP_FILTERCHANNELSLOTINDEX\(A4\)/) ||
        ((line ~ /ADDQ\.W #1,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
          line ~ /ADDQ\.W #\$1,TEXTDISP_FILTERCHANNELSLOTINDEX/ ||
          line ~ /ADDQ\.L #\$1,TEXTDISP_FILTERCHANNELSLOTINDEX/) &&
         (prev1 ~ /TEXTDISP_FILTERCANDIDATECURSOR/ || prev2 ~ /TEXTDISP_FILTERCANDIDATECURSOR/ ||
          prev1 ~ /^CLR\.W TEXTDISP_FILTERCANDIDATECURSOR$/ || prev2 ~ /^CLR\.W TEXTDISP_FILTERCANDIDATECURSOR$/)) ||
        ((line ~ /^CLR\.W TEXTDISP_FILTERCANDIDATECURSOR(\(A4\))?$/ || prev1 ~ /^CLR\.W TEXTDISP_FILTERCANDIDATECURSOR(\(A4\))?$/) &&
          (prev1 ~ /MOVE\.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX/ || prev2 ~ /MOVE\.W D0,TEXTDISP_FILTERCHANNELSLOTINDEX/))) {
        has_slot_advance = 1
    }

    if (line ~ /MOVE\.B #\$2,TEXTDISP_FILTERMODEID/ || line ~ /MOVE\.B #2,TEXTDISP_FILTERMODEID/) {
        has_mode2_transition = 1
        if (!phase_mode2_transition) {
            print "PHASE_MODE2_TRANSITION"
            phase_mode2_transition = 1
        }
    }

    if (line ~ /TEXTDISP_RESETSELECTIONSTATE/) {
        has_reset = 1
        if (!phase_reset) {
            print "PHASE_RESET_SELECTION"
            phase_reset = 1
        }
    }

    if (line == "RTS") {
        has_return = 1
    }

    prev4 = prev3
    prev3 = prev2
    prev2 = prev1
    prev1 = line
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INPUT_INVALIDATE=" has_input_invalidate
    print "HAS_MODE_F_SETUP=" has_mode_f_setup
    print "HAS_DEFAULT_MODE3=" has_default_mode3
    print "HAS_SCAN_INIT=" has_scan_init
    print "HAS_SCAN_FETCH=" has_scan_fetch
    print "HAS_HIDDEN_GATE=" has_hidden_gate
    print "HAS_PPV_GATE=" has_ppv_gate
    print "HAS_SPORTS_GATE=" has_sports_gate
    print "HAS_NAME_FILTER_GATE=" has_name_filter_gate
    print "HAS_RECORD_MATCH=" has_record_match
    print "HAS_CURSOR_SEED=" has_cursor_seed
    print "HAS_NO_MATCH_SENTINEL=" has_no_match_sentinel
    print "HAS_AUX_FETCH=" has_aux_fetch
    print "HAS_PRIMARY_BACKTRACK=" has_primary_backtrack
    print "HAS_TIME_WINDOW=" has_time_window
    print "HAS_SKIP_CODES=" has_skip_codes
    print "HAS_GRID_GATE=" has_grid_gate
    print "HAS_TITLE_COMPARE=" has_title_compare
    print "HAS_SELECTION_BIT_GATE=" has_selection_bit_gate
    print "HAS_COMMIT_SELECTION=" has_commit_selection
    print "HAS_BUILD_DETAIL=" has_build_detail
    print "HAS_CURSOR_ADVANCE=" has_cursor_advance
    print "HAS_SLOT_ADVANCE=" has_slot_advance
    print "HAS_MODE2_TRANSITION=" has_mode2_transition
    print "HAS_MODE3_TRANSITION=" has_mode3_transition
    print "HAS_RESET=" has_reset
    print "HAS_RETURN=" has_return
}
