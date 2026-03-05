BEGIN {
    has_label = 0
    has_load_call = 0
    has_token_call = 0
    has_replace_call = 0
    has_alloc_call = 0
    has_wildcard_call = 0
    has_cleanup = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^COI_LOADOIDATAFILE[A-Z0-9_]*:/) has_label = 1
    if (u ~ /DISKIO_LOADFILETOWORKBUFFER/ || u ~ /DISKIO_LOADFILETOWORKBUFF/) has_load_call = 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEX/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKE/) has_token_call = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/) has_replace_call = 1
    if (u ~ /COI_ALLOCSUBENTRYTABLE/) has_alloc_call = 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) has_wildcard_call = 1
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_cleanup = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_LOAD_CALL=" has_load_call
    print "HAS_TOKEN_CALL=" has_token_call
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_CLEANUP=" has_cleanup
    print "HAS_RETURN=" has_return
}
