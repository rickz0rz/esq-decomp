BEGIN {
    has_label = 0
    has_link = 0
    has_setapen = 0
    has_rectfill = 0
    has_gridtime = 0
    has_bevel = 0
    has_bitmap_swap = 0
    has_restore = 0
    has_dims = 0
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

    if (uline ~ /^CLEANUP_DRAWTIMEBANNERSEGMENT:/) has_label = 1
    if (uline ~ /LINK.W A5,#-4/ && uline ~ /MOVEM.L D2-D3,-\(A7\)/) has_link = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /CLEANUP_DRAWGRIDTIMEBANNER/) has_gridtime = 1
    if (uline ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/) has_bevel = 1
    if (uline ~ /GLOBAL_REF_696_400_BITMAP/ && uline ~ /4\(A0\)/) has_bitmap_swap = 1
    if (uline ~ /MOVE.L -4\(A5\),4\(A0\)/) has_restore = 1
    if (uline ~ /#448/ && uline ~ /#663/ && uline ~ /#67/) has_dims = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_GRIDTIME=" has_gridtime
    print "HAS_BEVEL=" has_bevel
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RESTORE=" has_restore
    print "HAS_DIMS=" has_dims
}
