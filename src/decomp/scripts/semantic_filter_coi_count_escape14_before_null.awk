BEGIN {
    has_label = 0
    has_loop = 0
    has_load = 0
    has_escape_cmp = 0
    has_escape_inc = 0
    has_return_move = 0
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

    if (uline ~ /^COI_COUNTESCAPE14BEFORENULL:/) has_label = 1
    if (uline ~ /^\\.SCAN_LOOP:/) has_loop = 1
    if (index(uline, "MOVE.B 0(A3,D6.W),D0") > 0) has_load = 1
    if (index(uline, "SUBI.W #20,D0") > 0) has_escape_cmp = 1
    if (index(uline, "ADDQ.W #1,D4") > 0) has_escape_inc = 1
    if (index(uline, "MOVE.L D4,D0") > 0) has_return_move = 1
    if (index(uline, "MOVEM.L (A7)+,D4-D7/A3") > 0) has_restore = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LOOP=" has_loop
    print "HAS_LOAD=" has_load
    print "HAS_ESCAPE_CMP=" has_escape_cmp
    print "HAS_ESCAPE_INC=" has_escape_inc
    print "HAS_RETURN_MOVE=" has_return_move
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
