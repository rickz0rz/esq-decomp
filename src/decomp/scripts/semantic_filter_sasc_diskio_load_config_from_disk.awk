BEGIN {
    has_entry = 0
    has_load = 0
    has_fail = 0
    has_parse = 0
    has_free = 0
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

    if (l ~ /^DISKIO_LOADCONFIGFROMDISK:/ || l ~ /^DISKIO_LOADCONFIGFROMDI/) has_entry = 1
    if (index(l, "DISKIO_LOADFILETOWORKBUFFER") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_load = 1
    if (l ~ /^MOVEQ #\-1,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #\$FF,D[0-7]$/ || l ~ /^MOVE\.L #\-1,D[0-7]$/) has_fail = 1
    if (index(l, "DISKIO_PARSECONFIGBUFFER") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_parse = 1
    if ((index(l, "MEMORY_DEALLOCATEMEMORY") > 0 || index(l, "MEMORY_DEALLOCAT") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_free = 1
    if (l ~ /^MOVEQ #0,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/) has_success = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_FAIL=" has_fail
    print "HAS_PARSE=" has_parse
    print "HAS_FREE=" has_free
    print "HAS_SUCCESS=" has_success
    print "HAS_RTS=" has_rts
}
