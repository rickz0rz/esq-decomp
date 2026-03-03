BEGIN {
    has_entry = 0
    has_neg = 0
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

    if (uline ~ /^PARSE_READSIGNEDLONG_NEGATEVALUE:/) has_entry = 1
    if (uline ~ /^NEG\.L D1$/) has_neg = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NEG=" has_neg
}
