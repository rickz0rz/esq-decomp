BEGIN {
    has_div_step = 0
    has_digit_ascii = 0
    has_digit_loop = 0
    has_emit_loop = 0
    has_nul_term = 0
    has_len_calc = 0
    has_rts = 0

    saw_tst_digit = 0
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

    if (u ~ /^(JSR|BSR)(\.[A-Z])? .*MATH_DIVU32/ || u ~ /^DIVU(\.L|\.W)? /) has_div_step = 1

    if (u ~ /^ADDI\.W #\$30,D1$/ ||
        u ~ /^ADD\.B #48,D[0-7]$/ ||
        u ~ /^ADD\.L #48,D[0-7]$/ ||
        u ~ /^MOVEQ(\.L)? #\$30,D1$/ ||
        u ~ /^MOVEQ(\.L)? #48,D1$/) {
        has_digit_ascii = 1
    }
    if (u ~ /^ADD\.L D1,D0$/ || u ~ /^ADD\.W D1,D0$/) has_digit_ascii = 1

    if (u ~ /^TST\.L D[0-7]$/) saw_tst_digit = 1
    if (saw_tst_digit && u ~ /^BNE(\.[A-Z])? /) {
        has_digit_loop = 1
        saw_tst_digit = 0
    }

    if (u ~ /^MOVE\.B -\(A1\),\(A0\)\+$/ ||
        u ~ /^MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+$/ ||
        u ~ /^MOVE\.B \(A[0-7]\),\(A[0-7]\)\+$/) {
        has_emit_loop = 1
    }
    if (u ~ /^CMPA\.L A1,A7$/ ||
        u ~ /^CMP\.L A[0-7],A[0-7]$/ ||
        u ~ /^CMP\.L .*A[0-7]/ ||
        u ~ /^BEQ(\.[A-Z])? / ||
        u ~ /^BNE(\.[A-Z])? \.EMIT_LOOP$/) {
        has_emit_loop = 1
    }

    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_nul_term = 1
    if (u ~ /^SUB\.L A7,D0$/ ||
        u ~ /^SUB\.L D[0-7],D0$/ ||
        u ~ /^MOVE\.L .*D0$/) has_len_calc = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_DIV_STEP=" has_div_step
    print "HAS_DIGIT_ASCII=" has_digit_ascii
    print "HAS_DIGIT_LOOP=" has_digit_loop
    print "HAS_EMIT_LOOP=" has_emit_loop
    print "HAS_NUL_TERM=" has_nul_term
    print "HAS_LEN_CALC=" has_len_calc
    print "HAS_RTS=" has_rts
}
