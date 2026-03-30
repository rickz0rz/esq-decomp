BEGIN {
    has_entry = 0
    has_out_ptr_guard = 0
    has_out_clear = 0
    has_row_wrap = 0
    has_skip_time_prefix = 0
    has_base_title_nonempty = 0
    has_suffix_budget = 0
    has_reset_buckets = 0
    has_index_clamp = 0
    has_prev_gate = 0
    has_compare_chain = 0
    compare_chain_count = 0
    has_row_mark = 0
    has_showtimes_prefix = 0
    has_base_bucket_seed = 0
    has_prefix_measure = 0
    has_candidate_time_format = 0
    has_bucket_add_chain = 0
    bucket_add_count = 0
    has_overflow_measure = 0
    has_showing_at_prefix = 0
    has_bucket_append = 0
    has_genre_tail = 0
    has_rts = 0
    saw_showtimes_append = 0
    saw_showing_at_append = 0
    time_format_count = 0
    skip_class3_count = 0
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

    if (l ~ /^NEWGRID_BUILDSHOWTIMESTEXT:/ || l ~ /^NEWGRID_BUILDSHOWTIMESTEXT[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /^TST\.L 16\(A5\)$/ || l ~ /^MOVE\.L A2,D0$/) {
        has_out_ptr_guard = 1
    }

    if (l ~ /^CLR\.B \(A[0-7]\)$/ || l ~ /OUT\[0\] = 0/) {
        has_out_clear = 1
    }

    if (l ~ /^SUBI\.W #\$30,D[0-7]$/ || l ~ /^SUBI\.W #48,D[0-7]$/ || l ~ /ROW > 48/ || l ~ /ROW - 48/) {
        has_row_wrap = 1
    }

    if (l ~ /^MOVEQ(\.L)? #\$?28,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #40,D[0-7]$/ ||
        l ~ /^MOVEQ(\.L)? #\$?3A,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #58,D[0-7]$/ ||
        l ~ /SKIP_TIME_PREFIX/ || l ~ /S \+ 8/ || l ~ /ADD\.L D[0-7],-54\(A5\)/) {
        has_skip_time_prefix = 1
    }

    if (l ~ /^TST\.B \(A[0-7]\)$/) {
        has_base_title_nonempty = 1
    }

    if (l ~ /GLOBAL_STR_SINGLE_SPACE_3/ || l ~ /__MERGED\(A4\)/ || l ~ /__MERGED\+\$2\(A4\)/ ||
        l ~ /BASEF2/ || l ~ /MOVE\.L #\$264,D7/ || l ~ /WIDTHBUDGET -=/) {
        has_suffix_budget = 1
    }

    if (l ~ /NEWGRID_RESETSHOWTIMEBUCKETS/) {
        has_reset_buckets = 1
    }

    if (l ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || l ~ /CTX->STARTCOL = \(LONG\)TEXTDISP_PRIMARYGROUPENTRYCOUNT/ ||
        l ~ /CTX->ENDCOL = \(LONG\)TEXTDISP_PRIMARYGROUPENTRYCOUNT/) {
        has_index_clamp = 1
    }

    if ((l ~ /FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /PROCESSENTRYSELECTIONSTATE/) &&
        (l ~ /FIRST_ROW/ || l ~ /ROW == CTX->STARTROW/ || l ~ /CMP\.W 22\(A2\),D[0-7]/ || l ~ /CMP\.W \$16\(A2\),D[0-7]/)) {
        has_prev_gate = 1
    }
    if (l ~ /FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /PROCESSENTRYSELECTIONSTATE/) {
        has_prev_gate = 1
    }

    if (l ~ /STR_EQ_NULLABLE/ || l ~ /^\.COMPARE_(TITLE|SUBTITLE|GENRE|RATING)/ ||
        l ~ /^\.COMPARE_(TITLE|SUBTITLE|GENRE|RATING)_LOOP:/ || l ~ /CMPA\.L A0,A1/ || l ~ /CMP\.B \(A1\)\+,D0/) {
        has_compare_chain = 1
        compare_chain_count++
    }

    if (l ~ /^BSET #5,7\(A[0-7]\)$/ || l ~ /OR\.B \$7\(A[0-7]\),D[0-7]/ || l ~ /ROWFLAGS\[IDX\] \|= 0X20/) {
        has_row_mark = 1
    }

    if (l ~ /SHOWTIMES_AND_SINGLE/) {
        has_showtimes_prefix = 1
    }

    if (l ~ /ADDSHOWTIMEBUCKETENTRY/) {
        bucket_add_count++
    }

    if (l ~ /SHOWTIMES_AND_SINGLE/ || l ~ /PARSEINI_JMPTBL_STRING_APPENDATN/ && l ~ /SHOWTIMES_AND_SINGLE/) {
        saw_showtimes_append = 1
    }
    if (saw_showtimes_append && l ~ /ADDSHOWTIMEBUCKETENTRY/) {
        has_base_bucket_seed = 1
    }
    if (l ~ /SHOWTIMES_AND_SINGLE/ || l ~ /PARSEINI_JMPTBL_STRING_APPENDATN/ && l ~ /SHOWTIMES_AND_SINGLE/ ||
        l ~ /MEASURE_SHOWTIMES_PREFIX/ || l ~ /MOVE\.L #\$7FFFFFFF,\(A7\)/) {
        has_prefix_measure = 1
    }

    if (l ~ /TEXTDISP_FORMATENTRYTIMEFORINDEX/) {
        time_format_count++
    }
    if (l ~ /SKIPCLASS3CHARS/) {
        skip_class3_count++
    }
    if (time_format_count >= 2) {
        has_candidate_time_format = 1
    }

    if (l ~ /CMP\.L D1,D0/ || l ~ /COMMAWIDTH \+ W/ || l ~ /SUB\.L D1,-16\(A5\)/ || l ~ /WIDTHBUDGET -= \(COMMAWIDTH \+ W\)/) {
        has_overflow_measure = 1
    }

    if (l ~ /SHOWING_AT_AND_SINGLE/ || l ~ /PARSEINI_JMPTBL_STRING_APPENDATN/ && l ~ /SHOWING_AT_AND_SINGLE/ ||
        l ~ /APPEND_SHOWING_AT:/) {
        has_showing_at_prefix = 1
    }

    if (l ~ /NEWGRID_APPENDSHOWTIMEBUCKETS/) {
        has_bucket_append = 1
    }

    if (l ~ /NEWGRID_SHOWTIMEGENRESPACER/ || l ~ /APPEND_GENRE:/) {
        has_genre_tail = 1
    }
    if (l ~ /NEWGRID_SHOWTIMEGENRESPACER/ && l ~ /STRING_APPENDATNULL/) {
        has_genre_tail = 1
    }

    if (l == "RTS") {
        has_rts = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OUT_PTR_GUARD=" has_out_ptr_guard
    print "HAS_OUT_CLEAR=" has_out_clear
    print "HAS_ROW_WRAP=" has_row_wrap
    print "HAS_SKIP_TIME_PREFIX=" has_skip_time_prefix
    print "HAS_BASE_TITLE_NONEMPTY=" has_base_title_nonempty
    print "HAS_SUFFIX_BUDGET=" has_suffix_budget
    print "HAS_RESET_BUCKETS=" has_reset_buckets
    print "HAS_INDEX_CLAMP=" has_index_clamp
    print "HAS_PREV_GATE=" has_prev_gate
    print "HAS_COMPARE_CHAIN=" has_compare_chain
    print "HAS_COMPARE_CHAIN_DEPTH=" (compare_chain_count >= 4)
    print "HAS_ROW_MARK=" has_row_mark
    print "HAS_SHOWTIMES_PREFIX=" has_showtimes_prefix
    print "HAS_BASE_BUCKET_SEED=" has_base_bucket_seed
    print "HAS_PREFIX_MEASURE=" has_prefix_measure
    print "HAS_CANDIDATE_TIME_FORMAT=" has_candidate_time_format
    print "HAS_BUCKET_ADD_CHAIN=" (bucket_add_count >= 2)
    print "HAS_OVERFLOW_MEASURE=" has_overflow_measure
    print "HAS_SHOWING_AT_PREFIX=" has_showing_at_prefix
    print "HAS_BUCKET_APPEND=" has_bucket_append
    print "HAS_GENRE_TAIL=" has_genre_tail
    print "HAS_RTS=" has_rts
}
