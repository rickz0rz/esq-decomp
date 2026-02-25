BEGIN {
    has_signal_test = 0
    has_signal_call = 0
    has_ioerr_clear = 0
    has_lock_call = 0
    has_lock_check = 0
    has_unlock_call = 0
    has_open_call = 0
    has_open_fail_check = 0
    has_ioerr_call = 0
    has_ioerr_store = 0
    has_errcode_set = 0
    has_minus_one_path = 0
    has_rts = 0
}

function trim(s,    t) {
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
    u = toupper(line)

    if (u ~ /GLOBAL_SIGNALCALLBACKPTR/) has_signal_test = 1
    if (u ~ /JSR .*SIGNAL_POLLANDDISPATCH/) has_signal_call = 1
    if (u ~ /^CLR\.L .*GLOBAL_DOSIOERR/ || u ~ /^MOVE\.L #0,.*GLOBAL_DOSIOERR/) has_ioerr_clear = 1

    if (u ~ /JSR .*DOS_LOCK/ || u ~ /JSR .*LVOLOCK/) has_lock_call = 1
    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L #0,D[0-7]$/) has_lock_check = 1
    if (u ~ /JSR .*DOS_UNLOCK/ || u ~ /JSR .*LVOUNLOCK/) has_unlock_call = 1

    if (u ~ /JSR .*DOS_OPEN/ || u ~ /JSR .*LVOOPEN/) has_open_call = 1
    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L #0,D[0-7]$/) has_open_fail_check = 1
    if (u ~ /JSR .*DOS_IOERR/ || u ~ /JSR .*LVOIOERR/) has_ioerr_call = 1
    if (u ~ /GLOBAL_DOSIOERR/) has_ioerr_store = 1
    if ((u ~ /^MOVEQ #2,D[0-7]$/ || u ~ /^MOVE\.L #2,D[0-7]$/ || u ~ /^MOVE\.L #\$2,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_errcode_set = 1
    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_minus_one_path = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNAL_TEST=" has_signal_test
    print "HAS_SIGNAL_CALL=" has_signal_call
    print "HAS_IOERR_CLEAR=" has_ioerr_clear
    print "HAS_LOCK_CALL=" has_lock_call
    print "HAS_LOCK_CHECK=" has_lock_check
    print "HAS_UNLOCK_CALL=" has_unlock_call
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_OPEN_FAIL_CHECK=" has_open_fail_check
    print "HAS_IOERR_CALL=" has_ioerr_call
    print "HAS_IOERR_STORE=" has_ioerr_store
    print "HAS_ERRCODE_SET=" has_errcode_set
    print "HAS_MINUS_ONE_PATH=" has_minus_one_path
    print "HAS_RTS=" has_rts
}
