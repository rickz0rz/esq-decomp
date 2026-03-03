BEGIN {
    has_label=0; has_link=0; has_save=0; has_guard=0; has_textlen=0; has_buildline=0; has_marker_adjust=0; has_status_bool=0; has_restore=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_LAYOUTSOURCETOLINES:/) has_label=1
    if (index(u,"LINK.W A5,#-276")>0) has_link=1
    if (index(u,"MOVEM.L D2/D5-D7/A2-A3,-(A7)")>0) has_save=1
    if (index(u,"TST.L DISPTEXT_LINETABLELOCKFLAG")>0 && index(u,"DISPTEXT_TARGETLINEINDEX")>0) has_guard=1
    if (index(u,"LVOTEXTLENGTH(A6)")>0) has_textlen=1
    if (index(u,"BSR.W DISPTEXT_BUILDLINEWITHWIDTH")>0) has_buildline=1
    if (index(u,"DISPTEXT_CONTROLMARKERWIDTHPX")>0) has_marker_adjust=1
    if (index(u,"SEQ D0")>0 && index(u,"NEG.B D0")>0 && index(u,"EXT.L D0")>0) has_status_bool=1
    if (index(u,"MOVEM.L (A7)+,D2/D5-D7/A2-A3")>0) has_restore=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_GUARD="has_guard
    print "HAS_TEXTLENGTH="has_textlen
    print "HAS_BUILDLINE="has_buildline
    print "HAS_MARKER_ADJUST="has_marker_adjust
    print "HAS_STATUS_BOOL="has_status_bool
    print "HAS_RESTORE="has_restore
    print "HAS_RETURN="has_return
}
