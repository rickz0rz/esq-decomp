BEGIN {
    has_store_shadow = 0
    has_pop_d2d3 = 0
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

    if (uline ~ /ESQ_BANNERCHARINDEXSHADOW2273/) has_store_shadow = 1
    if (uline ~ /^MOVEM\.L \(A7\)\+,D2-D3$/ || uline ~ /^MOVEM\.L \(SP\)\+,D2-D3$/) has_pop_d2d3 = 1
    if (uline == "RTS") has_rts = 1
}

END {
    print "HAS_STORE_SHADOW=" has_store_shadow
    print "HAS_POP_D2D3=" has_pop_d2d3
    print "HAS_RTS=" has_rts
}
