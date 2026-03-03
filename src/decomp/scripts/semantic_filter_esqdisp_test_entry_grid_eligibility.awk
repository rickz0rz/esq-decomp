BEGIN {
    has_label=0; has_save=0; has_range=0; has_null=0; has_btst=0; has_bounds=0
    has_truefalse=0; has_return_label=0; has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^ESQDISP_TESTENTRYGRIDELIGIBILITY:/) has_label=1
    if (index(u,"MOVEM.L D6-D7/A3,-(A7)")>0 || index(u,"MOVEM.L D6/D7/A3,-(A7)")>0) has_save=1
    if (index(u,"TST.W D7")>0 && index(u,"MOVEQ #49,D0")>0 && index(u,"CMP.W D0,D7")>0) has_range=1
    if (index(u,"MOVE.L A3,D0")>0 && index(u,"BEQ.S ESQDISP_TESTENTRYGRIDELIGIBILITY_RETURN")>0) has_null=1
    if (index(u,"BTST #4,7(A3,D7.W)")>0) has_btst=1
    if (index(u,"CMPI.B #$5,0(A3,D0.W)")>0 && index(u,"CMPI.B #$A,0(A3,D0.W)")>0) has_bounds=1
    if (index(u,"MOVEQ #0,D0")>0 && index(u,"MOVEQ #1,D0")>0) has_truefalse=1
    if (u ~ /^ESQDISP_TESTENTRYGRIDELIGIBILITY_RETURN:/) has_return_label=1
    if (index(u,"MOVEM.L (A7)+,D6-D7/A3")>0 || index(u,"MOVEM.L (A7)+,D6/D7/A3")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_SAVE="has_save
    print "HAS_RANGE="has_range
    print "HAS_NULL="has_null
    print "HAS_BTST="has_btst
    print "HAS_BOUNDS="has_bounds
    print "HAS_TRUEFALSE="has_truefalse
    print "HAS_RETURN_LABEL="has_return_label
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
