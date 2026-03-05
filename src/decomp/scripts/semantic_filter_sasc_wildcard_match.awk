BEGIN {
    has_entry = 0
    has_rts = 0
    has_star = 0
    has_qmark = 0
    has_match_zero = 0
    has_mismatch_one = 0
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

    if (l ~ /#\$2A/ || l ~ /#'\*'/) has_star = 1
    if (l ~ /#\$3F/ || l ~ /#'\?'/) has_qmark = 1
    if (l ~ /MOVEQ(\.L)? #\$?0,D0/ || l ~ /MOVE\.B #0,D0/) has_match_zero = 1
    if (l ~ /MOVEQ(\.L)? #\$?1,D0/ || l ~ /MOVE\.B #\$?1,D0/) has_mismatch_one = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_STAR=" has_star
    print "HAS_QMARK=" has_qmark
    print "HAS_MATCH_ZERO=" has_match_zero
    print "HAS_MISMATCH_ONE=" has_mismatch_one
    print "HAS_CALL=" has_call
}
