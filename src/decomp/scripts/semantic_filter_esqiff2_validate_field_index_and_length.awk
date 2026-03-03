BEGIN {
    has_entry = 0
    has_save = 0
    has_field_cmp = 0
    has_gt3_reject = 0
    has_field1_cmp = 0
    has_len10_cmp = 0
    has_non1_len7_cmp = 0
    has_return_branch = 0
    has_valid_set = 0
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

    if (uline ~ /^ESQIFF2_VALIDATEFIELDINDEXANDLENGTH:/) has_entry = 1
    if (uline ~ /^MOVEM\.L D6-D7,-\(A7\)$/) has_save = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_field_cmp = 1
    if (uline ~ /^MOVEQ #0,D0$/) has_gt3_reject = 1
    if (uline ~ /^BNE\.[SW] \.VALIDATE_NON_FIELD1_LENGTH$/) has_field1_cmp = 1
    if (uline ~ /^MOVEQ #10,D0$/) has_len10_cmp = 1
    if (uline ~ /^MOVEQ #7,D0$/) has_non1_len7_cmp = 1
    if (uline ~ /^BRA\.[SW] ESQIFF2_VALIDATEFIELDINDEXANDLENGTH_RETURN$/) has_return_branch = 1
    if (uline ~ /^\.RETURN_VALID_FIELD_BOUNDS:$/ || uline ~ /^MOVEQ #1,D0$/) has_valid_set = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_FIELD_CMP=" has_field_cmp
    print "HAS_GT3_REJECT=" has_gt3_reject
    print "HAS_FIELD1_CMP=" has_field1_cmp
    print "HAS_LEN10_CMP=" has_len10_cmp
    print "HAS_NON1_LEN7_CMP=" has_non1_len7_cmp
    print "HAS_RETURN_BRANCH=" has_return_branch
    print "HAS_VALID_SET=" has_valid_set
}
