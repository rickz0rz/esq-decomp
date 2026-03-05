BEGIN {
    has_entry = 0
    has_lock = 0
    has_alloc = 0
    has_info = 0
    has_free = 0
    has_unlock = 0
    has_rts = 0
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

    if (l ~ /^DISKIO_QUERYVOLUMESOFTERRORCOUNT:/) has_entry = 1
    if (index(l, "_LVOLOCK") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_lock = 1
    if ((index(l, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(l, "GROUP_AG_JMPTBL_MEMORY_ALLOCAT") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_alloc = 1
    if (index(l, "_LVOINFO") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_info = 1
    if ((index(l, "GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(l, "GROUP_AG_JMPTBL_MEMORY_DEALLOCAT") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_free = 1
    if (index(l, "_LVOUNLOCK") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_unlock = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOCK=" has_lock
    print "HAS_ALLOC=" has_alloc
    print "HAS_INFO=" has_info
    print "HAS_FREE=" has_free
    print "HAS_UNLOCK=" has_unlock
    print "HAS_RTS=" has_rts
}
