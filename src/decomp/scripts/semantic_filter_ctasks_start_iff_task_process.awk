BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_wait_call = 0
    has_find = 0
    has_loop_branch = 0
    has_clear_done = 0
    has_state4 = 0
    has_state5 = 0
    has_alloc_call = 0
    has_cleanup_install = 0
    has_create_proc = 0
    has_store_proc = 0
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

    if (uline ~ /^CTASKS_STARTIFFTASKPROCESS:/) has_label = 1
    if (index(uline, "LINK.W A5,#-4") > 0) has_link = 1
    if (index(uline, "MOVEM.L D2-D4,-(A7)") > 0) has_save = 1
    if (index(uline, "LVOFORBID(A6)") > 0 && index(uline, "JSR") > 0) has_wait_call = 1
    if (index(uline, "LVOFINDTASK(A6)") > 0 && index(uline, "JSR") > 0) has_find = 1
    if (index(uline, "BNE.S") > 0 && index(uline, "WAIT_FOR_PRIOR_IFF_TASK") > 0) has_loop_branch = 1
    if (index(uline, "MOVE.W D0,CTASKS_IFFTASKDONEFLAG") > 0) has_clear_done = 1
    if (index(uline, "MOVE.W #4,CTASKS_IFFTASKSTATE") > 0) has_state4 = 1
    if (index(uline, "MOVE.W #5,CTASKS_IFFTASKSTATE") > 0) has_state5 = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0) has_alloc_call = 1
    if (index(uline, "MOVE.L A0,10(A1)") > 0) has_cleanup_install = 1
    if (index(uline, "LVOCREATEPROC(A6)") > 0) has_create_proc = 1
    if (index(uline, "MOVE.L D0,CTASKS_IFFTASKPROCPTR") > 0) has_store_proc = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_WAIT_CALL=" has_wait_call
    print "HAS_FIND=" has_find
    print "HAS_LOOP_BRANCH=" has_loop_branch
    print "HAS_CLEAR_DONE=" has_clear_done
    print "HAS_STATE4=" has_state4
    print "HAS_STATE5=" has_state5
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_CLEANUP_INSTALL=" has_cleanup_install
    print "HAS_CREATE_PROC=" has_create_proc
    print "HAS_STORE_PROC=" has_store_proc
    print "HAS_RETURN=" has_return
}
