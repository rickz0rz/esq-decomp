BEGIN {
    has_restore = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (u ~ /^MOVEM\.L \(A7\)\+,D0-D1\/A2$/) has_restore = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
