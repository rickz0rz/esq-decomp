BEGIN {h_entry=0; h_guard_ptr=0; h_guard_size=0; h_a1=0; h_d0=0; h_call=0; h_sub=0; h_cnt=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
    l=t($0)
    if(l=="") next
    if(l~/^MEMORY_DEALLOCATEMEMORY:/) h_entry=1
    if(l~/^(MOVE\.L A[35],D0|MOVEA?\.L .*A3.*D0)$/) h_guard_ptr=1
    if(l~/^TST\.L D7$/) h_guard_size=1
    if(l~/^(MOVEA?\.L A[35],A1|MOVE\.L A[35],A1)$/) h_a1=1
    if(l~/^MOVE\.L D7,D0$/) h_d0=1
    if(l~/^JSR (_LVOFREEMEM\(A6\)|\$FFFFFF2E\(A6\))$/) h_call=1
    if(l~/^SUB\.L D7,GLOBAL_MEM_BYTES_ALLOCATED(\(A4\))?$/) h_sub=1
    if(l~/^ADDQ\.L #\$?1,GLOBAL_MEM_DEALLOC_COUNT(\(A4\))?$/) h_cnt=1
    if(l~/^RTS$/) h_rts=1
}
END {
    print "HAS_ENTRY=" h_entry
    print "HAS_PTR_GUARD=" h_guard_ptr
    print "HAS_SIZE_GUARD=" h_guard_size
    print "HAS_ARG_A1=" h_a1
    print "HAS_ARG_D0=" h_d0
    print "HAS_FREE_CALL=" h_call
    print "HAS_SUB_BYTES=" h_sub
    print "HAS_ADD_COUNT=" h_cnt
    print "HAS_RTS=" h_rts
}
