BEGIN {
    has_label = 0
    has_link = 0
    has_load_call = 0
    has_token_call = 0
    has_replace_call = 0
    has_alloc_call = 0
    has_wildcard_call = 0
    has_cleanup = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^COI_LOADOIDATAFILE:/) has_label = 1
    if (index(uline, "LINK.W A5,#-648") > 0) has_link = 1
    if (index(uline, "DISKIO_LOADFILETOWORKBUFFER") > 0) has_load_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP") > 0) has_token_call = 1
    if (index(uline, "GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_call = 1
    if (index(uline, "COI_ALLOCSUBENTRYTABLE") > 0) has_alloc_call = 1
    if (index(uline, "ESQ_WILDCARDMATCH") > 0) has_wildcard_call = 1
    if (index(uline, ".CLEANUP_AND_RETURN:") > 0) has_cleanup = 1
    if (uline == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_LOAD_CALL=" has_load_call
    print "HAS_TOKEN_CALL=" has_token_call
    print "HAS_REPLACE_CALL=" has_replace_call
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_WILDCARD_CALL=" has_wildcard_call
    print "HAS_CLEANUP=" has_cleanup
    print "HAS_RETURN=" has_return
}
