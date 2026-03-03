BEGIN {
    has_label = 0
    has_link = 0
    has_parent_guard = 0
    has_count_guard = 0
    has_alloc_call = 0
    has_store_table = 0
    has_alloc_array_call = 0
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

    if (uline ~ /^COI_ALLOCSUBENTRYTABLE:/) has_label = 1
    if (index(uline, "LINK.W A5,#-4") > 0) has_link = 1
    if (index(uline, "BEQ.S .NULL_PARENT") > 0) has_parent_guard = 1
    if (index(uline, "BLE.S .RETURN_STATUS") > 0) has_count_guard = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0) has_alloc_call = 1
    if (index(uline, "MOVE.L D0,38(A0)") > 0) has_store_table = 1
    if (index(uline, "GROUP_AE_JMPTBL_SCRIPT_ALLOCATEBUFFERARRAY") > 0) has_alloc_array_call = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_PARENT_GUARD=" has_parent_guard
    print "HAS_COUNT_GUARD=" has_count_guard
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_STORE_TABLE=" has_store_table
    print "HAS_ALLOC_ARRAY_CALL=" has_alloc_array_call
    print "HAS_RETURN=" has_return
}
