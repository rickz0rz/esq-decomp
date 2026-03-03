BEGIN {
    has_entry = 0
    has_depth = 0
    has_shift = 0
    has_muls = 0
    has_rgb_add_d2 = 0
    has_rgb_add_d1 = 0
    has_best_store = 0
    has_setapen = 0
    has_unlk = 0
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

    if (uline ~ /^ESQIFF_SETAPENTOBRIGHTESTPALETTEINDEX:/) has_entry = 1
    if (uline ~ /MOVE\.B WDISP_PALETTEDEPTHLOG2,D0/) has_depth = 1
    if (uline ~ /ASL\.L D0,D1/) has_shift = 1
    if (uline ~ /MULS D1,D0/ || uline ~ /MULS D1,D2/) has_muls = 1
    if (uline ~ /ADD\.L D2,D0/) has_rgb_add_d2 = 1
    if (uline ~ /ADD\.L D1,D0/) has_rgb_add_d1 = 1
    if (uline ~ /^MOVE\.L D0,-14\(A5\)$/) has_best_store = 1
    if (uline ~ /LVOSETAPEN\(A6\)/) has_setapen = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DEPTH=" has_depth
    print "HAS_SHIFT=" has_shift
    print "HAS_MULS=" has_muls
    print "HAS_RGB_SUM=" (has_rgb_add_d2 && has_rgb_add_d1)
    print "HAS_BEST_STORE=" has_best_store
    print "HAS_SETAPEN=" has_setapen
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
