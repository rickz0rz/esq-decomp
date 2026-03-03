BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_setapen = 0
    has_rectfill = 0
    has_move = 0
    has_draw = 0
    has_restore_pen_move = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_DRAWINSETRECTFRAME:/) has_label = 1
    if (uline ~ /LINK.W A5,#-24/) has_link = 1
    if (uline ~ /MOVEM.L D2-D7\/A3,-\(A7\)/) has_save = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /LVOMOVE/) has_move = 1
    if (uline ~ /LVODRAW/) has_draw = 1
    if (uline ~ /MOVE.L D4,D0/) has_restore_pen_move = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D2-D7\/A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_MOVE=" has_move
    print "HAS_DRAW=" has_draw
    print "HAS_RESTORE_PEN_MOVE=" has_restore_pen_move
    print "HAS_RESTORE=" has_restore
}
