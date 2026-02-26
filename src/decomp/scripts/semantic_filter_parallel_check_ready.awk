BEGIN {
    has_stub_call = 0
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

    if (u ~ /JSR .*PARALLEL_CHECKREADYSTUB/) has_stub_call = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_STUB_CALL=" has_stub_call
    print "HAS_RTS=" has_rts
}
