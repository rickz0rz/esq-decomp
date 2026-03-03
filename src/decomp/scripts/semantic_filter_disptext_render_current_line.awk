BEGIN {
    has_label=0; has_link=0; has_save=0; has_finalize=0; has_width_guard=0
    has_index_guard=0; has_lineptr_guard=0; has_len_guard=0; has_setapen=0; has_setdrmd=0
    has_marker_find=0; has_inset_draw=0; has_plain_draw=0; has_restore=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_RENDERCURRENTLINE:/) has_label=1
    if (index(u,"LINK.W A5,#-12")>0) has_link=1
    if (index(u,"MOVEM.L D2-D7/A3,-(A7)")>0 || index(u,"MOVEM.L D2/D3/D4/D5/D6/D7/A3,-(A7)")>0) has_save=1
    if (index(u,"BSR.W DISPTEXT_FINALIZELINETABLE")>0) has_finalize=1
    if (index(u,"DISPTEXT_LINEWIDTHPX")>0 && index(u,"BLE.W DISPTEXT_RENDERCURRENTLINE_RETURN")>0) has_width_guard=1
    if (index(u,"CMP.W D2,D1")>0 && index(u,"DISPTEXT_TARGETLINEINDEX")>0) has_index_guard=1
    if (index(u,"DISPTEXT_LINEPTRTABLE")>0 && index(u,"TST.L (A1)")>0) has_lineptr_guard=1
    if (index(u,"DISPTEXT_LINELENGTHTABLE")>0 && index(u,"TST.L D4")>0) has_len_guard=1
    if (index(u,"_LVOSETAPEN(A6)")>0) has_setapen=1
    if (index(u,"_LVOSETDRMD(A6)")>0) has_setdrmd=1
    if (index(u,"GROUP_AI_JMPTBL_STR_FINDCHARPTR(PC)")>0) has_marker_find=1
    if (index(u,"GROUP_AI_JMPTBL_TLIBA1_DRAWTEXTWITHINSETSEGMENTS(PC)")>0) has_inset_draw=1
    if (index(u,"_LVOMOVE(A6)")>0 && index(u,"_LVOTEXT(A6)")>0) has_plain_draw=1
    if (index(u,"MOVEM.L (A7)+,D2-D7/A3")>0 || index(u,"MOVEM.L (A7)+,D2/D3/D4/D5/D6/D7/A3")>0) has_restore=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_FINALIZE="has_finalize
    print "HAS_WIDTH_GUARD="has_width_guard
    print "HAS_INDEX_GUARD="has_index_guard
    print "HAS_LINEPTR_GUARD="has_lineptr_guard
    print "HAS_LEN_GUARD="has_len_guard
    print "HAS_SETAPEN="has_setapen
    print "HAS_SETDRMD="has_setdrmd
    print "HAS_MARKER_FIND="has_marker_find
    print "HAS_INSET_DRAW="has_inset_draw
    print "HAS_PLAIN_DRAW="has_plain_draw
    print "HAS_RESTORE="has_restore
    print "HAS_RETURN="has_return
}
