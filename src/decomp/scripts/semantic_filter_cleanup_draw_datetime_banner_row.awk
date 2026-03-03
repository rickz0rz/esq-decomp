BEGIN {
    has_label = 0
    has_link = 0
    has_setapen = 0
    has_rectfill = 0
    has_draw_date = 0
    has_draw_spacer = 0
    has_draw_time = 0
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

    if (uline ~ /^CLEANUP_DRAWDATETIMEBANNERROW:/) has_label = 1
    if (uline ~ /LINK.W A5,#-4/ && uline ~ /MOVEM.L D2-D3,-\(A7\)/) has_link = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /CLEANUP_DRAWDATEBANNERSEGMENT/) has_draw_date = 1
    if (uline ~ /CLEANUP_DRAWBANNERSPACERSEGMENT/) has_draw_spacer = 1
    if (uline ~ /CLEANUP_DRAWTIMEBANNERSEGMENT/) has_draw_time = 1
    if (uline ~ /GLOBAL_REF_696_400_BITMAP/ && uline ~ /4\(A0\)/) has_bitmap_swap = 1
    if (uline ~ /MOVE.L -4\(A5\),4\(A0\)/) has_restore = 1
    if (uline ~ /#695/ && uline ~ /#67/ && uline ~ /#34/) has_dims = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_DRAW_DATE=" has_draw_date
    print "HAS_DRAW_SPACER=" has_draw_spacer
    print "HAS_DRAW_TIME=" has_draw_time
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RESTORE=" has_restore
    print "HAS_DIMS=" has_dims
}
