BEGIN {
    has_sign_check = 0
    has_digit_sub = 0
    has_digit_range_check = 0
    has_mul10 = 0
    has_add_digit = 0
    has_negate = 0
    has_store_out = 0
    has_len_return = 0
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

    if (u ~ /^CMPI?\.B #'\+',\(A[0-7]\)$/ || u ~ /^CMPI?\.B #'-',\(A[0-7]\)$/ || u ~ /^CMP\.B #43,D[0-7]$/ || u ~ /^CMP\.B #45,D[0-7]$/ || u ~ /^CMPI\.B #43,\(A[0-7]\)$/ || u ~ /^CMPI\.B #45,\(A[0-7]\)$/) has_sign_check = 1
    if (u ~ /^SUBI?\.B #'0',D[0-7]$/ || u ~ /^SUBI?\.B #\$30,D[0-7]$/ || u ~ /^MOVE\.W #-48,A[0-7]$/) has_digit_sub = 1
    if (u ~ /^CMPI\.B #9,D[0-7]$/ || u ~ /^(BLT|BLT\.S|BGT|BGT\.S|JLT|JGT|JCS|BCS) / || u ~ /^CMP\.L A[0-7],D[0-7]$/ || u ~ /^CMP\.L D[0-7],A[0-7]$/) has_digit_range_check = 1
    if (u ~ /^(ASL|LSL)\.L #2,D[0-7]$/ || u ~ /^MULU\.W #10,D[0-7]$/ || u ~ /^MULS\.W #10,D[0-7]$/) has_mul10 = 1
    if (u ~ /^ADD\.L D[0-7],D[0-7]$/ || u ~ /^ADD\.L D[0-7],D1$/) has_add_digit = 1
    if (u ~ /^NEG\.L D[0-7]$/) has_negate = 1
    if (u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/) has_store_out = 1
    if (u ~ /^SUB\.L A[0-7],D0$/ || u ~ /^SUBQ\.L #1,D0$/) has_len_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGN_CHECK=" has_sign_check
    print "HAS_DIGIT_SUB=" has_digit_sub
    print "HAS_DIGIT_RANGE_CHECK=" has_digit_range_check
    print "HAS_MUL10=" has_mul10
    print "HAS_ADD_DIGIT=" has_add_digit
    print "HAS_NEGATE=" has_negate
    print "HAS_STORE_OUT=" has_store_out
    print "HAS_LEN_RETURN=" has_len_return
    print "HAS_RTS=" has_rts
}
