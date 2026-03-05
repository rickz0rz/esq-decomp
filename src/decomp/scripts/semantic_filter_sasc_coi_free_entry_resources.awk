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
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0); if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    if (u ~ /^COI_FREEENTRYRESOURCES:/) has_label = 1
    if (u ~ /MOVEM.L A2-A3,-\(A7\)/ || u ~ /MOVEM.L A2\/A3,-\(A7\)/ || u ~ /MOVEM.L A2\/A3\/A5,-\(A7\)/) has_save = 1
    if (u ~ /MOVEA.L \$?C\(A7\),A[35]/ || u ~ /MOVEA.L 12\(A7\),A[35]/ || u ~ /MOVE.L \$10\(A7\),A5/) has_arg = 1
    if (u ~ /COI_FREEENTRYRESOURCES_RETURN/ || u ~ /BEQ/) has_null_guard = 1
    if (u ~ /COI_FREESUBENTRYTABLEENTRIES/ || u ~ /COI_FREESUBENTRYTABLEENTR/) has_free_sub_call = 1
    if (u ~ /COI_CLEARANIMOBJECTSTRINGS/ || u ~ /COI_CLEARANIMOBJECTSTRIN/) has_clear_call = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc_call = 1
    if (u ~ /CLR.L 48\(A3\)/ || u ~ /CLR.L \$30\(A[35]\)/ || u ~ /LEA \$30\(A[35]\),A0/ || (u ~ /MOVE.L #\$0/ && u ~ /\$30\(A[35]\)/)) has_clear_ptr = 1
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
