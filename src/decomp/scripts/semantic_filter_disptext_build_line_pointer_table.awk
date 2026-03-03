BEGIN {
    has_label=0; has_save=0; has_lock_test=0; has_init_ptr=0; has_len_probe=0; has_loop=0; has_store_ptr=0; has_set_lock=0; has_restore=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_BUILDLINEPOINTERTABLE:/) has_label=1
    if (index(u,"MOVEM.L D5-D7/A2-A3,-(A7)")>0) has_save=1
    if (index(u,"TST.L DISPTEXT_LINETABLELOCKFLAG")>0) has_lock_test=1
    if (index(u,"MOVE.L DISPTEXT_TEXTBUFFERPTR,DISPTEXT_LINEPTRTABLE")>0) has_init_ptr=1
    if (index(u,"LEA DISPTEXT_LINELENGTHTABLE,A0")>0 && index(u,"TST.W (A0)")>0) has_len_probe=1
    if (index(u,"DISPTEXT_BUILDLINEPOINTERTABLE_BUILD_PTRS_LOOP")>0 || index(u,"CMP.L D5,D6")>0) has_loop=1
    if (index(u,"MOVE.L A3,(A0)")>0) has_store_ptr=1
    if (index(u,"MOVE.L D7,DISPTEXT_LINETABLELOCKFLAG")>0) has_set_lock=1
    if (index(u,"MOVEM.L (A7)+,D5-D7/A2-A3")>0) has_restore=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_SAVE="has_save
    print "HAS_LOCK_TEST="has_lock_test
    print "HAS_INIT_PTR="has_init_ptr
    print "HAS_LEN_PROBE="has_len_probe
    print "HAS_LOOP="has_loop
    print "HAS_STORE_PTR="has_store_ptr
    print "HAS_SET_LOCK="has_set_lock
    print "HAS_RESTORE="has_restore
    print "HAS_RETURN="has_return
}
