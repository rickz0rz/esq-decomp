BEGIN {
    has_signal_test = 0
    has_signal_call = 0
    has_ioerr_clear = 0
    has_read_call = 0
    has_minus_one_check = 0
    has_ioerr_call = 0
    has_ioerr_store = 0
    has_app_errcode_set = 0
    has_return = 0
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
    if (u ~ /JSR .*DOS_READ/ || u ~ /JSR .*LVOREAD/) has_read_call = 1
    if (u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^CMPI?\.L #-1,D[0-7]$/) has_minus_one_check = 1
    if (u ~ /JSR .*DOS_IOERR/ || u ~ /JSR .*LVOIOERR/) has_ioerr_call = 1
    if (u ~ /GLOBAL_DOSIOERR/) has_ioerr_store = 1

    if ((u ~ /^MOVEQ #5,D[0-7]$/ || u ~ /^MOVE\.L #5,D[0-7]$/ || u ~ /^MOVE\.L #\$5,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_app_errcode_set = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/ || u ~ /^MOVEQ #0,D0$/ || u ~ /^MOVEQ #-1,D0$/) has_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNAL_TEST=" has_signal_test
    print "HAS_SIGNAL_CALL=" has_signal_call
    print "HAS_IOERR_CLEAR=" has_ioerr_clear
    print "HAS_READ_CALL=" has_read_call
    print "HAS_MINUS_ONE_CHECK=" has_minus_one_check
    print "HAS_IOERR_CALL=" has_ioerr_call
    print "HAS_IOERR_STORE=" has_ioerr_store
    print "HAS_APP_ERRCODE_SET=" has_app_errcode_set
    print "HAS_RETURN=" has_return
    print "HAS_RTS=" has_rts
}
