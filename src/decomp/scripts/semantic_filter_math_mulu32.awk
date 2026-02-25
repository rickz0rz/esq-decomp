BEGIN {
    has_multiply = 0
    has_return = 0
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

    if (u ~ /^MULU / || u ~ /JSR .*MULSI3/ || u ~ /JSR .*MULU32/ || u ~ /^MULS /) has_multiply = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/ || u ~ /^MOVEQ #0,D0$/ || u ~ /^SWAP D0$/) has_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_MULTIPLY=" has_multiply
    print "HAS_RETURN=" has_return
    print "HAS_RTS=" has_rts
}
