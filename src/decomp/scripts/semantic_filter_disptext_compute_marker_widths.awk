BEGIN {
    has_label=0; has_link=0; has_save=0; has_marker_call=0; has_prefix1=0; has_prefix2=0; has_textlength=0; has_store=0; has_restore=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_COMPUTEMARKERWIDTHS:/) has_label=1
    if (index(u,"LINK.W A5,#-12")>0) has_link=1
    if (index(u,"MOVEM.L D4-D7/A3,-(A7)")>0) has_save=1
    if (index(u,"GROUP_AI_JMPTBL_NEWGRID_SETSELECTIONMARKERS")>0) has_marker_call=1
    if (index(u,"TST.B -1(A5)")>0) has_prefix1=1
    if (index(u,"TST.B -3(A5)")>0) has_prefix2=1
    if (index(u,"LVOTEXTLENGTH(A6)")>0) has_textlength=1
    if (index(u,"MOVE.L D0,DISPTEXT_CONTROLMARKERWIDTHPX")>0) has_store=1
    if (index(u,"MOVEM.L (A7)+,D4-D7/A3")>0 && index(u,"UNLK A5")>0) has_restore=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_MARKER_CALL="has_marker_call
    print "HAS_PREFIX1="has_prefix1
    print "HAS_PREFIX2="has_prefix2
    print "HAS_TEXTLENGTH="has_textlength
    print "HAS_STORE="has_store
    print "HAS_RESTORE="has_restore
    print "HAS_RETURN="has_return
}
