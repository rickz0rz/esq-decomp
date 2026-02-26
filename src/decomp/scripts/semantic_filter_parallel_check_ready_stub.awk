BEGIN {
    has_minus_one = 0
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

    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_minus_one = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_MINUS_ONE=" has_minus_one
    print "HAS_RTS=" has_rts
}
