BEGIN {
    has_entry = 0
    has_role = 0
}

function trim(s, t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^PARSE_READSIGNEDLONG_PARSELOOP[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^MOVE\.B \(A0\)\+,D0$/) has_role = 1
    if (uline ~ /^CMPI\.B #\('9'-'0'\),D0$/) has_role = 1
    if (uline ~ /^ADD\.L D0,D1$/) has_role = 1
    if (uline ~ /^BSR\.[SW] PARSE_READSIGNEDLONG$/) has_role = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ROLE=" has_role
}
