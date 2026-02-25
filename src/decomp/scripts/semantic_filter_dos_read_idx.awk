BEGIN {
    has_lookup_call = 0
    has_null_guard = 0
    has_read_call = 0
    has_ioerr_test = 0
    has_minus_one_path = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /JSR .*HANDLE_GETENTRYBYINDEX/) has_lookup_call = 1
    if (u ~ /JSR .*DOS_READWITHERRORSTATE/) has_read_call = 1

    if (u ~ /^TST\.L D0$/ || u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^CMP\.L #0,D0$/) has_null_guard = 1
    if (u ~ /^(BEQ|BEQ\.S|JEQ|JEQ\.S) /) has_null_guard = 1

    if (u ~ /GLOBAL_DOSIOERR/ || u ~ /GLOBAL_DOSIOERR\(A4\)/) has_ioerr_test = 1
    if (u ~ /^TST\.L .*GLOBAL_DOSIOERR/ || u ~ /^TST\.L GLOBAL_DOSIOERR\(A4\)$/) has_ioerr_test = 1

    if (u ~ /^MOVEQ #-1,D0$/ || u ~ /^MOVE\.L #-1,D0$/) has_minus_one_path = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_LOOKUP_CALL=" has_lookup_call
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_READ_CALL=" has_read_call
    print "HAS_IOERR_TEST=" has_ioerr_test
    print "HAS_MINUS_ONE_PATH=" has_minus_one_path
    print "HAS_RTS=" has_rts
}
