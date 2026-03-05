BEGIN {
    has_label = 0
    has_setapen = 0
    has_rectfill = 0
    has_bevel = 0
    has_bitmap_swap = 0
    has_restore = 0
    has_dims = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWBANNERSPACERSEGMENT[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPRIGHT/ || u ~ /BEVEL_DRAWBEVELFRAMEWITHTOPR/) has_bevel = 1
    if ((u ~ /GLOBAL_REF_696_400_BITMAP/ && (u ~ /4\(A0\)/ || u ~ /4\(A[0-7]\)/)) || u ~ /MOVE.L A0,\(A1\)/) has_bitmap_swap = 1
    if (u ~ /MOVE.L -4\(A5\),4\(A0\)/ || u ~ /MOVE.L D[0-7],4\(A[0-7]\)/ || u ~ /MOVE.L D[0-7],\(A0\)/) has_restore = 1
    if (u ~ /#256/ || u ~ /#\$100/ || u ~ /PEA \(\$100\)\.W/ || u ~ /PEA 256\.W/) has_dims = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_BEVEL=" has_bevel
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RESTORE=" has_restore
    print "HAS_DIMS=" has_dims
    print "HAS_RETURN=" has_return
}
