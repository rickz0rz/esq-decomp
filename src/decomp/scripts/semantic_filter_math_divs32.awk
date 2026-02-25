BEGIN {
    has_dividend_sign_test = 0
    has_divisor_sign_test = 0
    has_negate_dividend = 0
    has_negate_divisor = 0
    has_unsigned_div_call = 0
    has_negate_result = 0
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

    if (u ~ /^TST\.L D0$/ || u ~ /^CMP\.L #0,D0$/) has_dividend_sign_test = 1
    if (u ~ /^TST\.L D1$/ || u ~ /^CMP\.L #0,D1$/) has_divisor_sign_test = 1

    if (u ~ /^NEG\.L D0$/) has_negate_dividend = 1
    if (u ~ /^NEG\.L D1$/) has_negate_divisor = 1

    if (u ~ /JSR .*MATH_DIVU32/ || u ~ /BSR.*MATH_DIVU32/) has_unsigned_div_call = 1
    if (u ~ /^NEG\.L D0$/) has_negate_result = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_DIVIDEND_SIGN_TEST=" has_dividend_sign_test
    print "HAS_DIVISOR_SIGN_TEST=" has_divisor_sign_test
    print "HAS_NEGATE_DIVIDEND=" has_negate_dividend
    print "HAS_NEGATE_DIVISOR=" has_negate_divisor
    print "HAS_UNSIGNED_DIV_CALL=" has_unsigned_div_call
    print "HAS_NEGATE_RESULT=" has_negate_result
    print "HAS_RTS=" has_rts
}
