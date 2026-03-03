BEGIN {
    has_label=0; has_reset=0; has_test1=0; has_free1=0; has_clear1=0; has_test2=0; has_free2=0; has_clear2=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_FREEBUFFERS:/) has_label=1
    if (index(u,"BSR.W DISPLIB_RESETTEXTBUFFERANDLINETABLES")>0) has_reset=1
    if (index(u,"TST.L GLOBAL_REF_1000_BYTES_ALLOCATED_1")>0) has_test1=1
    if (index(u,"GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY")>0 && index(u,"PEA 338.W")>0) has_free1=1
    if (index(u,"CLR.L GLOBAL_REF_1000_BYTES_ALLOCATED_1")>0) has_clear1=1
    if (index(u,"TST.L GLOBAL_REF_1000_BYTES_ALLOCATED_2")>0) has_test2=1
    if (index(u,"GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY")>0 && index(u,"PEA 343.W")>0) has_free2=1
    if (index(u,"CLR.L GLOBAL_REF_1000_BYTES_ALLOCATED_2")>0) has_clear2=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_RESET="has_reset
    print "HAS_TEST1="has_test1
    print "HAS_FREE1="has_free1
    print "HAS_CLEAR1="has_clear1
    print "HAS_TEST2="has_test2
    print "HAS_FREE2="has_free2
    print "HAS_CLEAR2="has_clear2
    print "HAS_RETURN="has_return
}
