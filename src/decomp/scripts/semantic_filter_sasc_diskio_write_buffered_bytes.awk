BEGIN {
    has_entry = 0
    has_guard = 0
    has_tick = 0
    has_copy = 0
    has_remaining_dec = 0
    has_write = 0
    has_errorflag_set = 0
    has_reset_buffer = 0
    has_result_move = 0
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

    if (l ~ /^DISKIO_WRITEBUFFEREDBYTES:/ || l ~ /^DISKIO_WRITEBUFFEREDBYT/) has_entry = 1
    if ((index(l, "DISKIO_BUFFERCONTROL") > 0 && index(l, "ERRORFLAG") > 0) || index(l, "TST.L D7") > 0 || index(l, "BEQ") == 1) has_guard = 1
    if ((index(l, "ESQFUNC_SERVICEUITICKIFRUNNING") > 0 || index(l, "ESQFUNC_SERVICEU") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_tick = 1
    if (l ~ /^MOVE\.B \(A[0-7]\)\+,\(A[0-7]\)\+$/) has_copy = 1
    if (index(l, "DISKIO_BUFFERSTATE") > 0 && (index(l, "REMAINING") > 0 || index(l, "+$8") > 0) && (l ~ /^SUBQ\.[LW] #\$?1,/ || l ~ /^SUB\.[LW] #\$?1,/)) has_remaining_dec = 1
    if (index(l, "_LVOWRITE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_write = 1
    if (index(l, "DISKIO_BUFFERCONTROL") > 0 && (index(l, "ERRORFLAG") > 0 || index(l, "+$4") > 0) && (index(l, "#1,") > 0 || index(l, "#$1,") > 0)) has_errorflag_set = 1
    if (index(l, "DISKIO_BUFFERSTATE") > 0 && ((index(l, "BUFFERPTR") > 0 || l ~ /^MOVE\.L D[0-7],DISKIO_BUFFERSTATE\(A4\)$/) || (index(l, "REMAINING") > 0 || index(l, "+$8") > 0))) has_reset_buffer = 1
    if (l ~ /^MOVE\.L D[0-7],D0$/) has_result_move = 1
    if (l ~ /^RTS$/ || l ~ /^BRA(\.[A-Z]+)? DISKIO_WRITEBUFFEREDBYTES_RETURN$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_TICK=" has_tick
    print "HAS_COPY=" has_copy
    print "HAS_REMAINING_DEC=" has_remaining_dec
    print "HAS_WRITE=" has_write
    print "HAS_ERRORFLAG_SET=" has_errorflag_set
    print "HAS_RESET_BUFFER=" has_reset_buffer
    print "HAS_RESULT_MOVE=" has_result_move
    print "HAS_RTS=" has_rts
}
