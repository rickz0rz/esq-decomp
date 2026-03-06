BEGIN {
    has_apen2 = 0
    has_rectfill = 0
    has_apen1 = 0
    has_drmd1 = 0
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

    if (l ~ /^MOVEQ #2,D0$/ || l ~ /^PEA \(\$2\)\.W$/ || l ~ /^MOVE\.L #\$?2,-\(A7\)$/) has_apen2 = 1
    if (l ~ /(JSR|BSR).*_LVORECTFILL/) has_rectfill = 1
    if (l ~ /^MOVEQ #1,D0$/ || l ~ /^PEA \(\$1\)\.W$/ || l ~ /^MOVE\.L #\$?1,-\(A7\)$/) {
        if (has_apen2 == 1) has_apen1 = 1
        has_drmd1 = 1
    }
    if (l ~ /(JSR|BSR).*_LVOSETDRMD/) has_drmd1 = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_APEN2=" has_apen2
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_APEN1=" has_apen1
    print "HAS_DRMD1=" has_drmd1
    print "HAS_RTS=" has_rts
}
