BEGIN {
    has_label = 0
    find_char_calls = 0
    replace_owned_calls = 0
    has_empty_pair_replace = 0
    has_default_copy = 0
    has_scratch_copy = 0
    has_prefix_scan_limit = 0
    has_field_a_commit = 0
    has_output_template_copy = 0
    has_separator_refind = 0
    has_token_loop_limit = 0
    has_bool_gate = 0
    has_bool_alpha_upper = 0
    has_hex_gate = 0
    pair_mask7_count = 0
    pair_alpha_count = 0
    has_pair_default_fallback = 0
    has_field_b_commit = 0
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
        u ~ /STR_FINDCHARPTR/) find_char_calls += 1
    if (u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEOWNEDSTRING/ ||
        u ~ /GROUP_AE_JMPTBL_ESQPARS_REPLACEO/ ||
        u ~ /ESQPARS_REPLACEOWNEDSTRING/) replace_owned_calls += 1
    if (u ~ /CLOCK_STR_EMPTY_TOKEN_TEMPLATE/) has_empty_pair_replace = 1
    if (u ~ /CLOCK_STR_TOKEN_PAIR_DEFAULTS/) has_default_copy = 1
    if (u ~ /CLEANUP_TOKENPAIRSCRATCH/) has_scratch_copy = 1
    if (u ~ /MOVEQ(\.L)? #\$?5,D[01]/ ||
        u ~ /CMP\.L D0,D7/ && u ~ /#\$?5/ ||
        u ~ /SCAN_INPUT_LOOP/ ||
        u ~ /COPY_PREFIX_LOOP/) has_prefix_scan_limit = 1
    if (u ~ /MOVE\.L D0,\(A5\)/ || u ~ /MOVE\.L D0,\(A3\)/) has_field_a_commit = 1
    if (u ~ /CLOCK_STR_TOKEN_OUTPUT_TEMPLATE/) has_output_template_copy = 1
    if (u ~ /ADDQ\.L #1,-26\(A5\)/ || u ~ /ADDQ\.L #\$1,\$34\(A7\)/) has_separator_refind = 1
    if (u ~ /MOVEQ(\.L)? #\$?A,D0/ || u ~ /TOKEN_LOOP/) has_token_loop_limit = 1
    if (u ~ /CLOCK_STR_BOOL_CHARS_YYNN/) has_bool_gate = 1
    if (u ~ /BTST #1,\(A1\)/ || u ~ /BTST #1,\(A6\)/ || u ~ /BTST #\$1,\$0\(A0,D0\.W\)/) has_bool_alpha_upper = 1
    if (u ~ /BTST #7,\(A0\)/ || u ~ /BTST #\$7,\$0\(A0,D0\.W\)/) has_hex_gate = 1
    if (u ~ /AND\.B \(A6\),D0/ || u ~ /AND\.B \$0\(A0,D0\.W\),D1/) pair_mask7_count += 1
    if (u ~ /BTST #1,\(A6\)/ || u ~ /BTST #1,\(A1\)/ || u ~ /BTST #\$1,\$0\(A0,D0\.W\)/) pair_alpha_count += 1
    if (u ~ /MOVE\.B -22\(A5,D7\.L\),-11\(A5,D7\.L\)/ ||
        u ~ /MOVE\.B \$22\(A7,D7\.L\),\$16\(A7,D7\.L\)/) has_pair_default_fallback = 1
    if (u ~ /COMMIT_OUTPUT/ || u ~ /MOVE\.L D0,\(A2\)/ || u ~ /MOVE\.L D0,\(A3\)/) has_field_b_commit = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_FIND_CHAR_CALLS=" (find_char_calls >= 2)
    print "HAS_REPLACE_OWNED_CALLS=" (replace_owned_calls >= 4)
    print "HAS_EMPTY_PAIR_REPLACE=" has_empty_pair_replace
    print "HAS_DEFAULT_COPY=" has_default_copy
    print "HAS_SCRATCH_COPY=" has_scratch_copy
    print "HAS_PREFIX_SCAN_LIMIT=" has_prefix_scan_limit
    print "HAS_FIELD_A_COMMIT=" has_field_a_commit
    print "HAS_OUTPUT_TEMPLATE_COPY=" has_output_template_copy
    print "HAS_SEPARATOR_REFIND=" has_separator_refind
    print "HAS_TOKEN_LOOP_LIMIT=" has_token_loop_limit
    print "HAS_BOOL_GATE=" has_bool_gate
    print "HAS_BOOL_ALPHA_UPPER=" has_bool_alpha_upper
    print "HAS_HEX_GATE=" has_hex_gate
    print "HAS_PAIR_MASK7=" (pair_mask7_count >= 2)
    print "HAS_PAIR_ALPHA=" (pair_alpha_count >= 3)
    print "HAS_PAIR_DEFAULT_FALLBACK=" has_pair_default_fallback
    print "HAS_FIELD_B_COMMIT=" has_field_b_commit
    print "HAS_RETURN=" has_return
}
