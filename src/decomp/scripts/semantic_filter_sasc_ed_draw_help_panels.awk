BEGIN {
    has_apen = 0
    has_rectfill = 0
    has_pen_arg = 0
    has_drmd0 = 0
    has_apen1 = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /(JSR|BSR).*_LVOSETAPEN/) has_apen = 1
    if (l ~ /(JSR|BSR).*_LVORECTFILL/) has_rectfill = 1
    if (l ~ /^MOVE\.L D7,D0$/ || l ~ /^MOVE\.L 16\(A7\),D7$/ || l ~ /^MOVE\.L [0-9]+\(A7\),D[0-7]$/ || l ~ /^MOVE\.L \$[0-9A-F]+\((A7|A5)\),D[0-7]$/) has_pen_arg = 1
    if (l ~ /(JSR|BSR).*_LVOSETDRMD/) has_drmd0 = 1
    if (l ~ /^MOVEQ #1,D0$/ || l ~ /^PEA \(\$1\)\.W$/) has_apen1 = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_APEN=" has_apen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_PEN_ARG=" has_pen_arg
    print "HAS_DRMD0=" has_drmd0
    print "HAS_APEN1=" has_apen1
    print "HAS_RTS=" has_rts
}
