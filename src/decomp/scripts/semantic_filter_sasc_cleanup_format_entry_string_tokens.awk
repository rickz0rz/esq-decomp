BEGIN {
    has_label = 0
    has_find_char = 0
    has_default_copy = 0
    has_replace_owned = 0
    has_token_loop = 0
    has_commit_output = 0
    has_empty_input = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_FORMATENTRYSTRINGTOKENS[A-Z0-9_]*:/) has_label = 1
    if (u ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/ ||
        u ~ /GROUP_AI_JMPTBL_STR_FINDCHARP/ ||
        u ~ /STR_FINDCHARPTR/) has_find_char = 1
    if (u ~ /CLOCK_STR_TOKEN_PAIR_DEFAULTS/ || u ~ /CLEANUP_TOKENPAIRSCRATCH/ || u ~ /COPY_PREFIX_LOOP/ || u ~ /CLOCK_STR_TOKEN_OUTPUT_TEMPLATE/) has_default_copy = 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ ||
        u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ ||
        u ~ /ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned = 1
    if (u ~ /TOKEN_LOOP/ || u ~ /CMP.L D0,D7/ || u ~ /ADDQ.L #1,D7/) has_token_loop = 1
    if (u ~ /COMMIT_OUTPUT/ || u ~ /MOVE.L D0,\(A2\)/ || u ~ /MOVE.L D0,\(A3\)/ || u ~ /MOVE.L D0,\(A5\)/) has_commit_output = 1
    if (u ~ /EMPTY_INPUT/ || u ~ /CLOCK_STR_EMPTY_TOKEN_TEMPLATE/) has_empty_input = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_DEFAULT_COPY=" has_default_copy
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_TOKEN_LOOP=" has_token_loop
    print "HAS_COMMIT_OUTPUT=" has_commit_output
    print "HAS_EMPTY_INPUT=" has_empty_input
    print "HAS_RETURN=" has_return
}
