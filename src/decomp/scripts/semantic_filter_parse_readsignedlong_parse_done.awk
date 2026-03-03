BEGIN {
    has_entry = 0
    has_cmp = 0
    has_bne = 0
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

    if (uline ~ /^PARSE_READSIGNEDLONG_PARSEDONE:/) has_entry = 1
    if (uline ~ /^CMPI\.B #'-',\(A1\)$/) has_cmp = 1
    if (uline ~ /^BNE\.[SW] PARSE_READSIGNEDLONG_STORERESULT$/) has_bne = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CMP=" has_cmp
    print "HAS_BNE=" has_bne
}
