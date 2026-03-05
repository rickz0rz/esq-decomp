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

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /LINK\.W A5,#-20/ || l ~ /^SUB\.[WL] #\$?[0-9A-F]+,A7$/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_link = 1
    if (l ~ /ESQDISP_STATUSINDICATORDEFERREDAPPLYFLAG/ || l ~ /ESQDISP_STATUSINDICATORDEFERREDA/) has_deferred_flag = 1
    if (l ~ /ESQDISP_STATUSINDICATORCOLORCACHE/ || l ~ /ESQDISP_STATUSINDICATORCOLORCACH/) has_cache = 1
    if (l ~ /LVOREADPIXEL/) has_readpixel = 1
    if (l ~ /LVOSETAPEN/) has_setapen = 1
    if (l ~ /LVORECTFILL/) has_rectfill = 1
    if (l ~ /MOVE\.L -4\(A5\),4\(A0\)/ || l ~ /MOVE\.L .*\(A[0-7]\),4\(A[0-7]\)/ || l ~ /BITMAP/) has_restore = 1
    if (l ~ /^RTS$/) has_return = 1
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
