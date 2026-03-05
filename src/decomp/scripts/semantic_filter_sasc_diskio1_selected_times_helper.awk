BEGIN {
    has_entry = 0
    has_bound_cmp = 0
    has_test_call = 0
    has_clock_ref = 0
    has_fmt_call = 0
    has_index_inc = 0
    has_term_transfer = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /^CMP\.[BWL] / || line ~ /^CMPI\.[BWL] /) has_bound_cmp = 1
    if (line ~ /ESQ_TESTBIT1/) has_test_call = 1
    if (line ~ /GLOBAL_REF_STR_CLOCK_FORMAT/) has_clock_ref = 1
    if (line ~ /FORMAT_RAWDOFMTWITHSCRATCHBUFFER/ || line ~ /GROUP_AJ_JMPTBL_FORMAT_RAWDOFMTW/) has_fmt_call = 1
    if (line ~ /^ADDQ\.[BWL] #\$?1,D4/ || line ~ /^ADDQ\.[BWL] #\$?1,D0/) has_index_inc = 1
    if (TERM_PREFIX != "" && line ~ /^(B[A-Z]+|JMP|JSR)(\.[A-Z]+)? / && index(line, TERM_PREFIX) > 0) has_term_transfer = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BOUND_CMP=" has_bound_cmp
    print "HAS_TEST_CALL=" has_test_call
    print "HAS_CLOCK_REF=" has_clock_ref
    print "HAS_FMT_CALL=" has_fmt_call
    print "HAS_INDEX_INC=" has_index_inc
    print "HAS_TERM_TRANSFER=" has_term_transfer
}
