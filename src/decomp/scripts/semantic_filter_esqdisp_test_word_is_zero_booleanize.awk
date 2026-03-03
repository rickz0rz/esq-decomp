BEGIN {
    has_label=0; has_load=0; has_tst=0; has_bool=0; has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^ESQDISP_TESTWORDISZEROBOOLEANIZE:/) has_label=1
    if (index(u,"MOVE.W 10(A7),D7")>0) has_load=1
    if (index(u,"TST.W D7")>0) has_tst=1
    if (index(u,"SEQ D0")>0 && index(u,"NEG.B D0")>0 && index(u,"EXT.L D0")>0) has_bool=1
    if (index(u,"MOVE.L (A7)+,D7")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LOAD="has_load
    print "HAS_TST="has_tst
    print "HAS_BOOL="has_bool
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
