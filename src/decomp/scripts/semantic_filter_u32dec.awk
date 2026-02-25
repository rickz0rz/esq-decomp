BEGIN {
    has_div_step = 0
    has_digit_ascii = 0
    has_digit_loop = 0
    has_emit_loop = 0
    has_nul_term = 0
    has_len_calc = 0
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

    if (u ~ /JSR .*MATH_DIVU32/ || u ~ /JSR .*MATH_DIVU32/ || u ~ /^DIVU(\.L|\.W)? /) has_div_step = 1
    if (u ~ /^ADDI\.W #\$30,D1$/ || u ~ /^ADD\.B #48,D[0-7]$/ || u ~ /^ADD\.L #48,D[0-7]$/) has_digit_ascii = 1
    if (u ~ /^BNE(\.S)? \.DIGIT_LOOP$/ || u ~ /^DBRA D[0-7],/ || u ~ /^JNE /) has_digit_loop = 1

    if (u ~ /^MOVE\.B -\(A1\),\(A0\)\+$/ || u ~ /^MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+$/) has_emit_loop = 1
    if (u ~ /^CMPA\.L A1,A7$/ || u ~ /^CMP\.L .*A[0-7]/ || u ~ /^BNE(\.S)? \.EMIT_LOOP$/) has_emit_loop = 1

    if (u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_nul_term = 1
    if (u ~ /^SUB\.L A7,D0$/ || u ~ /^SUB\.L .*D0$/ || u ~ /^MOVE\.L .*D0$/) has_len_calc = 1
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
