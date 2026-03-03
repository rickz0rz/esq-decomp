BEGIN {
    has_entry = 0
    has_link = 0
    has_deferred_flag = 0
    has_cache = 0
    has_readpixel = 0
    has_setapen = 0
    has_rectfill = 0
    has_restore = 0
    has_return = 0
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

    if (uline ~ /^ESQDISP_SETSTATUSINDICATORCOLORSLOT:/) has_entry = 1
    if (uline ~ /LINK\.W A5,#-20/) has_link = 1
    if (uline ~ /ESQDISP_STATUSINDICATORDEFERREDAPPLYFLAG/) has_deferred_flag = 1
    if (uline ~ /ESQDISP_STATUSINDICATORCOLORCACHE/) has_cache = 1
    if (uline ~ /LVOREADPIXEL/) has_readpixel = 1
    if (uline ~ /LVOSETAPEN/) has_setapen = 1
    if (uline ~ /LVORECTFILL/) has_rectfill = 1
    if (uline ~ /MOVE\.L -4\(A5\),4\(A0\)/) has_restore = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_DEFERRED_FLAG=" has_deferred_flag
    print "HAS_CACHE=" has_cache
    print "HAS_READPIXEL=" has_readpixel
    print "HAS_SETAPEN=" has_setapen
    print "HAS_RECTFILL=" has_rectfill
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
