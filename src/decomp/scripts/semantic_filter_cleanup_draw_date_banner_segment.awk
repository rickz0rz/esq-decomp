BEGIN {
    has_label = 0
    has_link = 0
    has_setapen = 0
    has_rectfill = 0
    has_render = 0
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

    if (uline ~ /^CLEANUP_DRAWDATEBANNERSEGMENT:/) has_label = 1
    if (uline ~ /LINK.W A5,#-4/ && uline ~ /MOVEM.L D2-D3,-\(A7\)/) has_link = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY/) has_render = 1
    if (uline ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/) has_bevel = 1
    if (uline ~ /GLOBAL_REF_696_400_BITMAP/ && uline ~ /BITMAP/) has_bitmap_swap = 1
    if (uline ~ /MOVE.L .*A5\),STRUCT_RASTPORT__BITMAP\(A0\)/ || uline ~ /MOVE.L .*A5\),4\(A0\)/) has_restore = 1
    if (uline ~ /#40/ && uline ~ /#67/) has_dims = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_RENDER=" has_render
    print "HAS_BEVEL=" has_bevel
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RESTORE=" has_restore
    print "HAS_DIMS=" has_dims
}
