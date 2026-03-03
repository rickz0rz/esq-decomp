BEGIN {
    has_entry = 0
    has_pop = 0
    has_store = 0
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
    if (uline ~ /^MOVE\.L \(A7\)\+,D2$/) has_pop = 1
    if (uline ~ /^MOVE\.L D1,\(A0\)$/) has_store = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_POP=" has_pop
    print "HAS_STORE=" has_store
    print "HAS_RTS=" has_rts
}
