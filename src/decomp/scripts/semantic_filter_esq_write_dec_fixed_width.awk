BEGIN {
    has_null_term = 0
    has_div_or_mod10 = 0
    has_predec_store = 0
    has_add_ascii = 0
    has_loop = 0
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

    if (u ~ /MOVE\.B #0,\(A[0-7]\)/ || u ~ /CLR\.B \(A[0-7]\)/) has_null_term = 1
    if (u ~ /DIVS #10,D[0-7]/ || u ~ /DIVS\.W #10,D[0-7]/ || u ~ /PEA 10\.W/ || u ~ /DIVSI3/ || u ~ /MODSI3/) has_div_or_mod10 = 1
    if (u ~ /MOVE\.B D[0-7],-\(A[0-7]\)/) has_predec_store = 1
    if (u ~ /ADDI\.B #\$?30,\(A[0-7]\)/ || u ~ /ADDQ\.B #48,\(A[0-7]\)/ || u ~ /ADD\.B #48,\(A[0-7]\)/ || u ~ /ADD\.B #48,D[0-7]/ || u ~ /ADDI\.B #\$?30,D[0-7]/) has_add_ascii = 1
    if (u ~ /^DBF D[0-7],/ || u ~ /^DBRA D[0-7],/ || u ~ /^B(NE|EQ|GT|GE|LT|LE|RA|PL|MI)/ || u ~ /^J(B?NE|EQ|GT|GE|LT|LE|RA) /) has_loop = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NULL_TERM=" has_null_term
    print "HAS_DIV_OR_MOD10=" has_div_or_mod10
    print "HAS_PREDEC_STORE=" has_predec_store
    print "HAS_ADD_ASCII=" has_add_ascii
    print "HAS_LOOP=" has_loop
    print "HAS_RTS=" has_rts
}
