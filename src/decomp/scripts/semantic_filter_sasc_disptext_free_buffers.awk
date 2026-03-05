BEGIN {
    has_entry = 0
    has_reset = 0
    has_test_buf1 = 0
    has_dealloc_call = 0
    has_clear_buf1 = 0
    has_test_buf2 = 0
    has_clear_buf2 = 0
    has_return = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next
    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (l ~ /RESETTEXTBUFFERANDLINETABLES/ || l ~ /RESETTEXTBUFFERANDLINETA/) has_reset = 1
    if ((l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_1/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) && l ~ /(TST\.L|MOVE\.L)/) has_test_buf1 = 1
    if (l ~ /MEMORY_DEALLOCATEMEMORY/ || l ~ /MEMORY_DEALLOCATEMEM/ || l ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATE/ || l ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_dealloc_call = 1
    if ((l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_1/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) && (l ~ /CLR\.L/ || l ~ /MOVEQ(\.L)? #\$?0/ || l ~ /SUB\.L A0,A0/)) has_clear_buf1 = 1
    if ((l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_2/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) && l ~ /(TST\.L|MOVE\.L)/) has_test_buf2 = 1
    if ((l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_2/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) && (l ~ /CLR\.L/ || l ~ /MOVEQ(\.L)? #\$?0/ || l ~ /SUB\.L A0,A0/)) has_clear_buf2 = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_RESET=" has_reset
    print "HAS_TEST_BUF1=" has_test_buf1
    print "HAS_DEALLOC_CALL=" has_dealloc_call
    print "HAS_CLEAR_BUF1=" has_clear_buf1
    print "HAS_TEST_BUF2=" has_test_buf2
    print "HAS_CLEAR_BUF2=" has_clear_buf2
    print "HAS_RETURN=" has_return
}
