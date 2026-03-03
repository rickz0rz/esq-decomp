BEGIN {
    has_label = 0
    has_link = 0
    has_save = 0
    has_get_field_ptr = 0
    has_store_ptr = 0
    has_null_branch = 0
    has_range_cmp = 0
    has_range_branch = 0
    has_char_cmp = 0
    has_bit_test = 0
    has_true_set = 0
    has_true_branch = 0
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

    if (uline ~ /^CLEANUP_TESTENTRYFLAGYANDBIT1:/) has_label = 1
    if (uline ~ /LINK.W A5,#-8/) has_link = 1
    if (uline ~ /MOVEM.L D5-D7\/A3,-\(A7\)/) has_save = 1
    if (uline ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_field_ptr = 1
    if (uline ~ /MOVE.L D0,-4\(A5\)/) has_store_ptr = 1
    if (uline ~ /BEQ.S \.RETURN_FALSE/) has_null_branch = 1
    if (uline ~ /CMP.L D1,D6/) has_range_cmp = 1
    if (uline ~ /BGT.S \.RETURN_FALSE/) has_range_branch = 1
    if (uline ~ /CMP.B 0\(A0,D6.L\),D0/) has_char_cmp = 1
    if (uline ~ /BTST #1,40\(A3\)/) has_bit_test = 1
    if (uline ~ /MOVEQ #1,D0/) has_true_set = 1
    if (uline ~ /BRA.S \.DONE/) has_true_branch = 1
    if (uline ~ /MOVEM.L \(A7\)\+,D5-D7\/A3/) has_restore = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_LINK=" has_link
    print "HAS_SAVE=" has_save
    print "HAS_GET_FIELD_PTR=" has_get_field_ptr
    print "HAS_STORE_PTR=" has_store_ptr
    print "HAS_NULL_BRANCH=" has_null_branch
    print "HAS_RANGE_CMP=" has_range_cmp
    print "HAS_RANGE_BRANCH=" has_range_branch
    print "HAS_CHAR_CMP=" has_char_cmp
    print "HAS_BIT_TEST=" has_bit_test
    print "HAS_TRUE_SET=" has_true_set
    print "HAS_TRUE_BRANCH=" has_true_branch
    print "HAS_RESTORE=" has_restore
}
