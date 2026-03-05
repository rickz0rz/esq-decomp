BEGIN {
    has_entry = 0
    has_msgport = 0
    has_alloc = 0
    has_open_device = 0
    has_doio = 0
    has_close_device = 0
    has_free = 0
    has_cleanup = 0
    has_check_path = 0
    has_execute = 0
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

    if (l ~ /^DISKIO_PROBEDRIVESANDASSIGNPATHS:/ || l ~ /^DISKIO_PROBEDRIVESANDASSIGNPAT/) has_entry = 1
    if ((index(l, "SIGNAL_CREATEMSGPORTWITHSIGNAL") > 0 || index(l, "GROUP_AG_JMPTBL_SIGNAL_CREATEMSG") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_msgport = 1
    if ((index(l, "STRUCT_ALLOCWITHOWNER") > 0 || index(l, "GROUP_AG_JMPTBL_STRUCT_ALLOCW") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_alloc = 1
    if (index(l, "_LVOOPENDEVICE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_open_device = 1
    if (index(l, "_LVODOIO") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_doio = 1
    if (index(l, "_LVOCLOSEDEVICE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_close_device = 1
    if ((index(l, "STRUCT_FREEWITHSIZEFIELD") > 0 || index(l, "GROUP_AG_JMPTBL_STRUCT_FREEW") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_free = 1
    if ((index(l, "IOSTDREQ_CLEANUPSIGNALANDMSGPORT") > 0 || index(l, "GROUP_AG_JMPTBL_IOSTDREQ_CLEANUP") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_cleanup = 1
    if ((index(l, "SCRIPT_CHECKPATHEXISTS") > 0 || index(l, "GROUP_AG_JMPTBL_SCRIPT_CHECKPATH") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_check_path = 1
    if (index(l, "_LVOEXECUTE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_execute = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MSGPORT=" has_msgport
    print "HAS_ALLOC=" has_alloc
    print "HAS_OPEN_DEVICE=" has_open_device
    print "HAS_DOIO=" has_doio
    print "HAS_CLOSE_DEVICE=" has_close_device
    print "HAS_FREE=" has_free
    print "HAS_CLEANUP=" has_cleanup
    print "HAS_CHECK_PATH=" has_check_path
    print "HAS_EXECUTE=" has_execute
    print "HAS_RTS=" has_rts
}
