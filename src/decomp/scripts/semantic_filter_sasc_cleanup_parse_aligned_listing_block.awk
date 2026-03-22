BEGIN {
    has_label = 0
    has_slot_init_loop = 0
    count_escape_calls = 0
    token_map_calls = 0
    wildcard_calls = 0
    clear_anim_calls = 0
    free_subentries_calls = 0
    replace_owned_calls = 0
    format_tokens_calls = 0
    parse_signed_calls = 0
    alloc_sub_calls = 0
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
    if (u ~ /COI_COUNTESCAPE14BEFORENULL/) count_escape_calls += 1
    if (u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /GROUP_AE_JMPTBL_SCRIPT_BUILDTOKE/ || u ~ /SCRIPT_BUILDTOKENINDEXMAP/ || u ~ /SCRIPT_BUILDTOKENIND/) token_map_calls += 1
    if (u ~ /ESQ_WILDCARDMATCH/ || u ~ /ESQ_WILDCARDMATC/) wildcard_calls += 1
    if (u ~ /COI_CLEARANIMOBJECTSTRINGS/) clear_anim_calls += 1
    if (u ~ /COI_FREESUBENTRYTABLEENTRIES/ || u ~ /COI_FREESUBENTRYTABLENTRIES/) free_subentries_calls += 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ || u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ || u ~ /ESQPARS_REPLACEOWNEDSTRING/ || u ~ /ESQPARS_REPLACEOWNEDST/) replace_owned_calls += 1
    if (u ~ /CLEANUP_FORMATENTRYSTRINGTOKENS/) format_tokens_calls += 1
    if (u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNEDLONGSKIPCLAS/ || u ~ /GROUP_AG_JMPTBL_PARSE_READSIGNED/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_ALT/ || u ~ /PARSE_READSIGNEDLONGSKIPCLASS3_A/ || u ~ /PARSE_READSIGNEDLONGSKIPCL/) parse_signed_calls += 1
    if (u ~ /COI_ALLOCSUBENTRYTABLE/) alloc_sub_calls += 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_SLOT_INIT_LOOP=" has_slot_init_loop
    print "COUNT_ESCAPE_CALLS_GE1=" (count_escape_calls >= 1)
    print "TOKEN_MAP_CALLS_GE2=" (token_map_calls >= 2)
    print "WILDCARD_CALLS_GE1=" (wildcard_calls >= 1)
    print "CLEAR_ANIM_CALLS_GE1=" (clear_anim_calls >= 1)
    print "FREE_SUBENTRIES_CALLS_GE1=" (free_subentries_calls >= 1)
    print "REPLACE_OWNED_CALLS_GE6=" (replace_owned_calls >= 6)
    print "FORMAT_TOKENS_CALLS_GE1=" (format_tokens_calls >= 1)
    print "PARSE_SIGNED_CALLS_GE1=" (parse_signed_calls >= 1)
    print "ALLOC_SUB_CALLS_GE1=" (alloc_sub_calls >= 1)
    print "HAS_RETURN=" has_return
}
