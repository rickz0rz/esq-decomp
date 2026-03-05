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
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0); if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    if (u ~ /^COI_ENSUREANIMOBJECTALLOCATED:/) has_label = 1
    if (u ~ /LINK.W A5,#-8/ || u ~ /SUBQ.W #\$8,A7/ || u ~ /MOVEM.L .*A5/) has_link = 1
    if (u ~ /BEQ.S .RETURN/ || u ~ /BEQ.B/ || u ~ /BEQ.W/) has_null_guard = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc_call = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTR/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/) has_replace_call = 1
    if (u ~ /MOVE.L D0,48\(A3\)/ || u ~ /MOVE.L D0,\$30\(A[0-7]\)/ || u ~ /LEA \$30\(A[0-7]\),A0/ || u ~ /MOVE.L A2,\(A0\)/) has_store_ptr = 1
    if (u ~ /MOVEQ #-1,D0/ || u ~ /MOVEQ.L #\$FF,D0/ || u ~ /MOVE.L #\$FFFFFFFF/) has_set_minus1 = 1
    if (u == "RTS") has_return = 1
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
