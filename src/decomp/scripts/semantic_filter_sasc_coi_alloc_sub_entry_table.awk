BEGIN {
    has_label = 0
    has_guard = 0
    has_alloc = 0
    has_store_table = 0
    has_alloc_array = 0
    has_rts = 0
}
function trim(s, t){ t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t }
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_ALLOCSUBENTRYTABLE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /BEQ\.[BWS]? .*RETURN_STATUS/ || u ~ /BEQ\.[BWS]? .*__COI_ALLOCSUBENTRYTABLE/ || u ~ /BLE\.[BWS]?/) has_guard = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/) has_alloc = 1
    if (u ~ /MOVE\.L D0,38\(A0\)/ || u ~ /LEA \$26\(A[0-7]\),A0/ || u ~ /MOVE\.L D[0-7],\(A0\)/) has_store_table = 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_ALLOCATEB/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_ALLOCATEBUFFERARRAY/) has_alloc_array = 1
    if (u == "RTS") has_rts = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GUARD=" has_guard
    print "HAS_ALLOC=" has_alloc
    print "HAS_STORE_TABLE=" has_store_table
    print "HAS_ALLOC_ARRAY=" has_alloc_array
    print "HAS_RTS=" has_rts
}
