BEGIN {
    has_entry = 0
    has_movem = 0
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

    if (uline ~ /^ESQIFF2_VALIDATEFIELDINDEXANDLENGTH_RETURN:/) has_entry = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D6-D7$/) has_movem = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVEM=" has_movem
    print "HAS_RTS=" has_rts
}
