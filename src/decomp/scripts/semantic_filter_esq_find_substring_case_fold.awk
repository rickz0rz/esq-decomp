BEGIN {
    has_empty_needle_check = 0
    has_found_return = 0
    has_zero_return = 0
    has_case_fold = 0
    has_pattern_advance = 0
    has_partial_reset_check = 0
    has_reset_pattern = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (u ~ /TST\.B \(A1\)/ || u ~ /CMP\.B #0,\(A1\)/ || u ~ /CMPI\.B #0,\(A1\)/) has_empty_needle_check = 1
    if (u ~ /^MOVE\.L A3,D0$/ || u ~ /^MOVE\.L A[0-7],D0$/) has_found_return = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return = 1
    if (u ~ /^BCHG #5,/ || u ~ /^EOR\.B #(\$?20|32),/ || u ~ /^EORI\.B #(\$?20|32),/ || u ~ /^XOR\.B #(\$?20|32),/ || u ~ /^XORI\.B #(\$?20|32),/) has_case_fold = 1
    if (u ~ /\(A2\)\+/ || u ~ /^ADDQ\.L #1,A1$/ || u ~ /^ADDQ\.W #1,A1$/) has_pattern_advance = 1
    if (u ~ /^CMPA\.L D[0-7],A1$/ || u ~ /^CMPA\.L A[0-7],A1$/ || u ~ /^CMP\.L A1,D[0-7]/ || u ~ /^CMP\.L A[0-7],A[0-7]$/) has_partial_reset_check = 1
    if (u ~ /^MOVEA\.L A1,A2$/ || u ~ /^MOVE\.L A1,A2$/ || u ~ /^MOVEA\.L A2,A1$/ || u ~ /^MOVE\.L A2,A1$/) has_reset_pattern = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_EMPTY_NEEDLE_CHECK=" has_empty_needle_check
    print "HAS_FOUND_RETURN=" has_found_return
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_CASE_FOLD=" has_case_fold
    print "HAS_PATTERN_ADVANCE=" has_pattern_advance
    print "HAS_PARTIAL_RESET_CHECK=" has_partial_reset_check
    print "HAS_RESET_PATTERN=" has_reset_pattern
    print "HAS_RTS=" has_rts
}
