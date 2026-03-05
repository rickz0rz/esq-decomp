BEGIN {
    has_entry = 0
    has_rts = 0
    has_casefold = 0
    has_backtrack = 0
    has_match_return = 0
    has_null_return = 0
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

    if (l ~ /^BCHG #\$?5,D[0-7]$/ || l ~ /EORI\.[BWL] #\$?20,D[0-7]/) has_casefold = 1
    if (l ~ /^SUBQ\.L #\$?1,A[0-7]$/ || l ~ /^SUBQ\.L #1,A[0-7]$/ || l ~ /^SUBI\.L #\$?1,A[0-7]$/ || l ~ /^SUBQ\.L #\$?1,D[0-7]$/ || l ~ /^SUBQ\.L #1,D[0-7]$/ || l ~ /^SUBI\.L #\$?1,D[0-7]$/) has_backtrack = 1
    if (l ~ /^MOVE\.L A[0-7],D0$/) has_match_return = 1
    if (l ~ /^MOVEQ(\.L)? #\$?0,D0$/ || l ~ /^CLR\.L D0$/) has_null_return = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_CASEFOLD=" has_casefold
    print "HAS_BACKTRACK=" has_backtrack
    print "HAS_MATCH_RETURN=" has_match_return
    print "HAS_NULL_RETURN=" has_null_return
    print "HAS_CALL=" has_call
}
