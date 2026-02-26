BEGIN {
    has_get_entry_call = 0
    has_null_check = 0
    has_flag_check = 0
    has_close_call = 0
    has_clear_entry = 0
    has_ioerr_test = 0
    has_fail_return = 0
    has_success_return = 0
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

    if (u ~ /JSR .*HANDLE_GETENTRYBYINDEX/) has_get_entry_call = 1
    if (u ~ /^TST\.L/ || u ~ /^CMPI?\.L #0,/ || u ~ /^BEQ/ || u ~ /^BNE/) has_null_check = 1
    if (u ~ /^BTST #4,/ || u ~ /ANDI?\.L #\$?10/ || u ~ /ANDI?\.B #\$?10/) has_flag_check = 1
    if (u ~ /JSR .*DOS_CLOSEWITHSIGNALCHECK/) has_close_call = 1
    if (u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.L #0,\(A[0-7]\)$/ || u ~ /^CLR\.L \(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],0\(A[0-7]\)$/) has_clear_entry = 1
    if (u ~ /GLOBAL_DOSIOERR/ || u ~ /^TST\.L .*DOSIOERR/) has_ioerr_test = 1
    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_fail_return = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) has_success_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_GET_ENTRY_CALL=" has_get_entry_call
    print "HAS_NULL_CHECK=" has_null_check
    print "HAS_FLAG_CHECK=" has_flag_check
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_CLEAR_ENTRY=" has_clear_entry
    print "HAS_IOERR_TEST=" has_ioerr_test
    print "HAS_FAIL_RETURN=" has_fail_return
    print "HAS_SUCCESS_RETURN=" has_success_return
    print "HAS_RTS=" has_rts
}
