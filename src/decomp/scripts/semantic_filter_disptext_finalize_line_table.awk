BEGIN {
    has_label=0; has_lock_test=0; has_current_read=0; has_target_store=0; has_len_table=0; has_extra_add=0; has_build=0; has_clear_current=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_FINALIZELINETABLE:/) has_label=1
    if (index(u,"TST.L DISPTEXT_LINETABLELOCKFLAG")>0) has_lock_test=1
    if (index(u,"MOVE.W DISPTEXT_CURRENTLINEINDEX,D0")>0) has_current_read=1
    if (index(u,"MOVE.W D0,DISPTEXT_TARGETLINEINDEX")>0) has_target_store=1
    if (index(u,"LEA DISPTEXT_LINELENGTHTABLE,A0")>0 && index(u,"TST.W (A0)")>0) has_len_table=1
    if (index(u,"ADDQ.W #1,D0")>0) has_extra_add=1
    if (index(u,"BSR.W DISPTEXT_BUILDLINEPOINTERTABLE")>0) has_build=1
    if (index(u,"CLR.W DISPTEXT_CURRENTLINEINDEX")>0) has_clear_current=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LOCK_TEST="has_lock_test
    print "HAS_CURRENT_READ="has_current_read
    print "HAS_TARGET_STORE="has_target_store
    print "HAS_LEN_TABLE="has_len_table
    print "HAS_EXTRA_ADD="has_extra_add
    print "HAS_BUILD="has_build
    print "HAS_CLEAR_CURRENT="has_clear_current
    print "HAS_RETURN="has_return
}
