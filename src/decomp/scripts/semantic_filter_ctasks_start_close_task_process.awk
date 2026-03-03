BEGIN {
    has_label = 0
    has_save = 0
    has_arg = 0
    has_alloc_call = 0
    has_link_setup = 0
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

    if (uline ~ /^CTASKS_STARTCLOSETASKPROCESS:/) has_label = 1
    if (index(uline, "MOVEM.L D2-D4/D7,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVE.L 20(A7),D7") > 0 || index(uline, "USESTACKLONG MOVE.L,1,D7") > 0) has_arg = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0) has_alloc_call = 1
    if (index(uline, "MOVE.L D0,CTASKS_CLOSETASKSEGLISTBPTR") > 0) has_link_setup = 1
    if (index(uline, "_LVOCREATEPROC(A6)") > 0) has_create_proc = 1
    if (index(uline, "MOVE.L D0,CTASKS_CLOSETASKPROCPTR") > 0) has_store_proc = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_ARG=" has_arg
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_LINK_SETUP=" has_link_setup
    print "HAS_CREATE_PROC=" has_create_proc
    print "HAS_STORE_PROC=" has_store_proc
    print "HAS_RETURN=" has_return
}
