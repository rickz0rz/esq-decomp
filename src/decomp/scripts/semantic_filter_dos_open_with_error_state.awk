BEGIN {
    has_signal_test = 0
    has_signal_call = 0
    has_ioerr_clear = 0
    has_open_call = 0
    has_zero_check = 0
    has_ioerr_call = 0
    has_ioerr_store = 0
    has_app_errcode_set = 0
    has_fail_return = 0
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
    if (u ~ /JSR .*DOS_OPEN/ || u ~ /JSR .*LVOOPEN/) has_open_call = 1
    if (u ~ /^TST\.L D[0-7]$/ || u ~ /^CMPI?\.L #0,D[0-7]$/ || u ~ /^BEQ/) has_zero_check = 1
    if (u ~ /JSR .*DOS_IOERR/ || u ~ /JSR .*LVOIOERR/) has_ioerr_call = 1
    if (u ~ /GLOBAL_DOSIOERR/) has_ioerr_store = 1

    if ((u ~ /^MOVEQ #2,D[0-7]$/ || u ~ /^MOVE\.L #2,D[0-7]$/ || u ~ /^MOVE\.L #\$2,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_app_errcode_set = 1
    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_fail_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNAL_TEST=" has_signal_test
    print "HAS_SIGNAL_CALL=" has_signal_call
    print "HAS_IOERR_CLEAR=" has_ioerr_clear
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_ZERO_CHECK=" has_zero_check
    print "HAS_IOERR_CALL=" has_ioerr_call
    print "HAS_IOERR_STORE=" has_ioerr_store
    print "HAS_APP_ERRCODE_SET=" has_app_errcode_set
    print "HAS_FAIL_RETURN=" has_fail_return
    print "HAS_RTS=" has_rts
}
