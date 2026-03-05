BEGIN {
    has_label = 0
    has_get_field_ptr = 0
    has_null_branch = 0
    has_range_cmp = 0
    has_char_cmp = 0
    has_bit_test = 0
    has_true_set = 0
    has_return = 0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^CLEANUP_TESTENTRYFLAGYANDBIT1[A-Z0-9_]*:/) has_label = 1
    if (u ~ /COI_GETANIMFIELDPOINTERBYMODE/) has_get_field_ptr = 1
    if (u ~ /BEQ\.[BWS]? .*RETURN_FALSE/ || u ~ /TST.L/) has_null_branch = 1
    if (u ~ /CMP.L D1,D6/ || u ~ /CMPI.L #\$5/ || u ~ /BGT\./ || u ~ /BMI\./) has_range_cmp = 1
    if (u ~ /CMP.B 0\(A0,D6.L\),D0/ || u ~ /CMP.B \$0\(A3,D6.L\),D0/ || u ~ /CMPI.B #\$59/ || u ~ /#89/) has_char_cmp = 1
    if (u ~ /BTST #1,40\(A3\)/ || u ~ /BTST #\$1,\(A0\)/ || u ~ /ANDI.B #\$2/) has_bit_test = 1
    if (u ~ /MOVEQ #1,D0/ || u ~ /MOVEQ.L #\$1,D0/) has_true_set = 1
    if (u == "RTS") has_return = 1
}
END {
    print "HAS_LABEL=" has_label
    print "HAS_GET_FIELD_PTR=" has_get_field_ptr
    print "HAS_NULL_BRANCH=" has_null_branch
    print "HAS_RANGE_CMP=" has_range_cmp
    print "HAS_CHAR_CMP=" has_char_cmp
    print "HAS_BIT_TEST=" has_bit_test
    print "HAS_TRUE_SET=" has_true_set
    print "HAS_RETURN=" has_return
}
