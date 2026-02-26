BEGIN {
    has_utility_base = 0
    has_a0_flow = 0
    has_call = 0
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

    if (u ~ /GLOBAL_REF_UTILITY_LIBRARY/ || u ~ /^MOVEA\.L .*A6$/) has_utility_base = 1
    if (u ~ /A0/) has_a0_flow = 1
    if (u ~ /JSR .*LVODATE2AMIGA/) has_call = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_UTILITY_BASE=" has_utility_base
    print "HAS_A0_FLOW=" has_a0_flow
    print "HAS_CALL=" has_call
    print "HAS_RTS=" has_rts
}
