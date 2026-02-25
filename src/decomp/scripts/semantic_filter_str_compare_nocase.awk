BEGIN {
    has_load_pair = 0
    has_casefold_a = 0
    has_casefold_b = 0
    has_diff_calc = 0
    has_nonzero_return = 0
    has_zero_tail_check = 0
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

    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_load_pair = 1

    if (u ~ /^CMPI\.B #'A',D[0-7]$/ || u ~ /^CMPI\.B #'Z',D[0-7]$/ || u ~ /^SUBI\.B #\$20,D[0-7]$/ || u ~ /^ADD\.B #?-97,D[0-7]$/ || u ~ /^CMP\.B #25,D[0-7]$/) {
        has_casefold_a = 1
    }
    if (u ~ /^CMPI\.B #'A',D[0-7]$/ || u ~ /^CMPI\.B #'Z',D[0-7]$/ || u ~ /^SUBI\.B #\$20,D[0-7]$/ || u ~ /^ADD\.B #?-97,D[0-7]$/ || u ~ /^CMP\.B #25,D[0-7]$/) {
        has_casefold_b = 1
    }
    if (u ~ /TO_UPPER_ASCII/ || u ~ /STRING_TOUPPERCHAR/) {
        has_casefold_a = 1
        has_casefold_b = 1
    }

    if (u ~ /^SUB\.L D[0-7],D[0-7]$/ || u ~ /^SUB\.B D[0-7],D[0-7]$/) has_diff_calc = 1
    if (u ~ /^(BNE|BNE\.S|JNE|JNE\.S) /) has_nonzero_return = 1

    if (u ~ /^TST\.B D[0-7]$/ || u ~ /^TST\.B \(A[0-7]\)$/) has_zero_tail_check = 1
    if (u ~ /^MOVEQ #0,D0$/) has_zero_return = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LOAD_PAIR=" has_load_pair
    print "HAS_CASEFOLD_A=" has_casefold_a
    print "HAS_CASEFOLD_B=" has_casefold_b
    print "HAS_DIFF_CALC=" has_diff_calc
    print "HAS_NONZERO_RETURN=" has_nonzero_return
    print "HAS_ZERO_TAIL_CHECK=" has_zero_tail_check
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_RTS=" has_rts
}
