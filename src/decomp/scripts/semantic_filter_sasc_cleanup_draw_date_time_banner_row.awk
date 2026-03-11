BEGIN {
    has_label = 0
    has_setapen = 0
    has_rectfill = 0
    has_date = 0
    has_spacer = 0
    has_time = 0
    has_bitmap_swap = 0
    has_restore = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_DRAWDATETIMEBANNERROW[A-Z0-9_]*:/) has_label = 1
    if (u ~ /_LVOSETAPEN/) has_setapen = 1
    if (u ~ /_LVORECTFILL/) has_rectfill = 1
    if (u ~ /CLEANUP_DRAWDATEBANNERSEGMENT/ || u ~ /CLEANUP_DRAWDATEBANNERSE/) has_date = 1
    if (u ~ /CLEANUP_DRAWBANNERSPACERSEGMENT/ || u ~ /CLEANUP_DRAWBANNERSPACERS/) has_spacer = 1
    if (u ~ /CLEANUP_DRAWTIMEBANNERSEGMENT/ || u ~ /CLEANUP_DRAWTIMEBANNERSE/) has_time = 1
    if ((u ~ /GLOBAL_REF_696_400_BITMAP/ && (u ~ /\$?4\(A0\)/ || u ~ /\$?4\(A[0-7]\)/)) || u ~ /MOVE.L A0,\(A1\)/ || u ~ /MOVE.L A0,\$?4\(A[0-7]\)/) has_bitmap_swap = 1
    if (u ~ /MOVE.L -4\(A5\),\$?4\(A0\)/ || u ~ /MOVE.L D[0-7],\$?4\(A[0-7]\)/ || u ~ /MOVE.L D[0-7],\(A0\)/) has_restore = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_DATE=" has_date
    print "HAS_SPACER=" has_spacer
    print "HAS_TIME=" has_time
    print "HAS_BITMAP_SWAP=" has_bitmap_swap
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
