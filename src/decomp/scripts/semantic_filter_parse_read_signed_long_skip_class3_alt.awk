BEGIN {
    has_null_check = 0
    has_zero_return = 0
    has_skip_call = 0
    has_parse_call = 0
    has_value_return = 0
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

    if (u ~ /^TST\.L A[0-7]$/ || u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^TST\.L D[0-7]$/) has_null_check = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_zero_return = 1
    if (u ~ /JSR .*STR_SKIPCLASS3CHARS/) has_skip_call = 1
    if (u ~ /JSR .*PARSE_READSIGNEDLONG_NOBRANCH/) has_parse_call = 1
    if (u ~ /^MOVE\.L -[0-9]+\(A5\),D0$/ || u ~ /^MOVE\.L \(-?[0-9]+,A5\),D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_value_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NULL_CHECK=" has_null_check
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_SKIP_CALL=" has_skip_call
    print "HAS_PARSE_CALL=" has_parse_call
    print "HAS_VALUE_RETURN=" has_value_return
    print "HAS_RTS=" has_rts
}
