BEGIN {
    has_label = 0
    has_move = 0
    has_restore = 0
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

    if (uline ~ /^COI_COMPUTEENTRYTIMEDELTAMINUTES_RETURN:/) has_label = 1
    if (uline ~ /MOVE.L D5,D0/) has_move = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A3/) has_restore = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_MOVE=" has_move
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
