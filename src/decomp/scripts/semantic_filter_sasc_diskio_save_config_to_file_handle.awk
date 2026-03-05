BEGIN {
    has_entry = 0
    has_open = 0
    has_fail = 0
    has_sprintf = 0
    has_write = 0
    has_close = 0
    has_success = 0
    has_exit = 0
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

    if (l ~ /^DISKIO_SAVECONFIGTOFILEHANDLE:/ || l ~ /^DISKIO_SAVECONFIGTOFILEHA/) has_entry = 1
    if (index(l, "DISKIO_OPENFILEWITHBUFFER") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_open = 1
    if (l ~ /^MOVEQ #\-1,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #\$FF,D[0-7]$/ || l ~ /^MOVE\.L #\-1,D[0-7]$/) has_fail = 1
    if ((index(l, "WDISP_SPRINTF") > 0 || index(l, "GROUP_AE_JMPTBL_WDISP_SP") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_sprintf = 1
    if (index(l, "DISKIO_WRITEBUFFEREDBYTES") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_write = 1
    if (index(l, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_close = 1
    if (l ~ /^MOVEQ #0,D[0-7]$/ || l ~ /^MOVEQ(\.L)? #\$0,D[0-7]$/) has_success = 1
    if (l ~ /^RTS$/ || index(l, "DISKIO_SAVECONFIGTOFILEHANDLE_RETURN") > 0) has_exit = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_OPEN=" has_open
    print "HAS_FAIL=" has_fail
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_WRITE=" has_write
    print "HAS_CLOSE=" has_close
    print "HAS_SUCCESS=" has_success
    print "HAS_EXIT=" has_exit
}
