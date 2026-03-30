BEGIN {
    h_entry = 0
    h_finalize = 0
    h_clamp_compare = 0
    h_clamp_max_assign = 0
    h_clamp_index_assign = 0
    h_rowheight_load = 0
    h_mulu_call = 0
    h_negative_guard = 0
    h_negative_add3 = 0
    h_shift_div4 = 0
    h_single_line_test = 0
    h_single_line_bonus = 0
    h_markers_guard = 0
    h_text_ptr_fetch = 0
    h_text_ptr_null_guard = 0
    h_find19_call = 0
    h_find19_guard = 0
    h_find20_call = 0
    h_find20_guard = 0
    h_tail_plus2 = 0
    h_return = 0

    prev = ""
    prev2 = ""
    prev3 = ""
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

    if (l ~ /^DISPTEXT_COMPUTEVISIBLELINECOUNT:/ || l ~ /^DISPTEXT_COMPUTEVISIBLELINECO[A-Z0-9_]*:/) {
        h_entry = 1
    }
    if (l ~ /DISPTEXT_FINALIZELINETABLE/ || l ~ /DISPTEXT_FINALIZELINETAB/) {
        h_finalize = 1
    }

    if (l ~ /CMP\.L D7,D0/ || l ~ /CMP\.L D7,D6/) {
        h_clamp_compare = 1
    }
    if ((l ~ /MOVE\.L D7,D1/ || l ~ /MOVE\.L D7,D6/) && h_clamp_compare) {
        h_clamp_max_assign = 1
    }
    if ((l ~ /MOVE\.W D0,D1/ || l ~ /MOVE\.W D0,D6/) && h_clamp_compare) {
        h_clamp_index_assign = 1
    }

    if (l ~ /NEWGRID_ROWHEIGHTPX/) {
        h_rowheight_load = 1
    }
    if (l ~ /GROUP_AG_JMPTBL_MATH_MULU32/ || l ~ /GROUP_AG_JMPTBL_MATH_MULU/ || l ~ /MATH_MULU32/) {
        h_mulu_call = 1
    }

    if ((l ~ /^TST\.L D0$/ || l ~ /^TST\.L D5$/) &&
        (prev ~ /MATH_MULU32/ || prev2 ~ /MATH_MULU32/ || prev3 ~ /MATH_MULU32/ ||
         prev ~ /GROUP_AG_JMPTBL_MATH_MULU/ || prev2 ~ /GROUP_AG_JMPTBL_MATH_MULU/ ||
         prev3 ~ /GROUP_AG_JMPTBL_MATH_MULU/)) {
        h_negative_guard = 1
    }
    if ((l ~ /ADDQ\.L #\$?3,D0/ || l ~ /ADDQ\.L #\$?3,D5/) &&
        (h_negative_guard || prev ~ /^TST\.L D0$/ || prev ~ /^TST\.L D5$/)) {
        h_negative_add3 = 1
    }
    if (l ~ /ASR\.L #\$?2,D0/ || l ~ /ASR\.L #\$?2,D4/) {
        h_shift_div4 = 1
    }

    if ((l ~ /CMP\.L D0,D6/ || l ~ /SUBQ\.L #\$?1,D0/) &&
        (prev ~ /MOVEQ(\.L)? #\$?1,D0/ || prev2 ~ /MOVEQ(\.L)? #\$?1,D0/ ||
         prev ~ /MOVE\.L D6,D0/ || prev2 ~ /MOVE\.L D6,D0/)) {
        h_single_line_test = 1
    }
    if (l ~ /ADDQ\.L #\$?2,D4/ || l ~ /MOVEQ #\$?2,D0/ || l ~ /MOVEQ\.L #\$?2,D0/) {
        h_single_line_bonus = 1
    }

    if (l ~ /DISPTEXT_CONTROLMARKERSENABLEDFLAG/ || l ~ /DISPTEXT_CONTROLMARKERSENABLEDFL/) {
        h_markers_guard = 1
    }

    if ((l ~ /DISPTEXT_TEXTBUFFERPTRTABLE/ || l ~ /DISPTEXT_TEXTBUFFERPTR/) &&
        (prev ~ /ASL\.L #\$?2,D1/ || prev2 ~ /ASL\.L #\$?2,D1/)) {
        h_text_ptr_fetch = 1
    }
    if ((l ~ /^BEQ\.[A-Z]* \.RETURN$/ || l ~ /^BEQ\.[A-Z]* ___DISPTEXT_COMPUTEVISIBLELINECOUNT__/) &&
        (prev ~ /MOVE\.L A1,-12\(A5\)/ || prev2 ~ /MOVE\.L A1,-12\(A5\)/ ||
         prev ~ /MOVE\.L A5,D0/ || prev2 ~ /MOVE\.L A5,D0/)) {
        h_text_ptr_null_guard = 1
    }
    if ((l ~ /^BNE\.[A-Z]* ___DISPTEXT_COMPUTEVISIBLELINECOUNT__11/ ||
         l ~ /^BNE\.[A-Z]* ___DISPTEXT_COMPUTEVISIBLELINECOUNT__/) &&
        (prev ~ /MOVE\.L A5,D0/ || prev2 ~ /MOVE\.L A5,D0/)) {
        h_text_ptr_null_guard = 1
    }

    if (l ~ /PEA 19\.W/ || l ~ /PEA \(\$13\)\.W/) {
        h_find19_call = 1
    }
    if ((l ~ /^BEQ\.[A-Z]* \.RETURN$/ || l ~ /^BNE\.[A-Z]* ___DISPTEXT_COMPUTEVISIBLELINECOUNT__13/) &&
        (prev ~ /^TST\.L D0$/ || prev2 ~ /^TST\.L D0$/)) {
        h_find19_guard = 1
    }

    if (l ~ /PEA 20\.W/ || l ~ /PEA \(\$14\)\.W/) {
        h_find20_call = 1
    }
    if ((l ~ /^BEQ\.[A-Z]* \.RETURN$/ || l ~ /^BNE\.[A-Z]* ___DISPTEXT_COMPUTEVISIBLELINECOUNT__15/) &&
        h_find20_call && (prev ~ /^TST\.L D0$/ || prev2 ~ /^TST\.L D0$/)) {
        h_find20_guard = 1
    }

    if (l ~ /ADDQ\.L #\$?2,D5/ || l ~ /ADDQ\.L #\$?2,D0/) {
        h_tail_plus2 = 1
    }
    if (l == "RTS") {
        h_return = 1
    }

    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_FINALIZE=" h_finalize
    print "HAS_CLAMP_COMPARE=" h_clamp_compare
    print "HAS_CLAMP_MAX_ASSIGN=" h_clamp_max_assign
    print "HAS_CLAMP_INDEX_ASSIGN=" h_clamp_index_assign
    print "HAS_ROWHEIGHT_LOAD=" h_rowheight_load
    print "HAS_MULU_CALL=" h_mulu_call
    print "HAS_NEGATIVE_GUARD=" h_negative_guard
    print "HAS_NEGATIVE_ADD3=" h_negative_add3
    print "HAS_SHIFT_DIV4=" h_shift_div4
    print "HAS_SINGLE_LINE_TEST=" h_single_line_test
    print "HAS_SINGLE_LINE_BONUS=" h_single_line_bonus
    print "HAS_MARKERS_GUARD=" h_markers_guard
    print "HAS_TEXT_PTR_FETCH=" h_text_ptr_fetch
    print "HAS_TEXT_PTR_NULL_GUARD=" h_text_ptr_null_guard
    print "HAS_FIND19_CALL=" h_find19_call
    print "HAS_FIND19_GUARD=" h_find19_guard
    print "HAS_FIND20_CALL=" h_find20_call
    print "HAS_FIND20_GUARD=" h_find20_guard
    print "HAS_TAIL_PLUS2=" h_tail_plus2
    print "HAS_RETURN=" h_return
}
