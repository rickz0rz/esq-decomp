BEGIN {
    has_entry = 0
    has_output_clear = 0
    has_ctx_guards = 0
    has_row_bounds = 0
    has_row_rebase = 0
    has_seed_title_setup = 0
    has_seed_field_setup = 0
    has_seed_mode_probe = 0
    has_initial_time_format = 0
    has_row_window_setup = 0
    has_preset_swap = 0
    has_candidate_index_rebase = 0
    has_candidate_skip_filters = 0
    has_candidate_title_setup = 0
    has_candidate_field_setup = 0
    has_candidate_mode_probe = 0
    has_match_compare_cluster = 0
    has_first_append_prefix = 0
    has_showtime_append = 0
    has_mark_entry_used = 0
    has_fallback_prefix = 0
    has_rts = 0

    saw_ctx_base = 0
    saw_ctx_coi = 0
    saw_ctx_entries = 0

    saw_row_nonzero = 0
    saw_row_upper_bound = 0

    saw_seed_title_ptr = 0
    saw_seed_prefix_skip = 0
    seed_field_calls = 0

    saw_modeflag_cmp = 0
    saw_eligibility_probe = 0
    mode_probe_count = 0

    saw_window_add = 0
    saw_window_cap = 0
    saw_window_inc = 0

    saw_bit_test = 0
    saw_flag5_skip = 0
    saw_title_null_skip = 0
    saw_flag7_skip = 0

    saw_candidate_title_ptr = 0
    saw_candidate_prefix_skip = 0
    candidate_field_calls = 0

    saw_title_compare = 0
    saw_mode_compare = 0
    field_compare_hits = 0

    saw_showtimes_prefix = 0
    saw_skip_class3 = 0
    append_calls = 0
    saw_separator = 0

    prev = ""
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
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^NEWGRID_APPENDSHOWTIMESFORROW:/ ||
        l ~ /^NEWGRID_APPENDSHOWTIMESFORROW[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /CLR\.B \([A0-6]\)/) {
        has_output_clear = 1
    }

    if (l ~ /MOVEA?\.L 12\(A5\),A3/ || l ~ /MOVE\.L A5,D0/) {
        saw_ctx_base = 1
    }
    if (l ~ /TST\.L \([A0-6]\)/ || l ~ /TST\.L \(A5\)/) {
        saw_ctx_coi = 1
    }
    if (l ~ /TST\.L 4\(A[035]\)/) {
        saw_ctx_entries = 1
    }
    if (saw_ctx_base && saw_ctx_coi && saw_ctx_entries) {
        has_ctx_guards = 1
    }

    if ((l ~ /TST\.W D[56]/ && prev ~ /MOVE\.W (20|\$14)\(A[35]\),D[56]/) ||
        l ~ /CMP\.W D0,D[56]/) {
        saw_row_nonzero = 1
    }
    if (l ~ /MOVEQ(\.L)? #\$61,D0/ || l ~ /MOVEQ(\.L)? #97,D0/ ||
        l ~ /CMP\.W D0,D[56]/ && prev ~ /MOVEQ(\.L)? #\$61,D0/) {
        saw_row_upper_bound = 1
    }
    if (saw_row_nonzero && saw_row_upper_bound) {
        has_row_bounds = 1
    }

    if (l ~ /SUBI?\.W #\$30,D[56]/ || l ~ /SUBI?\.W #48,D[56]/) {
        has_row_rebase = 1
    }

    if (l ~ /56\(A1\)/ || l ~ /TITLEPTRS/ || l ~ /SKIP_TIME_PREFIX/) {
        saw_seed_title_ptr = 1
    }
    if (l ~ /CMP\.B \(A6\),D0/ || l ~ /CMP\.B 3\(A6\),D0/ || l ~ /BSR\.W SKIP_TIME_PREFIX/) {
        saw_seed_prefix_skip = 1
    }
    if (saw_seed_title_ptr && saw_seed_prefix_skip) {
        has_seed_title_setup = 1
    }

    if (l ~ /COI_SELECTANIMFIELDPOIN/ || l ~ /COI_SELECTANIMFI/) {
        if (has_seed_mode_probe == 0) {
            seed_field_calls++
        } else {
            candidate_field_calls++
        }
    }
    if (seed_field_calls >= 3) {
        has_seed_field_setup = 1
    }

    if (l ~ /CMP\.L D0,D7/ || l ~ /SUBQ\.L #\$1,D0/) {
        saw_modeflag_cmp = 1
    }
    if (l ~ /TESTENTRYGRIDELIGIBILITY/ || l ~ /ESQDISP_TESTENTRYGRIDELIGIBILITY/) {
        saw_eligibility_probe = 1
        mode_probe_count++
        if (mode_probe_count == 1) {
            has_seed_mode_probe = 1
        } else if (mode_probe_count >= 2) {
            has_candidate_mode_probe = 1
        }
    }

    if (l ~ /TEXTDISP_FORMATENTRYTIMEFORINDEX/) {
        if (!has_initial_time_format) {
            has_initial_time_format = 1
        }
    }

    if (l ~ /MOVEQ(\.L)? #\$21,D[05]/ || l ~ /MOVEQ(\.L)? #32,D0/) {
        saw_window_add = 1
    }
    if (l ~ /MOVEQ(\.L)? #\$60,D0/ || l ~ /MOVEQ(\.L)? #96,D1/) {
        saw_window_cap = 1
    }
    if (l ~ /ADDQ\.W #\$1,D[56]/ || l ~ /ADDQ\.W #1,-6\(A5\)/) {
        saw_window_inc = 1
    }
    if (saw_window_add && saw_window_cap && saw_window_inc) {
        has_row_window_setup = 1
    }

    if (l ~ /NEWGRID_UPDATEPRESETENTRY/ || l ~ /CMP\.W D0,D[56]/ && prev ~ /MOVEQ(\.L)? #\$31,D0/) {
        has_preset_swap = 1
    }

    if ((l ~ /SUB\.L D1,D0/ && (prev ~ /MOVEQ(\.L)? #\$30,D1/ || prev ~ /MOVEQ(\.L)? #48,D1/)) ||
        l ~ /SUBI?\.L #\$30,D0/ ||
        (l ~ /MOVEQ(\.L)? #\$30,D0/ && prev ~ /CMP\.W D0,D[56]/)) {
        has_candidate_index_rebase = 1
    }

    if (l ~ /TESTBIT1BASED/ || l ~ /ESQ_TESTBIT1BASED/) {
        saw_bit_test = 1
    }
    if (l ~ /BTST #(\$)?5,(\$)?7\(A[01]\)/ || l ~ /& 0X20/) {
        saw_flag5_skip = 1
    }
    if (l ~ /TST\.L (56|\$38)\(A1\)/ || l ~ /TITLEPTRS\[SRCIDX\] == 0/) {
        saw_title_null_skip = 1
    }
    if (l ~ /BTST #(\$)?7,(\$)?7\(A[01]\)/ || l ~ /& 0X80/) {
        saw_flag7_skip = 1
    }
    if (saw_bit_test && saw_flag5_skip && saw_title_null_skip && saw_flag7_skip) {
        has_candidate_skip_filters = 1
    }

    if (l ~ /MOVEA?\.L 56\(A1\),A6/ || l ~ /MOVE\.L \$38\(A0\),-\(A7\)/ ||
        l ~ /-58\(A5\)/ || l ~ /TITLEPTRS\[SRCIDX\]/) {
        saw_candidate_title_ptr = 1
    }
    if (l ~ /BSR\.W SKIP_TIME_PREFIX/ || l ~ /CMP\.B \(A6\),D0/ ||
        l ~ /CMP\.B 3\(A6\),D0/) {
        saw_candidate_prefix_skip = 1
    }
    if (saw_candidate_title_ptr && saw_candidate_prefix_skip) {
        has_candidate_title_setup = 1
    }

    if (candidate_field_calls >= 4) {
        has_candidate_field_setup = 1
    }

    if (l ~ /COMPARE_TITLE_LOOP/ || l ~ /STR_EQ_NULLABLE/ || l ~ /CMPA\.L A0,A1/) {
        saw_title_compare = 1
    }
    if (l ~ /MOVE\.B -53\(A5\),D0/ || l ~ /CMP\.B D1,D0/ ||
        l ~ /CMP\.B \$1F\(A7\),D0/ || l ~ /MODE0 != MODEN/) {
        saw_mode_compare = 1
    }
    if (l ~ /BSR\.W STR_EQ_NULLABLE/ || l ~ /COMPARE_FIELD[134]/ ||
        l ~ /STR_EQ_NULLABLE\(F[123]_0,F[123]_N\)/) {
        field_compare_hits++
    }
    if (saw_title_compare && saw_mode_compare && field_compare_hits >= 3) {
        has_match_compare_cluster = 1
    }

    if (l ~ /SHOWTIMES_AND_SINGLE/ || l ~ /COPY_SHOWTIMES_PREFIX/) {
        saw_showtimes_prefix = 1
    }
    if (l ~ /STR_SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CHARS/ || l ~ /SKIPCLASS3CH/) {
        saw_skip_class3 = 1
    }
    if (l ~ /STRING_APPENDATNULL/ || l ~ /APPENDATNULL/ || l ~ /APPENDATN/) {
        append_calls++
    }
    if (saw_showtimes_prefix && saw_skip_class3 && append_calls >= 2) {
        has_first_append_prefix = 1
    }

    if (l ~ /SHOWTIMELISTSEPARATOR/) {
        saw_separator = 1
    }
    if (saw_separator && append_calls >= 4) {
        has_showtime_append = 1
    }

    if (l ~ /BSET #5,7\(A0\)/ || l ~ /OR\.B \$7\(A0\),D0/ || l ~ /\|= 0X20/) {
        has_mark_entry_used = 1
    }

    if ((l ~ /SHOWING_AT_AND_SINGLE/ || l ~ /COPY_SHOWING_AT_PREFIX/) &&
        saw_skip_class3 && append_calls >= 2) {
        has_fallback_prefix = 1
    }

    if (l == "RTS") {
        has_rts = 1
    }

    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OUTPUT_CLEAR=" has_output_clear
    print "HAS_CTX_GUARDS=" has_ctx_guards
    print "HAS_ROW_BOUNDS=" has_row_bounds
    print "HAS_ROW_REBASE=" has_row_rebase
    print "HAS_SEED_TITLE_SETUP=" has_seed_title_setup
    print "HAS_SEED_FIELD_SETUP=" has_seed_field_setup
    print "HAS_SEED_MODE_PROBE=" has_seed_mode_probe
    print "HAS_INITIAL_TIME_FORMAT=" has_initial_time_format
    print "HAS_ROW_WINDOW_SETUP=" has_row_window_setup
    print "HAS_PRESET_SWAP=" has_preset_swap
    print "HAS_CANDIDATE_INDEX_REBASE=" has_candidate_index_rebase
    print "HAS_CANDIDATE_SKIP_FILTERS=" has_candidate_skip_filters
    print "HAS_CANDIDATE_TITLE_SETUP=" has_candidate_title_setup
    print "HAS_CANDIDATE_FIELD_SETUP=" has_candidate_field_setup
    print "HAS_CANDIDATE_MODE_PROBE=" has_candidate_mode_probe
    print "HAS_MATCH_COMPARE_CLUSTER=" has_match_compare_cluster
    print "HAS_FIRST_APPEND_PREFIX=" has_first_append_prefix
    print "HAS_SHOWTIME_APPEND=" has_showtime_append
    print "HAS_MARK_ENTRY_USED=" has_mark_entry_used
    print "HAS_FALLBACK_PREFIX=" has_fallback_prefix
    print "HAS_RTS=" has_rts
}
