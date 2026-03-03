BEGIN {
    has_label = 0
    has_save = 0
    has_load_arg = 0
    has_lock_test = 0
    has_min_check = 0
    has_max_check = 0
    has_commit = 0
    has_stack_fix = 0
    has_restore = 0
    has_return = 0
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

    if (uline ~ /^DISPTEXT_SETCURRENTLINEINDEX:/) has_label = 1
    if (index(uline, "MOVE.L D7,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVE.L 8(A7),D7") > 0) has_load_arg = 1
    if (index(uline, "TST.L DISPTEXT_LINETABLELOCKFLAG") > 0) has_lock_test = 1
    if (index(uline, "CMP.L D0,D7") > 0 && index(uline, "MOVEQ #1,D0") > 0) has_min_check = 1
    if (index(uline, "CMP.L D0,D7") > 0 && index(uline, "MOVEQ #3,D0") > 0) has_max_check = 1
    if (index(uline, "BSR.W DISPLIB_COMMITCURRENTLINEPENANDADVANCE") > 0) has_commit = 1
    if (index(uline, "ADDQ.W #4,A7") > 0) has_stack_fix = 1
    if (index(uline, "MOVE.L (A7)+,D7") > 0) has_restore = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_LOAD_ARG=" has_load_arg
    print "HAS_LOCK_TEST=" has_lock_test
    print "HAS_MIN_CHECK=" has_min_check
    print "HAS_MAX_CHECK=" has_max_check
    print "HAS_COMMIT=" has_commit
    print "HAS_STACK_FIX=" has_stack_fix
    print "HAS_RESTORE=" has_restore
    print "HAS_RETURN=" has_return
}
