BEGIN {
    has_label = 0
    has_save = 0
    has_arg = 0
    has_null_guard = 0
    has_free_sub_call = 0
    has_clear_call = 0
    has_dealloc_call = 0
    has_clear_ptr = 0
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

    if (uline ~ /^COI_FREEENTRYRESOURCES:/) has_label = 1
    if (index(uline, "MOVEM.L A2-A3,-(A7)") > 0) has_save = 1
    if (index(uline, "MOVEA.L 12(A7),A3") > 0) has_arg = 1
    if (index(uline, "COI_FREEENTRYRESOURCES_RETURN") > 0) has_null_guard = 1
    if (index(uline, "BSR.W COI_FREESUBENTRYTABLEENTRIES") > 0) has_free_sub_call = 1
    if (index(uline, "BSR.W COI_CLEARANIMOBJECTSTRINGS") > 0) has_clear_call = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0) has_dealloc_call = 1
    if (index(uline, "CLR.L 48(A3)") > 0) has_clear_ptr = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_ARG=" has_arg
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_FREE_SUB_CALL=" has_free_sub_call
    print "HAS_CLEAR_CALL=" has_clear_call
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_CLEAR_PTR=" has_clear_ptr
}
