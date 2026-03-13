BEGIN {
    has_entry = 0
    has_return_entry = 0
    saw_primary_count = 0
    saw_secondary_count = 0
    saw_bls_return = 0
    saw_secondary_loop_branch = 0
    has_test_secondary_slot_bit = 0
    saw_primary_candidate_loop_branch = 0
    has_wildcard_match = 0
    saw_slot_scan_branch = 0
    has_replace_owned_string = 0
    saw_title_flag_ori = 0
    saw_title_flag_write = 0
    saw_entry_flag_ori = 0
    saw_entry_flag_write = 0
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

    if (uline ~ /^ESQDISP_PROPAGATEPRIMARYTITLEMETADATATOSECONDARY:/ || uline ~ /^ESQDISP_PROPAGATEPRIMARYTITLEMETADATATO[A-Z0-9_]*:/ || uline ~ /^ESQDISP_PROPAGATEPRIMARYTITLEMET[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^ESQDISP_PROPAGATEPRIMARYTITLEMETADATATOSECONDARY_RETURN:/ || uline ~ /^ESQDISP_PROPAGATEPRIMARYTITLEMETADATATO[A-Z0-9_]*_RETURN:/) has_return_entry = 1
    if (uline ~ /MOVEM\.L \(A7\)\+,D5\/D6\/D7\/A2\/A3\/A5/ && has_return_entry == 0) has_return_entry = 1
    if (uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_PRIMARYGROUPENTRYCOUN/) saw_primary_count = 1
    if (uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUNT/ || uline ~ /TEXTDISP_SECONDARYGROUPENTRYCOUN/) saw_secondary_count = 1
    if (uline ~ /BLS\.W ESQDISP_PROPAGATEPRIMARYTITLEMETADATATOSECONDARY_RETURN/ || uline ~ /BLS\.W ESQDISP_PROPAGATEPRIMARYTITLEMETADATATO[A-Z0-9_]*_RETURN/ || uline ~ /BLE\.W ___ESQDISP_PROPAGATEPRIMARYTITLEMET[A-Z0-9_]*__31/) saw_bls_return = 1
    if (uline ~ /^\.LOOP_SECONDARY_ENTRIES:/ || uline ~ /LOOP_SECONDARY_ENTRIES/ || uline ~ /BRA\.W ___ESQDISP_PROPAGATEPRIMARYTITLEMET/ && uline ~ /__6/ || uline ~ /ADDQ\.L #\$1,D7/) saw_secondary_loop_branch = 1
    if (uline ~ /ESQSHARED_JMPTBL_ESQ_TESTBIT1BASED/ || uline ~ /ESQSHARED_JMPTBL_ESQ_TESTBIT1BASE/ || uline ~ /ESQSHARED_JMPTBL_ESQ_TESTBIT1BAS/ || uline ~ /ESQ_TESTBIT1BASED/ || uline ~ /ESQ_TESTBIT1BASE/ || uline ~ /ESQ_TESTBIT1BAS/) has_test_secondary_slot_bit = 1
    if (uline ~ /^\.LOOP_PRIMARY_CANDIDATES:/ || uline ~ /LOOP_PRIMARY_CANDIDATES/ || uline ~ /BRA\.W ___ESQDISP_PROPAGATEPRIMARYTITLEMET/ && uline ~ /__12/ || uline ~ /ADDQ\.L #\$1,\$2C\(A7\)/) saw_primary_candidate_loop_branch = 1
    if (uline ~ /ESQSHARED_JMPTBL_ESQ_WILDCARDMATCH/ || uline ~ /ESQSHARED_JMPTBL_ESQ_WILDCARDMATC/ || uline ~ /ESQSHARED_JMPTBL_ESQ_WILDCARDMAT/ || uline ~ /ESQ_WILDCARDMATCH/ || uline ~ /ESQ_WILDCARDMATC/ || uline ~ /ESQ_WILDCARDMAT/) has_wildcard_match = 1
    if (uline ~ /^\.LOOP_SLOTS_DESCENDING:/ || uline ~ /LOOP_SLOTS_DESCENDING/ || uline ~ /SUBQ\.L #\$1,D[0-7]/ || uline ~ /SUBQ\.L #\$1,\$20\(A7\)/ || uline ~ /BRA\.W ___ESQDISP_PROPAGATEPRIMARYTITLEMET/ && uline ~ /__20/) saw_slot_scan_branch = 1
    if (uline ~ /ESQPARS_REPLACEOWNEDSTRING/ || uline ~ /ESQPARS_REPLACEOWNEDSTRI/) has_replace_owned_string = 1
    if (uline ~ /ORI\.W #\$80,D3/ || uline ~ /ORI\.W #\$80,D[0-7]/) saw_title_flag_ori = 1
    if (uline ~ /MOVE\.B D3,8\(A3\)/ || uline ~ /MOVE\.B D[0-7],8\(A[0-7]\)/ || uline ~ /MOVE\.B D[0-7],\$8\(A[0-7]\)/) saw_title_flag_write = 1
    if (uline ~ /ORI\.W #\$80,D1/ || uline ~ /ORI\.W #\$80,D[0-7]/) saw_entry_flag_ori = 1
    if (uline ~ /MOVE\.B D1,40\(A1\)/ || uline ~ /MOVE\.B D[0-7],40\(A[0-7]\)/ || uline ~ /MOVE\.B D[0-7],\$28\(A[0-7]\)/) saw_entry_flag_write = 1
    if (uline ~ /^RTS$/) has_return = 1
}

END {
    has_primary_count_guard = (saw_primary_count && saw_bls_return) ? 1 : 0
    has_secondary_count_guard = (saw_secondary_count && saw_bls_return) ? 1 : 0
    has_secondary_loop = saw_secondary_loop_branch ? 1 : 0
    has_primary_candidate_loop = saw_primary_candidate_loop_branch ? 1 : 0
    has_slot_scan_loop = saw_slot_scan_branch ? 1 : 0
    has_secondary_title_flag_set = (saw_title_flag_ori && saw_title_flag_write) ? 1 : 0
    has_secondary_entry_flag_set = (saw_entry_flag_ori && saw_entry_flag_write) ? 1 : 0

    print "HAS_ENTRY=" has_entry
    print "HAS_RETURN_ENTRY=" has_return_entry
    print "HAS_PRIMARY_COUNT_GUARD=" has_primary_count_guard
    print "HAS_SECONDARY_COUNT_GUARD=" has_secondary_count_guard
    print "HAS_SECONDARY_LOOP=" has_secondary_loop
    print "HAS_TEST_SECONDARY_SLOT_BIT=" has_test_secondary_slot_bit
    print "HAS_PRIMARY_CANDIDATE_LOOP=" has_primary_candidate_loop
    print "HAS_WILDCARD_MATCH=" has_wildcard_match
    print "HAS_SLOT_SCAN_LOOP=" has_slot_scan_loop
    print "HAS_REPLACE_OWNED_STRING=" has_replace_owned_string
    print "HAS_SECONDARY_TITLE_FLAG_SET=" has_secondary_title_flag_set
    print "HAS_SECONDARY_ENTRY_FLAG_SET=" has_secondary_entry_flag_set
    print "HAS_RETURN=" has_return
}
