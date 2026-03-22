BEGIN {
    has_entry = 0
    has_role = 0
    has_rts = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^PARSE_READSIGNEDLONG_STORERESULT:/) has_entry = 1
    if (uline ~ /^MOVE\.L \(A7\)\+,D2$/) has_role = 1
    if (uline ~ /^MOVE\.L D1,\(A0\)$/) has_role = 1
    if (uline ~ /^BSR\.[SW] PARSE_READSIGNEDLONG$/) has_role = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROLE=" has_role
    print "HAS_RTS=" has_rts
}
