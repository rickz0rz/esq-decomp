BEGIN {
    has_entry = 0
    has_rts = 0
    has_nullterm = 0
    has_ampm = 0
    has_colon = 0
    has_divs10 = 0
    has_leading_space = 0
    has_call = 0
}

function up(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = up($0)
    if (l == "") next

    if (ENTRY != "" && l == toupper(ENTRY) ":") has_entry = 1
    if (l == "RTS") has_rts = 1

    if (l ~ /^CLR\.B \(A[0-7]\)$/ || l ~ /^MOVE\.B #\$?0,\(A[0-7]\)$/) has_nullterm = 1
    if (l ~ /#\$?41/ || l ~ /#\$?50/ || l ~ /#'A'/ || l ~ /#'P'/) has_ampm = 1
    if (l ~ /#\$?3A/ || l ~ /#':'/) has_colon = 1
    if (l ~ /^DIVS(\.W)? #\$?A,D[0-7]$/ || l ~ /^DIVS(\.W)? #10,D[0-7]$/ || l ~ /^DIVS(\.W)? D[0-7],D[0-7]$/) has_divs10 = 1
    if (l ~ /#\$?20/ || l ~ /#' '/) has_leading_space = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_NULLTERM=" has_nullterm
    print "HAS_AMPM=" has_ampm
    print "HAS_COLON=" has_colon
    print "HAS_DIVS10=" has_divs10
    print "HAS_LEADING_SPACE=" has_leading_space
    print "HAS_CALL=" has_call
}
