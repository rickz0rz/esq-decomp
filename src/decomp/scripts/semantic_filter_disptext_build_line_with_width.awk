BEGIN {
    has_label=0; has_link=0; has_save=0; has_textlen=0; has_skip=0; has_copy=0; has_append=0; has_prefix_logic=0; has_shrink=0; has_status_bool=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_BUILDLINEWITHWIDTH:/) has_label=1
    if (index(u,"LINK.W A5,#-76")>0) has_link=1
    if (index(u,"MOVEM.L D2-D7/A2-A3,-(A7)")>0) has_save=1
    if (index(u,"LVOTEXTLENGTH(A6)")>0) has_textlen=1
    if (index(u,"GROUP_AI_JMPTBL_STR_SKIPCLASS3CHARS")>0) has_skip=1
    if (index(u,"GROUP_AI_JMPTBL_STR_COPYUNTILANYDELIMN")>0) has_copy=1
    if (index(u,"GROUP_AI_JMPTBL_STRING_APPENDATNULL")>0) has_append=1
    if (index(u,"DISPTEXT_CONTROLMARKERSENABLEDFLAG")>0) has_prefix_logic=1
    if (index(u,"DISPTEXT_BUILDLINEWITHWIDTH_SHRINK_WORD")>0 || index(u,"SUBQ.L #1,D6")>0) has_shrink=1
    if (index(u,"SEQ D0")>0 && index(u,"NEG.B D0")>0 && index(u,"EXT.L D0")>0) has_status_bool=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_TEXTLENGTH="has_textlen
    print "HAS_SKIP="has_skip
    print "HAS_COPY="has_copy
    print "HAS_APPEND="has_append
    print "HAS_PREFIX_LOGIC="has_prefix_logic
    print "HAS_SHRINK="has_shrink
    print "HAS_STATUS_BOOL="has_status_bool
    print "HAS_RETURN="has_return
}
