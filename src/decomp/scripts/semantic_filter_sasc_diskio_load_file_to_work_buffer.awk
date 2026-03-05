BEGIN {
    has_entry = 0
    has_open = 0
    has_getsize = 0
    has_size_store = 0
    has_alloc = 0
    has_read = 0
    has_close = 0
    has_free = 0
    has_fail = 0
    has_success = 0
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

    if (l ~ /^DISKIO_LOADFILETOWORKBUFFER:/ || l ~ /^DISKIO_LOADFILETOWORKBUF:/) has_entry = 1
    if ((index(l, "DOS_OPENFILEWITHMODE") > 0 || index(l, "DOS_OPENFILEWITH") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_open = 1
    if (index(l, "DISKIO_GETFILESIZEFROMHANDLE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_getsize = 1
    if (index(l, "GLOBAL_REF_LONG_FILE_SCRATCH") > 0 && (l ~ /^MOVE\.L D0,/ || l ~ /^MOVE\.L D[0-7],/)) has_size_store = 1
    if ((index(l, "MEMORY_ALLOCATEMEMORY") > 0 || index(l, "MEMORY_ALLOCATEM") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_alloc = 1
    if (index(l, "_LVOREAD") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_read = 1
    if (index(l, "_LVOCLOSE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_close = 1
    if ((index(l, "MEMORY_DEALLOCATEMEMORY") > 0 || index(l, "MEMORY_DEALLOCAT") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_free = 1
    if (l ~ /^MOVEQ(\.L)? #\-1,D0$/ || l ~ /^MOVEQ(\.L)? #\$FF,D0$/ || l ~ /^MOVE\.L #\-1,D0$/ || l ~ /^MOVE\.L #\$FFFFFFFF,D0$/) has_fail = 1
    if (index(l, "GLOBAL_REF_LONG_FILE_SCRATCH") > 0 && l ~ /^MOVE\.L / && index(l, ",D0") > 0) has_success = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OPEN=" has_open
    print "HAS_GETSIZE=" has_getsize
    print "HAS_SIZE_STORE=" has_size_store
    print "HAS_ALLOC=" has_alloc
    print "HAS_READ=" has_read
    print "HAS_CLOSE=" has_close
    print "HAS_FREE=" has_free
    print "HAS_FAIL=" has_fail
    print "HAS_SUCCESS=" has_success
    print "HAS_RTS=" has_rts
}
