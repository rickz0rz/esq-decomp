BEGIN {
    has_label=0; has_save=0; has_reset=0; has_width_range=0; has_width_store=0; has_line_range=0; has_line_store=0; has_commit=0; has_match_check=0; has_true=0; has_false=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_SETLAYOUTPARAMS:/) has_label=1
    if (index(u,"MOVEM.L D5-D7,-(A7)")>0) has_save=1
    if (index(u,"BSR.W DISPLIB_RESETTEXTBUFFERANDLINETABLES")>0) has_reset=1
    if (index(u,"CMPI.L #624,D7")>0) has_width_range=1
    if (index(u,"MOVE.L D7,DISPTEXT_LINEWIDTHPX")>0) has_width_store=1
    if (index(u,"MOVEQ #20,D0")>0 && index(u,"CMP.L D0,D6")>0) has_line_range=1
    if (index(u,"MOVE.W D0,DISPTEXT_TARGETLINEINDEX")>0) has_line_store=1
    if (index(u,"BSR.W DISPLIB_COMMITCURRENTLINEPENANDADVANCE")>0) has_commit=1
    if (index(u,"MOVE.L DISPTEXT_LINEWIDTHPX,D0")>0 && index(u,"MOVE.W DISPTEXT_TARGETLINEINDEX,D0")>0) has_match_check=1
    if (index(u,"MOVEQ #1,D0")>0) has_true=1
    if (index(u,"MOVEQ #0,D0")>0) has_false=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_SAVE="has_save
    print "HAS_RESET="has_reset
    print "HAS_WIDTH_RANGE="has_width_range
    print "HAS_WIDTH_STORE="has_width_store
    print "HAS_LINE_RANGE="has_line_range
    print "HAS_LINE_STORE="has_line_store
    print "HAS_COMMIT="has_commit
    print "HAS_MATCH_CHECK="has_match_check
    print "HAS_TRUE="has_true
    print "HAS_FALSE="has_false
    print "HAS_RETURN="has_return
}
