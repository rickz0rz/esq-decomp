BEGIN {
    has_label = 0
    has_empty_input_gate = 0
    has_empty_input_commit = 0
    has_separator_probe = 0
    has_default_pair_seed = 0
    has_scratch_seed = 0
    has_prefix_scan = 0
    has_field_a_commit = 0
    has_output_template_seed = 0
    has_separator_advance = 0
    has_token_loop = 0
    has_switch_table = 0
    has_bool_char_gate = 0
    has_bool_upper = 0
    has_flag7_hex_gate = 0
    has_pair_alnum_gate = 0
    has_pair_upper_path = 0
    has_pair_default_fallback = 0
    has_field_b_commit = 0
    has_return = 0

    saw_null_test = 0
    saw_empty_template = 0
    saw_find_char = 0
    saw_colon_const = 0
    saw_default_seed = 0
    saw_scratch_seed = 0
    saw_prefix_limit = 0
    saw_prefix_colon = 0
    saw_prefix_copy = 0
    saw_output_template = 0
    saw_separator_ptr = 0
    saw_token_limit = 0
    saw_token_dispatch = 0
    saw_bool_table = 0
    saw_alpha_btst = 0
    saw_pair_default_label = 0
    pair_mask7_count = 0
    replace_owned_calls = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^CLEANUP_FORMATENTRYSTRINGTOKENS[A-Z0-9_]*:/) has_label = 1

    if (line ~ /^TST\.L / || line ~ /^TST\.B / || line ~ /^MOVE\.L A[0-7],D0$/) {
        saw_null_test = 1
    }
    if (index(line, "ESQPARS_REPLACEOWNEDSTRING") > 0) replace_owned_calls += 1
    if (saw_null_test && index(line, "CLOCK_STR_EMPTY_TOKEN_TEMPLATE") > 0) {
        saw_empty_template = 1
    }
    if (saw_empty_template && replace_owned_calls >= 2) {
        has_empty_input_commit = 1
    }
    if (saw_null_test && saw_empty_template) {
        has_empty_input_gate = 1
    }

    if (line ~ /#\$3A|#58/ || line ~ /^PEA 58\.W$/ || line ~ /^PEA \$3A\.W$/) {
        saw_colon_const = 1
    }
    if (index(line, "STR_FINDCHARPTR") > 0 || index(line, "STR_FINDCHARP") > 0) {
        saw_find_char = 1
    }
    if (saw_colon_const && saw_find_char) {
        has_separator_probe = 1
    }

    if (index(line, "CLOCK_STR_TOKEN_PAIR_DEFAULTS") > 0) {
        saw_default_seed = 1
    }
    if (saw_default_seed &&
        (line ~ /^MOVE\.L \(A[01]\)\+,\(A[01]\)\+$/ ||
         line ~ /^MOVE\.W \(A[01]\),\(A[01]\)\+$/ ||
         line ~ /^MOVE\.B .*21\(A7,D7\.L\)$/ ||
         line ~ /^CLR\.B \(A[01]\)$/ ||
         line ~ /^CLR\.B \$[0-9A-F]+\([A-Z0-7]\)$/)) {
        has_default_pair_seed = 1
    }

    if (index(line, "CLEANUP_TOKENPAIRSCRATCH") > 0) {
        saw_scratch_seed = 1
    }
    if (saw_scratch_seed &&
        (line ~ /^MOVE\.B \(A[01]\)\+,\(A[01]\)\+$/ ||
         line ~ /^MOVE\.B \(A0\)\+,\$15\(A7,D7\.L\)$/)) {
        has_scratch_seed = 1
    }

    if (line ~ /#\$5|#5/) saw_prefix_limit = 1
    if (line ~ /#\$3A|#58/) saw_prefix_colon = 1
    if (saw_prefix_limit && saw_prefix_colon &&
        (line ~ /^MOVE\.B .*,-11\(A5,D7\.L\)$/ || line ~ /^MOVE\.B .*,\$15\(A[67],D[0-7]\.L\)$/)) {
        saw_prefix_copy = 1
    }
    if (saw_prefix_copy && (line ~ /^CLR\.B -11\(A5,D7\.L\)$/ || line ~ /^CLR\.B \$15\(A[67],D[0-7]\.L\)$/)) {
        has_prefix_scan = 1
    }

    if (index(line, "ESQPARS_REPLACEOWNEDSTRING") > 0 &&
        (line ~ /^MOVE\.L D0,\(A[235]\)$/ || line ~ /^MOVE\.L D0,\$[0-9A-F]+\([A-Z0-7]\)$/)) {
        has_field_a_commit = 1
    }

    if (index(line, "CLOCK_STR_TOKEN_OUTPUT_TEMPLATE") > 0) {
        saw_output_template = 1
    }
    if (saw_output_template &&
        (line ~ /^MOVE\.B \(A[01]\)\+,\(A[01]\)\+$/ ||
         line ~ /^MOVE\.B \(A0\)\+,\$15\(A7,D7\.L\)$/)) {
        has_output_template_seed = 1
    }

    if ((line ~ /^ADDQ\.L #1,-26\(A5\)$/ || line ~ /^ADDQ\.L #\$1,-26\(A5\)$/ ||
         line ~ /^ADDQ\.L #1,\$[0-9A-F]+\([AD][0-7]\)$/ ||
         line ~ /^ADDQ\.L #\$1,\$[0-9A-F]+\([AD][0-7]\)$/ ||
         line ~ /^MOVE\.L D0,\$34\(A7\)$/) && saw_find_char) {
        has_separator_advance = 1
    }

    if (line ~ /#\$A|#10/) saw_token_limit = 1
    if (index(line, ".TOKEN_TABLE") > 0 || line ~ /^CMPI?\.L #\$?9,D0$/ ||
        line ~ /^CMP\.L D0,D7$/ || index(line, "___CLEANUP_FORMATENTRYSTRINGTOKENS__23") > 0) {
        saw_token_dispatch = 1
    }

    if (index(line, "CLOCK_STR_BOOL_CHARS_YYNN") > 0) {
        saw_bool_table = 1
    }
    if (saw_bool_table && saw_find_char) {
        has_bool_char_gate = 1
    }
    if (line ~ /BTST #1,\(A[016]\)/ || line ~ /BTST #\$1,\$0\(A0,D0\.W\)/) {
        saw_alpha_btst = 1
    }
    if (saw_bool_table && saw_alpha_btst &&
        (line ~ /^SUB\.L D1,D0$/ || line ~ /#\$20|#32/)) {
        has_bool_upper = 1
    }

    if (line ~ /BTST #7,\(A[016]\)/ || line ~ /BTST #\$7,\$0\(A0,D0\.W\)/) {
        has_flag7_hex_gate = 1
        pair_mask7_count += 1
    }

    if (line ~ /AND\.B \(A6\),D0/ || line ~ /AND\.B \$0\(A0,D0\.W\),D[01]/) {
        pair_mask7_count += 1
    }
    if (pair_mask7_count >= 2) {
        has_pair_alnum_gate = 1
    }

    if (has_pair_alnum_gate && saw_alpha_btst &&
        (line ~ /^SUB(\.L|I\.B) .*#\$20/ ||
         line ~ /^SUBI\.B #\$20,D[06]$/ ||
         index(line, ".STORE_PAIR_CHAR1") > 0 ||
         index(line, ".STORE_PAIR_CHAR2") > 0)) {
        has_pair_upper_path = 1
    }

    if (index(line, ".COPY_DEFAULT_PAIR") > 0 ||
        line ~ /^MOVE\.B -22\(A5,D0\.L\),\(A1\)$/ ||
        line ~ /^MOVE\.B -22\(A5,D7\.L\),-11\(A5,D7\.L\)$/ ||
        line ~ /^MOVE\.B \$21\(A7,D0\.L\),\(A1\)$/ ||
        line ~ /^MOVE\.B \$21\(A7,D7\.L\),\$15\(A7,D7\.L\)$/) {
        has_pair_default_fallback = 1
    }

    if (index(line, "ESQPARS_REPLACEOWNEDSTRING") > 0 &&
        (line ~ /^MOVE\.L D0,\(A[23]\)$/ || line ~ /^MOVE\.L D0,\(A5\)$/ ||
         line ~ /^MOVE\.L D0,\$[0-9A-F]+\([A-Z0-7]\)$/)) {
        has_field_b_commit = 1
    }

    if (!has_token_loop && saw_token_limit && saw_token_dispatch &&
        (has_bool_char_gate || has_flag7_hex_gate || has_pair_alnum_gate)) {
        has_token_loop = 1
    }
    if (!has_switch_table && has_bool_char_gate && has_flag7_hex_gate && has_pair_alnum_gate) {
        has_switch_table = 1
    }

    if (line == "RTS") has_return = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_EMPTY_INPUT_GATE=" has_empty_input_gate
    print "HAS_EMPTY_INPUT_COMMIT=" has_empty_input_commit
    print "HAS_SEPARATOR_PROBE=" has_separator_probe
    print "HAS_DEFAULT_PAIR_SEED=" has_default_pair_seed
    print "HAS_SCRATCH_SEED=" has_scratch_seed
    print "HAS_PREFIX_SCAN=" has_prefix_scan
    print "HAS_FIELD_A_COMMIT=" has_field_a_commit
    print "HAS_OUTPUT_TEMPLATE_SEED=" has_output_template_seed
    print "HAS_SEPARATOR_ADVANCE=" has_separator_advance
    print "HAS_TOKEN_LOOP=" has_token_loop
    print "HAS_SWITCH_TABLE=" has_switch_table
    print "HAS_BOOL_CHAR_GATE=" has_bool_char_gate
    print "HAS_BOOL_UPPER=" has_bool_upper
    print "HAS_FLAG7_HEX_GATE=" has_flag7_hex_gate
    print "HAS_PAIR_ALNUM_GATE=" has_pair_alnum_gate
    print "HAS_PAIR_UPPER_PATH=" has_pair_upper_path
    print "HAS_PAIR_DEFAULT_FALLBACK=" has_pair_default_fallback
    print "HAS_FIELD_B_COMMIT=" has_field_b_commit
    print "HAS_RETURN=" has_return
}
