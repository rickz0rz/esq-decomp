BEGIN {
    has_entry = 0
    has_transfer = 0
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

    if (uline ~ /^PARSE_READSIGNEDLONG_PARSELOOPENTRY:/) has_entry = 1
    if (uline ~ /^BRA\.[SW] PARSE_READSIGNEDLONG_PARSELOOP$/ || uline ~ /^JMP PARSE_READSIGNEDLONG_PARSELOOP$/) has_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TRANSFER=" has_transfer
}
