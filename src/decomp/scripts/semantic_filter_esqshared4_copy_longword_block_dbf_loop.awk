BEGIN {
    has_entry = 0
    has_move = 0
    has_dbf = 0
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

    if (uline ~ /^ESQSHARED4_COPYLONGWORDBLOCKDBFLOOP:/) has_entry = 1
    if (uline ~ /^MOVE\.L \(A3\)\+,\(A4\)\+$/) has_move = 1
    if (uline ~ /^DBF D1,ESQSHARED4_COPYLONGWORDBLOCKDBFLOOP$/) has_dbf = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D0-D1\/A0-A4$/) has_movem = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MOVE=" has_move
    print "HAS_DBF=" has_dbf
    print "HAS_MOVEM=" has_movem
    print "HAS_RTS=" has_rts
}
