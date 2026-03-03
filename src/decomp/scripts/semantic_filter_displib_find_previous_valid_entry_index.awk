BEGIN {
    has_label=0; has_save=0; has_btst=0; has_step=0; has_table_probe=0
    has_wrap_clear=0; has_wrap_set=0; has_return_label=0; has_restore=0; has_rts=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPLIB_FINDPREVIOUSVALIDENTRYINDEX:/) has_label=1
    if (index(u,"MOVEM.L D5-D7/A2-A3,-(A7)")>0 || index(u,"MOVEM.L D5/D6/D7/A2/A3,-(A7)")>0) has_save=1
    if (index(u,"BTST #5,27(A3)")>0) has_btst=1
    if (index(u,"MOVEQ #48,D5")>0 && index(u,"MOVEQ #7,D5")>0) has_step=1
    if (index(u,"TST.L 56(A2,D0.L)")>0) has_table_probe=1
    if (index(u,"CLR.W DISPLIB_PREVIOUSSEARCHWRAPPEDFLAG")>0) has_wrap_clear=1
    if (index(u,"MOVE.W #1,DISPLIB_PREVIOUSSEARCHWRAPPEDFLAG")>0) has_wrap_set=1
    if (u ~ /^DISPLIB_FINDPREVIOUSVALIDENTRYINDEX_RETURN:/) has_return_label=1
    if (index(u,"MOVEM.L (A7)+,D5-D7/A2-A3")>0 || index(u,"MOVEM.L (A7)+,D5/D6/D7/A2/A3")>0) has_restore=1
    if (u=="RTS") has_rts=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_SAVE="has_save
    print "HAS_BTST="has_btst
    print "HAS_STEP="has_step
    print "HAS_TABLE_PROBE="has_table_probe
    print "HAS_WRAP_CLEAR="has_wrap_clear
    print "HAS_WRAP_SET="has_wrap_set
    print "HAS_RETURN_LABEL="has_return_label
    print "HAS_RESTORE="has_restore
    print "HAS_RTS="has_rts
}
