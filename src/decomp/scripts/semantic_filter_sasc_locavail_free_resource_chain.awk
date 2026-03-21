function toupper_line(s, out) {
    out = toupper(s)
    sub(/;.*/, "", out)
    gsub(/^[ \t]+|[ \t]+$/, "", out)
    gsub(/[ \t]+/, " ", out)
    return out
}

{
    line = toupper_line($0)
    if (line == "") {
        next
    }

    if (line ~ /^LOCAVAIL_FREERESOURCECHAIN:/ || line ~ /^LOCAVAIL_FREERESOURCECHAIN[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /^BEQ\.[BWS]? / || line ~ /^BEQ\.W /) has_null_guard = 1
    if (line ~ /^SUBQ\.L #(\$1|1),\(A[02]\)$/ || line ~ /^SUBQ\.L #(\$1|1),\(A0\)$/) has_ref_decrement = 1
    if (line ~ /GLOBAL_STR_LOCAVAIL_C_2/ && line ~ /NEWGRID_JMPTBL_MEMORY_DEALLOCATE/) has_shared_ref_free = 1
    if (line ~ /LOCAVAIL_FREENODEATPOINTER/) has_node_free_call = 1
    if (line ~ /GROUP_AY_JMPTBL_MATH_MULU32/) has_node_array_size_call = 1
    if (line ~ /GLOBAL_STR_LOCAVAIL_C_3/ && line ~ /NEWGRID_JMPTBL_MEMORY_DEALLOCATE/) has_node_array_free = 1
    if (line ~ /LOCAVAIL_RESETFILTERSTATESTRUCT/) has_reset_call = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_REF_DECREMENT=" has_ref_decrement
    print "HAS_SHARED_REF_FREE=" has_shared_ref_free
    print "HAS_NODE_FREE_CALL=" has_node_free_call
    print "HAS_NODE_ARRAY_SIZE_CALL=" has_node_array_size_call
    print "HAS_NODE_ARRAY_FREE=" has_node_array_free
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_RETURN=" has_return
}
