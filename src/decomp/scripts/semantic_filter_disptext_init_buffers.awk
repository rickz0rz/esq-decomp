BEGIN {
    has_label=0; has_flag_test=0; has_reset=0; has_alloc1=0; has_alloc2=0; has_store1=0; has_store2=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_INITBUFFERS:/) has_label=1
    if (index(u,"TST.L DISPTEXT_INITBUFFERSPENDING")>0) has_flag_test=1
    if (index(u,"BSR.W DISPLIB_RESETLINETABLES")>0) has_reset=1
    if (index(u,"PEA 320.W")>0 && index(u,"GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY")>0) has_alloc1=1
    if (index(u,"PEA 321.W")>0 && index(u,"GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY")>0) has_alloc2=1
    if (index(u,"MOVE.L D0,GLOBAL_REF_1000_BYTES_ALLOCATED_1")>0) has_store1=1
    if (index(u,"MOVE.L D0,GLOBAL_REF_1000_BYTES_ALLOCATED_2")>0) has_store2=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_FLAG_TEST="has_flag_test
    print "HAS_RESET="has_reset
    print "HAS_ALLOC1="has_alloc1
    print "HAS_ALLOC2="has_alloc2
    print "HAS_STORE1="has_store1
    print "HAS_STORE2="has_store2
    print "HAS_RETURN="has_return
}
