BEGIN {
    has_entry = 0
    has_guard = 0
    has_alloc = 0
    has_open = 0
    has_header_writes = 0
    has_test_bit = 0
    has_sanitize_call = 0
    has_write_bytes = 0
    has_close = 0
    has_free = 0
    has_entry_ptr_null_guard = 0
    has_title_ptr_null_guard = 0
    has_slot_text_null_guard = 0

    saw_entry_ptr_test = 0
    saw_title_ptr_test = 0
    saw_slot_text_test = 0
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

    if (saw_entry_ptr_test && line ~ /^BEQ\./) has_entry_ptr_null_guard = 1
    if (saw_title_ptr_test && line ~ /^BEQ\./) has_title_ptr_null_guard = 1
    if (saw_slot_text_test && line ~ /^BEQ\./) has_slot_text_null_guard = 1

    saw_entry_ptr_test = 0
    saw_title_ptr_test = 0
    saw_slot_text_test = 0

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /SECONDARYGROUPENTRYCOUNT/ || line ~ /SAVEOPERATIONREADYFLAG/) has_guard = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCAT/) has_alloc = 1
    if (line ~ /DISKIO_OPENFILEWITHBUFFER/) has_open = 1
    if (line ~ /DISKIO_WRITEDECIMALFIELD/) has_header_writes = 1
    if (line ~ /ESQ_TESTBIT1BASED/ || line ~ /ESQ_TESTBIT1BASE/) has_test_bit = 1
    if (line ~ /DISKIO2_COPYANDSANITIZESLOTSTRING/ || line ~ /DISKIO2_COPYANDSANITIZESLOTS/) has_sanitize_call = 1
    if (line ~ /DISKIO_WRITEBUFFEREDBYTES/) has_write_bytes = 1
    if (line ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_free = 1

    if (line ~ /^MOVE\.L A3,D0$/) saw_entry_ptr_test = 1
    if (line ~ /^MOVE\.L A2,D0$/) saw_title_ptr_test = 1
    if (line ~ /^MOVE\.L \$24\(A7\),D0$/) saw_slot_text_test = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_ALLOC=" has_alloc
    print "HAS_OPEN=" has_open
    print "HAS_HEADER_WRITES=" has_header_writes
    print "HAS_TEST_BIT=" has_test_bit
    print "HAS_SANITIZE_CALL=" has_sanitize_call
    print "HAS_WRITE_BYTES=" has_write_bytes
    print "HAS_CLOSE=" has_close
    print "HAS_FREE=" has_free
    print "HAS_ENTRY_PTR_NULL_GUARD=" has_entry_ptr_null_guard
    print "HAS_TITLE_PTR_NULL_GUARD=" has_title_ptr_null_guard
    print "HAS_SLOT_TEXT_NULL_GUARD=" has_slot_text_null_guard
}
