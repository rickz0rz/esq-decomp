BEGIN {
    has_label = 0
    has_link = 0
    has_null_guard = 0
    has_alloc_call = 0
    has_replace_call = 0
    has_store_ptr = 0
    has_set_minus1 = 0
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

    if (uline ~ /^COI_ENSUREANIMOBJECTALLOCATED:/) has_label = 1
    if (index(uline, "LINK.W A5,#-8") > 0) has_link = 1
    if (index(uline, "BEQ.S .RETURN") > 0) has_null_guard = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0) has_alloc_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_call = 1
    if (index(uline, "MOVE.L D0,48(A3)") > 0) has_store_ptr = 1
    if (index(uline, "MOVEQ #-1,D0") > 0) has_set_minus1 = 1
    if (index(uline, "RTS") == 1) has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_STORE_PTR=" has_store_ptr
    print "HAS_SET_MINUS1=" has_set_minus1
    print "HAS_RETURN=" has_return
}
