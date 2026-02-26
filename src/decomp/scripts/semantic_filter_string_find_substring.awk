BEGIN {
    has_needle_end_test = 0
    has_byte_compare = 0
    has_advance_start = 0
    has_null_return = 0
    has_success_return = 0
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

    if (u ~ /CMPI\.B #0/ || u ~ /^TST\.B / || u ~ /^TST\.W /) has_needle_end_test = 1
    if (u ~ /CMPM\.B/ || u ~ /^CMP\.B /) has_byte_compare = 1
    if (u ~ /^ADDQ\.(W|L) #1,A[0-7]$/ || u ~ /^ADD\.L #1,A[0-7]$/ || u ~ /^ADDQ\.(W|L) #1,D[0-7]$/ || u ~ /^ADD\.L #1,D[0-7]$/) has_advance_start = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/ || u ~ /^MOVE\.L #0,D0$/) has_null_return = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVE\.L \(.*,(A7|SP)\),D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_success_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NEEDLE_END_TEST=" has_needle_end_test
    print "HAS_BYTE_COMPARE=" has_byte_compare
    print "HAS_ADVANCE_START=" has_advance_start
    print "HAS_NULL_RETURN=" has_null_return
    print "HAS_SUCCESS_RETURN=" has_success_return
    print "HAS_RTS=" has_rts
}
