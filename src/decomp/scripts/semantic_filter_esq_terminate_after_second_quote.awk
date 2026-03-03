BEGIN {
    has_quote_const = 0
    has_load_postinc = 0
    has_zero_check = 0
    has_cmp_quote = 0
    has_zero_store = 0
    has_loop_branch = 0
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

    if (u ~ /#34,D[0-7]/ || u ~ /#\$?22,D[0-7]/) has_quote_const = 1
    if (u ~ /^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) has_load_postinc = 1
    if (u ~ /^BEQ(\.S)? / || u ~ /^JEQ / || u ~ /^TST\.B D[0-7]$/ || u ~ /^TST\.W D[0-7]$/) has_zero_check = 1
    if (u ~ /^CMP\.B D[0-7],D[0-7]$/ || u ~ /^CMP\.B #\$?22,D[0-7]$/ || u ~ /^CMP\.B #34,D[0-7]$/) has_cmp_quote = 1
    if (u ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/ || u ~ /^CLR\.B \(A[0-7]\)$/ || u ~ /^MOVE\.B #0,\(A[0-7]\)$/) has_zero_store = 1
    if (u ~ /^BNE(\.S)? / || u ~ /^JNE / || u ~ /^BRA(\.S)? / || u ~ /^JRA /) has_loop_branch = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_QUOTE_CONST=" has_quote_const
    print "HAS_LOAD_POSTINC=" has_load_postinc
    print "HAS_ZERO_CHECK=" has_zero_check
    print "HAS_CMP_QUOTE=" has_cmp_quote
    print "HAS_ZERO_STORE=" has_zero_store
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_RTS=" has_rts
}
