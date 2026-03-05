BEGIN {
    has_entry = 0
    has_service = 0
    has_guard = 0
    has_error_clear = 0
    has_open = 0
    has_save_mode = 0
    has_open_count_inc = 0
    has_set_mode = 0
    has_alloc = 0
    has_state_update = 0
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

    if (l ~ /^DISKIO_OPENFILEWITHBUFFER:/ || l ~ /^DISKIO_OPENFILEWITHBUFF/) has_entry = 1
    if ((index(l, "ESQFUNC_SERVICEUITICKIFRUNNING") > 0 || index(l, "ESQFUNC_SERVICEU") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_service = 1
    if (index(l, "DISKIO_OPENCOUNT") > 0 && (l ~ /^TST\.L / || l ~ /^MOVE\.L .*?,D0$/)) has_guard = 1
    if (index(l, "DISKIO_BUFFERCONTROL") > 0 && (index(l, "ERRORFLAG") > 0 || index(l, "+$4") > 0) && (l ~ /^CLR\.L / || (index(l, "#0,") > 0 && l ~ /^MOVE\.L /))) has_error_clear = 1
    if ((index(l, "DOS_OPENFILEWITHMODE") > 0 || index(l, "DOS_OPENFILEWITH") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_open = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && (index(l, "SAVEDF45") > 0 || index(l, "DISKIO_BUFFERSTATE+$C") > 0) && l ~ /^MOVE\.[WL] /) has_save_mode = 1
    if (index(l, "DISKIO_OPENCOUNT") > 0 && (l ~ /^ADDQ\.L #\$?1,/ || l ~ /^ADDQ\.L #1,/ || l ~ /^ADD\.L #\$?1,/)) has_open_count_inc = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && index(l, "#$100") > 0) has_set_mode = 1
    if ((index(l, "MEMORY_ALLOCATEMEMORY") > 0 || index(l, "MEMORY_ALLOCATEM") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_alloc = 1
    if (index(l, "DISKIO_BUFFERSTATE") > 0 && (index(l, "REMAINING") > 0 || index(l, "BUFFERPTR") > 0 || index(l, "DISKIO_BUFFERSTATE+$8") > 0 || l ~ /^MOVE\.L D[0-7],DISKIO_BUFFERSTATE\(A4\)$/)) has_state_update = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SERVICE=" has_service
    print "HAS_GUARD=" has_guard
    print "HAS_ERROR_CLEAR=" has_error_clear
    print "HAS_OPEN=" has_open
    print "HAS_SAVE_MODE=" has_save_mode
    print "HAS_OPEN_COUNT_INC=" has_open_count_inc
    print "HAS_SET_MODE=" has_set_mode
    print "HAS_ALLOC=" has_alloc
    print "HAS_STATE_UPDATE=" has_state_update
    print "HAS_RTS=" has_rts
}
