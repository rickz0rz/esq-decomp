BEGIN {h_entry=0; h_call=0; h_addbytes=0; h_addcnt=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^MEMORY_ALLOCATEMEMORY:/ || l~/^MEMORY_ALLOCATEMEMOR[A-Z0-9_]*:/) h_entry=1
    if(l~/^JSR (_LVOALLOCMEM\(A6\)|\$FFFFFF3A\(A6\))$/ || l~/_LVOALLOCMEM/) h_call=1
    if(l~/^ADD\.L D7,GLOBAL_MEM_BYTES_ALLOCATED(\(A4\))?$/ || l~/GLOBAL_MEM_BYTES_ALLOCATED/) h_addbytes=1
    if(l~/^ADDQ\.L #\$?1,GLOBAL_MEM_ALLOC_COUNT(\(A4\))?$/ || l~/GLOBAL_MEM_ALLOC_COUNT/) h_addcnt=1
    if(l~/MOVE\.L D0,D[0-7]/ || l~/MOVE\.L D[0-7],D0/ || l~/MOVE\.L .*D0$/) h_ret=1
    if(l~/^RTS$/) h_rts=1
}
END {
    print "HAS_ENTRY=" h_entry
    print "HAS_ALLOC_CALL=" h_call
    print "HAS_ADD_BYTES=" h_addbytes
    print "HAS_ADD_COUNT=" h_addcnt
    print "HAS_RETURN_VALUE=" h_ret
    print "HAS_RTS=" h_rts
}
