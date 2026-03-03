BEGIN {
    has_label=0; has_link=0; has_save=0; has_lock_test=0; has_format=0; has_layout=0; has_status=0; has_restore=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_BUILDLAYOUTFORSOURCE:/) has_label=1
    if (index(u,"LINK.W A5,#-8")>0) has_link=1
    if (index(u,"MOVEM.L D7/A3,-(A7)")>0) has_save=1
    if (index(u,"TST.L DISPTEXT_LINETABLELOCKFLAG")>0) has_lock_test=1
    if (index(u,"GROUP_AI_JMPTBL_FORMAT_FORMATTOBUFFER2")>0) has_format=1
    if (index(u,"BSR.W DISPTEXT_LAYOUTANDAPPENDTOBUFFER")>0) has_layout=1
    if (index(u,"MOVE.L D0,D7")>0 && index(u,"MOVE.L D7,D0")>0) has_status=1
    if (index(u,"MOVEM.L (A7)+,D7/A3")>0) has_restore=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_LOCK_TEST="has_lock_test
    print "HAS_FORMAT="has_format
    print "HAS_LAYOUT="has_layout
    print "HAS_STATUS="has_status
    print "HAS_RESTORE="has_restore
    print "HAS_RETURN="has_return
}
