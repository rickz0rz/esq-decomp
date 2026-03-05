BEGIN {
    has_entry = 0
    has_rts = 0
    has_quote_cmp = 0
    has_write_nul = 0
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

    if (l ~ /MOVEQ\.L #\$?22,D[0-7]/ || l ~ /MOVEQ #34,D[0-7]/ || l ~ /CMPI\.B #'"'/) has_quote_cmp = 1
    if (l ~ /^CLR\.B \(A[0-7]\)$/ || l ~ /^MOVE\.B D[0-7],\(A[0-7]\)$/) has_write_nul = 1

    if (l ~ /^(JMP|JSR|BSR)(\.[A-Z]+)? /) {
        if (index(l, "_XCOVF") == 0) has_call = 1
    }
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_RTS=" has_rts
    print "HAS_QUOTE_CMP=" has_quote_cmp
    print "HAS_WRITE_NUL=" has_write_nul
    print "HAS_CALL=" has_call
}
