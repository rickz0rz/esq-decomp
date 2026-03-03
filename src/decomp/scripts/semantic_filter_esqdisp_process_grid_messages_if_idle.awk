BEGIN {
    has_entry = 0
    has_test_block = 0
    has_test_busy = 0
    has_test_suspend = 0
    has_call = 0
    has_branch_gate = 0
    has_rts = 0
}

function trim(s, t) {
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
    uline = toupper(line)

    if (uline ~ /^ESQDISP_PROCESSGRIDMESSAGESIFIDLE:/) has_entry = 1
    if (uline ~ /TST\.W ESQDISP_GRIDMESSAGEPUMPBLOCKFLAG/) has_test_block = 1
    if (uline ~ /TST\.W GLOBAL_UIBUSYFLAG/) has_test_busy = 1
    if (uline ~ /TST\.L NEWGRID_MESSAGEPUMPSUSPENDFLAG/) has_test_suspend = 1
    if (uline ~ /ESQDISP_JMPTBL_NEWGRID_PROCESSGRIDMESSAGES/) has_call = 1
    if (uline ~ /BNE(\.[A-Z]+)? \.LAB_08C3/) has_branch_gate = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEST_BLOCK=" has_test_block
    print "HAS_TEST_BUSY=" has_test_busy
    print "HAS_TEST_SUSPEND=" has_test_suspend
    print "HAS_CALL=" has_call
    print "HAS_BRANCH_GATE=" has_branch_gate
    print "HAS_RTS=" has_rts
}
