BEGIN {
    has_label = 0
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
    u = toupper(line)

    if (u ~ /^COI_FREESUBENTRYTABLEENTRIES[A-Z0-9_]*:/) has_label = 1
    if (u ~ /COI_FREESUBENTRYTABLEENTRIES_RETURN/ || u ~ /BEQ\.[BWS]? .*__COI_FREESUBENTRYTABLEENTRIES/ || u ~ /TST\.L .*\(A5\)/) has_guard = 1
    if (u ~ /CMP\.W 36\(A3\),D7/ || u ~ /CMP\.L D[0-7],D[0-7]/ || u ~ /BRA\.[BWS]? .*__COI_FREESUBENTRYTABLEENTRIES/) has_loop = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_call = 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_DEALLOCATEB/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_DEALLOCATEBUFFERARRAY/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_DEALLOCAT$/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_DEALLOCAT[A-Z0-9_]*/) has_dealloc_array = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEM/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT$/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT[A-Z0-9_]*/) has_dealloc_mem = 1
    if (u ~ /CLR\.W 36\(A3\)/ || u ~ /LEA \$24\(A3\),A0/ || u ~ /CLR\.W \(A0\)/) has_clear_fields = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_LOOP=" has_loop
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_DEALLOC_ARRAY=" has_dealloc_array
    print "HAS_DEALLOC_MEM=" has_dealloc_mem
    print "HAS_CLEAR_FIELDS=" has_clear_fields
}
