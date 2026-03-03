BEGIN {
    has_label = 0
    has_link = 0
    has_guard = 0
    has_loop = 0
    has_replace_call = 0
    has_dealloc_array = 0
    has_dealloc_mem = 0
    has_clear_fields = 0
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

    if (uline ~ /^COI_FREESUBENTRYTABLEENTRIES:/) has_label = 1
    if (index(uline, "LINK.W A5,#-12") > 0) has_link = 1
    if (index(uline, "COI_FREESUBENTRYTABLEENTRIES_RETURN") > 0) has_guard = 1
    if (uline ~ /^\.LAB_02D8:/) has_loop = 1
    if (index(uline, "GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_SCRIPT_DEALLOCATEBUFFERARRAY") > 0) has_dealloc_array = 1
    if (index(uline, "GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0) has_dealloc_mem = 1
    if (index(uline, "CLR.W 36(A3)") > 0) has_clear_fields = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_GUARD=" has_guard
    print "HAS_LOOP=" has_loop
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_DEALLOC_ARRAY=" has_dealloc_array
    print "HAS_DEALLOC_MEM=" has_dealloc_mem
    print "HAS_CLEAR_FIELDS=" has_clear_fields
}
