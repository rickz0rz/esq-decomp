BEGIN {
    has_entry = 0
    has_dot_compare = 0
    has_colon_compare = 0
    has_star_compare = 0
    has_qmark_compare = 0
    has_index_zero_gate = 0
    has_split_flag_init = 0
    has_prev_char_init = 0
    has_suffix_gate_init = 0
    has_dot_split_transition = 0
    has_colon_gate_reset = 0
    has_colon_gate_prev = 0
    has_main_store = 0
    has_suffix_store = 0
    has_terminate_main = 0
    has_terminate_suffix = 0
    has_main_empty_minus1 = 0
    has_main_match = 0
    has_suffix_match_gate = 0
    has_suffix_match = 0
    has_final_gate = 0
    has_return_true = 0
    has_return_false = 0
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

    if (u ~ /^ESQSHARED_MATCHSELECTIONCODEWITHOPTIONALSUFFIX:/ || u ~ /^ESQSHARED_MATCHSELECTIONCODEWITH[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^SUBI\.[WL] #\$2E,D[0-7]$/ || u ~ /^CMPI\.[WL] #\$2E,D[0-7]$/ || u ~ /^CMPI\.[WL] #46,D[0-7]$/ || u ~ /^MOVEQ\.L #\$2E,D[0-7]$/ || u ~ /^MOVEQ\.L #46,D[0-7]$/) has_dot_compare = 1
    if (u ~ /^SUBI\.[WL] #12,D[0-7]$/ || u ~ /^CMPI\.[WL] #\$3A,D[0-7]$/ || u ~ /^CMPI\.[WL] #58,D[0-7]$/ || u ~ /^MOVEQ\.L #\$3A,D[0-7]$/ || u ~ /^MOVEQ\.L #58,D[0-7]$/) has_colon_compare = 1
    if (index(u, "#$2A") > 0 || index(u, "#42") > 0 || index(u, "#'*'") > 0) has_star_compare = 1
    if (index(u, "#$3F") > 0 || index(u, "#63") > 0 || index(u, "#'?'") > 0) has_qmark_compare = 1
    if (u ~ /^TST\.[WL] /) has_index_zero_gate = 1
    if (u ~ /^CLR\.[BW] [-$0-9A-Z_()]+$/ || u ~ /^MOVEQ(\.L)? #\$?0,D7$/) has_split_flag_init = 1
    if (index(u, "MOVE.B ESQ_STR_A") > 0 && u ~ /D[0-7]/) {
        has_prev_char_init = 1
        has_suffix_gate_init = 1
    }
    if ((u ~ /^CLR\.B [-$0-9A-Z_()]+$/ || u ~ /^MOVE\.B D[0-7],[-$0-9A-Z_()]+$/) && prev_u ~ /^MOVE\.W / && prev_u ~ /D[0-7]\.[WL]\)$/) {
        if (u ~ /\$30\(A7,D[0-7]\.W\)$/ || u ~ /-26\(A5,D[0-7]\.W\)$/) has_dot_split_transition = 1
        if (u ~ /\$1C\(A7,D[0-7]\.W\)$/ || u ~ /-30\(A5,D[0-7]\.W\)$/) has_terminate_suffix = 1
        if (u ~ /\$30\(A7,D[0-7]\.W\)$/ || u ~ /-26\(A5,D[0-7]\.W\)$/) has_terminate_main = 1
    }
    if ((u ~ /^MOVEQ(\.L)? #\$?0,D[0-7]$/ || u ~ /^MOVE\.W D[0-7],[-$0-9A-Z_()]+$/) && prev_u ~ /ESQ_STR_A|MOVE\.B D[0-7],D[0-7]/) {
        has_colon_gate_reset = 1
    }
    if (index(u, "-9(A5)") > 0 || u ~ /^MOVE\.B D[0-7],D5$/) has_colon_gate_prev = 1
    if (u ~ /^MOVE\.B D[0-7],\$30\(A7,D[0-7]\.W\)$/ || u ~ /^MOVE\.B D[0-7],-26\(A5,D[0-7]\.W\)$/) has_main_store = 1
    if (u ~ /^MOVE\.B D[0-7],\$1C\(A7,D[0-7]\.W\)$/ || u ~ /^MOVE\.B D[0-7],-30\(A5,D[0-7]\.W\)$/) has_suffix_store = 1
    if (u ~ /^CLR\.B \$30\(A7,D[0-7]\.W\)$/ || u ~ /^CLR\.B -26\(A5,D[0-7]\.W\)$/) has_terminate_main = 1
    if (u ~ /^CLR\.B \$1C\(A7,D[0-7]\.W\)$/ || u ~ /^MOVE\.B D[0-7],-30\(A5,D[0-7]\.W\)$/) has_terminate_suffix = 1
    if (u ~ /^MOVEQ #\-1,D[0-7]$/ || u ~ /^MOVE\.W #\$FFFFFFFF,[-$0-9A-Z_()]+$/) has_main_empty_minus1 = 1
    if (index(u, "ESQ_SELECTCODEBUFFER") > 0 || (index(u, "WILDCARDMATCH") > 0 && index(u, "SELECTIONSUFFIXBUFFER") == 0)) has_main_match = 1
    if (u ~ /^MOVEQ #1,D[0-7]$/ || u ~ /^SUBQ\.B #\$1,D[0-7]$/ || u ~ /^CMP\.B [-$0-9A-Z_()]+,D[0-7]$/) has_suffix_match_gate = 1
    if (index(u, "ESQPARS_SELECTIONSUFFIXBUFFER") > 0) has_suffix_match = 1
    if ((u ~ /^TST\.[WL] D[0-7]$/ || u ~ /^TST\.[WL] \$[0-9A-F]+\((A7)\)$/) || index(u, "ESQ_STR_A") > 0) has_final_gate = 1
    if (u ~ /^MOVEQ(\.L)? #\$?1,D0$/ || u ~ /^MOVE\.B #\$?1,D0$/) has_return_true = 1
    if (u ~ /^MOVEQ(\.L)? #\$?0,D0$/ || u ~ /^MOVE\.B #\$?0,D0$/) has_return_false = 1

    prev_u = u
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DOT_COMPARE=" has_dot_compare
    print "HAS_COLON_COMPARE=" has_colon_compare
    print "HAS_STAR_COMPARE=" has_star_compare
    print "HAS_QMARK_COMPARE=" has_qmark_compare
    print "HAS_INDEX_ZERO_GATE=" has_index_zero_gate
    print "HAS_SPLIT_FLAG_INIT=" has_split_flag_init
    print "HAS_PREV_CHAR_INIT=" has_prev_char_init
    print "HAS_SUFFIX_GATE_INIT=" has_suffix_gate_init
    print "HAS_DOT_SPLIT_TRANSITION=" has_dot_split_transition
    print "HAS_COLON_GATE_RESET=" has_colon_gate_reset
    print "HAS_COLON_GATE_PREV=" has_colon_gate_prev
    print "HAS_MAIN_STORE=" has_main_store
    print "HAS_SUFFIX_STORE=" has_suffix_store
    print "HAS_TERMINATE_MAIN=" has_terminate_main
    print "HAS_TERMINATE_SUFFIX=" has_terminate_suffix
    print "HAS_MAIN_EMPTY_MINUS1=" has_main_empty_minus1
    print "HAS_MAIN_MATCH=" has_main_match
    print "HAS_SUFFIX_MATCH_GATE=" has_suffix_match_gate
    print "HAS_SUFFIX_MATCH=" has_suffix_match
    print "HAS_FINAL_GATE=" has_final_gate
    print "HAS_RETURN_TRUE=" has_return_true
    print "HAS_RETURN_FALSE=" has_return_false
}
