BEGIN {
    has_len_guard = 0
    has_dual_nul_guard = 0
    has_diff_calc = 0
    has_nonzero_early_return = 0
    has_tail_plus_minus = 0
    has_zero_return = 0
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

    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L #0,D[0-7]$/) has_len_guard = 1
    if (u ~ /^TST\.B \(A[0-7]\)$/) has_dual_nul_guard = 1

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/ || u ~ /^SUB\.L D[0-7],D[0-7]$/ || u ~ /^SUB\.B D[0-7],D[0-7]$/) has_diff_calc = 1
    if ((u ~ /^MOVE\.L D[0-7],D0$/ && u !~ /^MOVE\.L D1,D0$/) || u ~ /^JNE(\.S)? / || u ~ /^BNE(\.S)? /) has_nonzero_early_return = 1

    if (u ~ /^MOVEQ #1,D0$/ || u ~ /^MOVEQ #-1,D0$/) has_tail_plus_minus = 1
    if (u ~ /^MOVEQ #0,D0$/) has_zero_return = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LEN_GUARD=" has_len_guard
    print "HAS_DUAL_NUL_GUARD=" has_dual_nul_guard
    print "HAS_DIFF_CALC=" has_diff_calc
    print "HAS_NONZERO_EARLY_RETURN=" has_nonzero_early_return
    print "HAS_TAIL_PLUS_MINUS=" has_tail_plus_minus
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RTS=" has_rts
}
