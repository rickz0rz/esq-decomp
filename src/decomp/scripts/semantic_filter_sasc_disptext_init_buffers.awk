BEGIN {
    has_entry = 0
    has_pending_test = 0
    has_clear_textptr = 0
    has_reset = 0
    has_clear_pending = 0
    has_alloc_call = 0
    has_store_buf1 = 0
    has_store_buf2 = 0
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
    if (l ~ /DISPTEXT_INITBUFFERSPENDING/) has_pending_test = 1
    if (l ~ /DISPTEXT_TEXTBUFFERPTR/ && (l ~ /CLR\.L/ || l ~ /MOVEQ(\.L)? #\$?0/)) has_clear_textptr = 1
    if (l ~ /DISPLIB_RESETLINETABLES/ || l ~ /DISPLIB_RESETLINETA/) has_reset = 1
    if (l ~ /DISPTEXT_INITBUFFERSPENDING/ && (l ~ /CLR\.L/ || l ~ /MOVEQ(\.L)? #\$?0/)) has_clear_pending = 1
    if (l ~ /MEMORY_ALLOCATEMEMORY/ || l ~ /MEMORY_ALLOCATEMEM/ || l ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATE/) has_alloc_call = 1
    if (l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_1/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) has_store_buf1 = 1
    if (l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_2/ || l ~ /GLOBAL_REF_1000_BYTES_ALLOCATED_/) has_store_buf2 = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_PENDING_TEST=" has_pending_test
    print "HAS_CLEAR_TEXTPTR=" has_clear_textptr
    print "HAS_RESET=" has_reset
    print "HAS_CLEAR_PENDING=" has_clear_pending
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_STORE_BUF1=" has_store_buf1
    print "HAS_STORE_BUF2=" has_store_buf2
    print "HAS_RETURN=" has_return
}
