BEGIN {
    has_entry = 0
    has_zero = 0
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

    if (uline ~ /^LOCAVAIL2_AUTOREQUESTNOOP:/) has_entry = 1
    if (uline ~ /^MOVEQ(\.L)? #(\$)?0+,D0$/) has_zero = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ZERO=" has_zero
    print "HAS_RTS=" has_rts
}
