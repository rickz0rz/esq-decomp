BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_find_char = 0
    has_default_copy = 0
    has_replace_owned = 0
    has_token_loop = 0
    has_commit_output = 0
    has_empty_input = 0
    has_restore = 0
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

    if (uline ~ /^CLEANUP_FORMATENTRYSTRINGTOKENS:/) has_label = 1
    if (uline ~ /LINK.W A5,#-32/) has_link = 1
    if (uline ~ /MOVEM.L D7\/A2-A3\/A6,-\(A7\)/) has_save = 1
    if (uline ~ /GROUP_AI_JMPTBL_STR_FINDCHARPTR/) has_find_char = 1
    if (uline ~ /CLOCK_STR_TOKEN_PAIR_DEFAULTS/ || uline ~ /\.COPY_PREFIX_LOOP:/) has_default_copy = 1
    if (uline ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/) has_replace_owned = 1
    if (uline ~ /\.TOKEN_LOOP:/) has_token_loop = 1
    if (uline ~ /\.COMMIT_OUTPUT:/) has_commit_output = 1
    if (uline ~ /\.EMPTY_INPUT:/) has_empty_input = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D7\/A2-A3\/A6/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_FIND_CHAR=" has_find_char
    print "HAS_DEFAULT_COPY=" has_default_copy
    print "HAS_REPLACE_OWNED=" has_replace_owned
    print "HAS_TOKEN_LOOP=" has_token_loop
    print "HAS_COMMIT_OUTPUT=" has_commit_output
    print "HAS_EMPTY_INPUT=" has_empty_input
    print "HAS_RESTORE=" has_restore
}
