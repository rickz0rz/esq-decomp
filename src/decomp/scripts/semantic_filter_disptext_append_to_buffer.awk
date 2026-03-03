BEGIN {
    has_label=0; has_link=0; has_save=0; has_alloc_path=0; has_append=0; has_replace=0; has_boolize=0; has_return=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0); if(line=="") next; gsub(/[ \t]+/," ",line); u=toupper(line)
    if (u ~ /^DISPTEXT_APPENDTOBUFFER:/) has_label=1
    if (index(u,"LINK.W A5,#-8")>0) has_link=1
    if (index(u,"MOVEM.L D7/A3,-(A7)")>0) has_save=1
    if (index(u,"LV0AVAILMEM(A6)")>0 || index(u,"LVOAVAILMEM(A6)")>0 || index(u,"GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY")>0) has_alloc_path=1
    if (index(u,"GROUP_AI_JMPTBL_STRING_APPENDATNULL")>0) has_append=1
    if (index(u,"GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING")>0) has_replace=1
    if (index(u,"SNE D0")>0 && index(u,"NEG.B D0")>0 && index(u,"EXT.L D0")>0) has_boolize=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_LABEL="has_label
    print "HAS_LINK="has_link
    print "HAS_SAVE="has_save
    print "HAS_ALLOC_PATH="has_alloc_path
    print "HAS_APPEND="has_append
    print "HAS_REPLACE="has_replace
    print "HAS_BOOLIZE="has_boolize
    print "HAS_RETURN="has_return
}
