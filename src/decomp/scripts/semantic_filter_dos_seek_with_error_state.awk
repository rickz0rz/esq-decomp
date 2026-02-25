BEGIN {
    has_signal_test = 0
    has_signal_call = 0
    has_ioerr_clear = 0
    has_initial_seek_call = 0
    has_minus_two_adjust = 0
    has_minus_one_check = 0
    has_ioerr_call = 0
    has_ioerr_store = 0
    has_app_errcode_set = 0
    has_mode_compare = 0
    has_mode2_seek = 0
    has_mode1_adjust = 0
    has_mode0_return = 0
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
    if (u ~ /JSR .*DOS_SEEK/ || u ~ /JSR .*LVOSEEK/) has_initial_seek_call = 1
    if (u ~ /SUBQ\.L #2,D[0-7]/ || u ~ /SUBI?\.L #2,D[0-7]/ || u ~ /ADDQ\.L #-2,D[0-7]/ || u ~ /SUBQ\.L #\(OFFSET_END\),D[0-7]/ || u ~ /^PEA \(-2,A[0-7]\)$/) has_minus_two_adjust = 1

    if (u ~ /^MOVEQ #-1,D[0-7]$/ || u ~ /^CMPI?\.L #-1,D[0-7]$/) has_minus_one_check = 1
    if (u ~ /JSR .*DOS_IOERR/ || u ~ /JSR .*LVOIOERR/) has_ioerr_call = 1
    if (u ~ /GLOBAL_DOSIOERR/) has_ioerr_store = 1
    if ((u ~ /^MOVEQ #22,D[0-7]$/ || u ~ /^MOVE\.L #22,D[0-7]$/ || u ~ /^MOVE\.L #\$16,D[0-7]$/) || u ~ /GLOBAL_APPERRORCODE/) has_app_errcode_set = 1

    if (u ~ /^CMPI?\.L #2,D[0-7]$/ || u ~ /^CMPI?\.L #1,D[0-7]$/ || u ~ /^TST\.L D[0-7]$/ || u ~ /^CMP\.L A[0-7],D[0-7]$/ || u ~ /^CMP\.L D[0-7],A[0-7]$/) has_mode_compare = 1
    if (u ~ /JSR .*DOS_SEEK/ || u ~ /JSR .*LVOSEEK/) has_mode2_seek = 1
    if (u ~ /^ADD\.L D[0-7],D0$/ || u ~ /^ADD\.L D[0-7],D[0-7]$/) has_mode1_adjust = 1
    if (u ~ /^MOVE\.L D[0-7],D0$/) has_mode0_return = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIGNAL_TEST=" has_signal_test
    print "HAS_SIGNAL_CALL=" has_signal_call
    print "HAS_IOERR_CLEAR=" has_ioerr_clear
    print "HAS_INITIAL_SEEK_CALL=" has_initial_seek_call
    print "HAS_MINUS_TWO_ADJUST=" has_minus_two_adjust
    print "HAS_MINUS_ONE_CHECK=" has_minus_one_check
    print "HAS_IOERR_CALL=" has_ioerr_call
    print "HAS_IOERR_STORE=" has_ioerr_store
    print "HAS_APP_ERRCODE_SET=" has_app_errcode_set
    print "HAS_MODE_COMPARE=" has_mode_compare
    print "HAS_MODE2_SEEK=" has_mode2_seek
    print "HAS_MODE1_ADJUST=" has_mode1_adjust
    print "HAS_MODE0_RETURN=" has_mode0_return
    print "HAS_RTS=" has_rts
}
