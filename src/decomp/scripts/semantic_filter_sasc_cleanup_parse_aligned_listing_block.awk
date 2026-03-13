BEGIN {
    has_label = 0
    has_slot_init_loop = 0
    has_count_escape = 0
    has_token_map = 0
    has_wildcard = 0
    has_clear_anim = 0
    has_free_subentries = 0
    has_replace_owned = 0
    has_format_tokens = 0
    has_parse_signed = 0
    has_alloc_sub = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_PARSEALIGNEDLISTINGBLOCK[A-Z0-9_]*:/) has_label = 1
    if (u ~ /INIT_SLOT_TABLE_LOOP/ || u ~ /MOVE.W #\(-1\)/ || u ~ /MOVE.W #\$FFFFFFFF/ || u ~ /DBF/) has_slot_init_loop = 1
    if (u ~ /COI_COUNTESCAPE14BEFORENULL/) has_count_escape = 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKE/ || u ~ /SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /SCRIPT_BUILDTOKENIND/) has_token_map = 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) has_wildcard = 1
    if (u ~ /COI_CLEARANIMOBJECTSTRINGS/) has_clear_anim = 1
    if (u ~ /COI_FREESUBENTRYTABLEENTRIES/ || u ~ /COI_FREESUBENTRYTABLENTRIES/) has_free_subentries = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPARS_REPLACEOWNEDSTRING/ || u ~ /ESQPARS_REPLACEOWNEDST/) has_replace_owned = 1
    if (u ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) has_format_tokens = 1
    if (u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLAS/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNED/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_A/ || u ~ /PARSE_READSIGNEDLONGSKIPCL/) has_parse_signed = 1
    if (u ~ /COI_ALLOCSUBENTRYTABLE/) has_alloc_sub = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SLOT_INIT_LOOP=" has_slot_init_loop
    print "HAS_COUNT_ESCAPE=" has_count_escape
    print "HAS_TOKEN_MAP=" has_token_map
    print "HAS_WILDCARD=" has_wildcard
    print "HAS_CLEAR_ANIM=" has_clear_anim
    print "HAS_FREE_SUBENTRIES=" has_free_subentries
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_FORMAT_TOKENS=" has_format_tokens
    print "HAS_PARSE_SIGNED=" has_parse_signed
    print "HAS_ALLOC_SUB=" has_alloc_sub
    print "HAS_RETURN=" has_return
}
