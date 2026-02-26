BEGIN {
    has_hw_call = 0
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

    if (u ~ /JSR .*PARALLEL_WRITECHARHW/) has_hw_call = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_HW_CALL=" has_hw_call
    print "HAS_RTS=" has_rts
}
