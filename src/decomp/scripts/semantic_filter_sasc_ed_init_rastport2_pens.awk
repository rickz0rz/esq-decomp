BEGIN {
    has_drmd = 0
    has_apen = 0
    has_cmp14 = 0
    has_bpen = 0
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

    if (l ~ /(JSR|BSR).*_LVOSETDRMD/) has_drmd = 1
    if (l ~ /(JSR|BSR).*_LVOSETAPEN/) has_apen = 1
    if (l ~ /CMP\.L ED_RASTPORT2PENMODESELECTOR(\(A4\))?,D0/ || l ~ /CMPI\.L #\$?E,ED_RASTPORT2PENMODESELECTOR/ || l ~ /CMP\.L #\$?E,D[0-7]/ || l ~ /CMP\.W #\$?E,D[0-7]/) has_cmp14 = 1
    if (l ~ /(JSR|BSR).*_LVOSETBPEN/) has_bpen = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_DRMD=" has_drmd
    print "HAS_APEN=" has_apen
    print "HAS_CMP14=" has_cmp14
    print "HAS_BPEN=" has_bpen
    print "HAS_RTS=" has_rts
}
