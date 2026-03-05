BEGIN {
    has_entry = 0
    has_tick = 0
    has_error_clear = 0
    has_write = 0
    has_start_close = 0
    has_delay = 0
    has_wait_flag = 0
    has_free = 0
    has_open_count_dec = 0
    has_restore_mode = 0
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

    if (l ~ /^DISKIO_CLOSEBUFFEREDFILEANDFLUSH:/ || l ~ /^DISKIO_CLOSEBUFFEREDFILEANDFL/) has_entry = 1
    if ((index(l, "ESQFUNC_SERVICEUITICKIFRUNNING") > 0 || index(l, "ESQFUNC_SERVICEU") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_tick = 1
    if (index(l, "DISKIO_BUFFERCONTROL") > 0 && (index(l, "ERRORFLAG") > 0 || index(l, "+$4") > 0) && (l ~ /^CLR\.L / || (index(l, "#0,") > 0 && l ~ /^MOVE\.L /))) has_error_clear = 1
    if (index(l, "_LVOWRITE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_write = 1
    if (index(l, "CTASKS_STARTCLOSETASKPROCESS") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_start_close = 1
    if (index(l, "_LVODELAY") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_delay = 1
    if (index(l, "CTASKS_CLOSETASKCOMPLETIONFLAG") > 0 && (l ~ /^TST\.[WB] / || l ~ /^MOVE\.[WB] .*?,D[0-7]$/)) has_wait_flag = 1
    if ((index(l, "MEMORY_DEALLOCATEMEMORY") > 0 || index(l, "MEMORY_DEALLOCAT") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_free = 1
    if (index(l, "DISKIO_OPENCOUNT") > 0 && (l ~ /^SUBQ\.L #\$?1,/ || l ~ /^SUBQ\.L #1,/ || l ~ /^SUB\.L #\$?1,/)) has_open_count_dec = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && (index(l, "SAVEDF45") > 0 || index(l, "DISKIO_BUFFERSTATE+$C") > 0)) has_restore_mode = 1
    if (l ~ /^RTS$/ || index(l, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH_RETURN") > 0) has_exit = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TICK=" has_tick
    print "HAS_ERROR_CLEAR=" has_error_clear
    print "HAS_WRITE=" has_write
    print "HAS_START_CLOSE=" has_start_close
    print "HAS_DELAY=" has_delay
    print "HAS_WAIT_FLAG=" has_wait_flag
    print "HAS_FREE=" has_free
    print "HAS_OPEN_COUNT_DEC=" has_open_count_dec
    print "HAS_RESTORE_MODE=" has_restore_mode
    print "HAS_EXIT=" has_exit
}
