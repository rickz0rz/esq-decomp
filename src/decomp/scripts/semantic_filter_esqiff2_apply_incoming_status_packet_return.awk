BEGIN {
    has_entry = 0
    has_ready = 0
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

    if (uline ~ /^ESQIFF2_APPLYINCOMINGSTATUSPACKET_RETURN:/) has_entry = 1
    if (uline ~ /^MOVE\.W #1,ESQIFF_STATUSPACKETREADYFLAG$/) has_ready = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D2\/D6-D7\/A3$/) has_movem = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_READY=" has_ready
    print "HAS_MOVEM=" has_movem
    print "HAS_RTS=" has_rts
}
