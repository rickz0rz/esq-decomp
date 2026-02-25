BEGIN {
    has_prologue = 0
    has_maxlen_guard = 0
    has_a_nul_guard = 0
    has_b_nul_guard = 0
    has_casefold_call = 0
    has_diff_calc = 0
    has_nonzero_return = 0
    has_direct_nonzero_return = 0
    has_len_decrement = 0
    has_len_zero_return = 0
    has_a_tail_positive = 0
    has_b_tail_negative = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^(LINK\.W|MOVEM\.L)/) has_prologue = 1
    if (u ~ /^TST\.L D[0-7]$/) has_maxlen_guard = 1
    if (u ~ /^TST\.B \(A[0-7]\)$/) {
        if (!has_a_nul_guard) {
            has_a_nul_guard = 1
        } else {
            has_b_nul_guard = 1
        }
    }
    if (u ~ /^TST\.B D[0-7]$/) has_b_nul_guard = 1
    if (u ~ /STRING_TOUPPERCHAR/) has_casefold_call = 1
    if (u ~ /^SUB\.L D[0-7],D[0-7]$/) has_diff_calc = 1
    if (u ~ /^(BNE|BNE\.S|JNE|JNE\.S) /) has_nonzero_return = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/) has_direct_nonzero_return = 1
    if (u ~ /^SUBQ\.L #1,D[0-7]$/) has_len_decrement = 1
    if (u ~ /^MOVEQ #0,D0$/) has_len_zero_return = 1
    if (u ~ /^MOVEQ #1,D0$/) has_a_tail_positive = 1
    if (u ~ /^MOVEQ #-1,D0$/) has_b_tail_negative = 1
    if (u ~ /^SNE D[0-7]$/ || u ~ /^EXT\.W D[0-7]$/ || u ~ /^EXT\.L D[0-7]$/) {
        has_a_tail_positive = 1
        has_b_tail_negative = 1
    }
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_PROLOGUE=" has_prologue
    print "HAS_MAXLEN_GUARD=" has_maxlen_guard
    print "HAS_A_NUL_GUARD=" has_a_nul_guard
    print "HAS_B_NUL_GUARD=" has_b_nul_guard
    print "HAS_CASEFOLD_CALL=" has_casefold_call
    print "HAS_DIFF_CALC=" has_diff_calc
    print "HAS_NONZERO_RETURN=" (has_nonzero_return || has_direct_nonzero_return)
    print "HAS_LEN_DECREMENT=" has_len_decrement
    print "HAS_LEN_ZERO_RETURN=" has_len_zero_return
    print "HAS_A_TAIL_POSITIVE=" has_a_tail_positive
    print "HAS_B_TAIL_NEGATIVE=" has_b_tail_negative
    print "HAS_RTS=" has_rts
}
