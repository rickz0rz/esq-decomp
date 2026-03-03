BEGIN {
    has_label=0; has_core=0; has_save=0; has_null_guard=0; has_btst0=0; has_btst2=0
    has_true=0; has_false=0; has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^ESQDISP_TESTENTRYBITS0AND2:/) has_label=1
    if (u ~ /^ESQDISP_TESTENTRYBITS0AND2_CORE:/) has_core=1
    if (index(u,"MOVEM.L D7/A3,-(A7)")>0 || index(u,"MOVEM.L D7/A3,-(SP)")>0) has_save=1
    if (index(u,"MOVE.L A3,D0")>0 && index(u,"BEQ.S ESQDISP_TESTENTRYBITS0AND2_RETURN")>0) has_null_guard=1
    if (index(u,"BTST #0,40(A3)")>0) has_btst0=1
    if (index(u,"BTST #2,40(A3)")>0) has_btst2=1
    if (index(u,"MOVEQ #1,D0")>0) has_true=1
    if (index(u,"MOVEQ #0,D0")>0) has_false=1
    if (index(u,"MOVEM.L (A7)+,D7/A3")>0 || index(u,"MOVEM.L (SP)+,D7/A3")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_CORE="has_core
    print "HAS_SAVE="has_save
    print "HAS_NULL_GUARD="has_null_guard
    print "HAS_BTST0="has_btst0
    print "HAS_BTST2="has_btst2
    print "HAS_TRUE="has_true
    print "HAS_FALSE="has_false
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
