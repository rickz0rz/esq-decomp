BEGIN {
    has_entry = 0
    has_guard = 0
    has_ready_flag_reset = 0
    has_ready_flag_restore = 0
    has_fail_return_neg1 = 0
    has_alloc = 0
    has_open = 0
    has_header_writes = 0
    has_label_scan = 0
    has_status_ptr_fallback = 0
    has_status_scan = 0
    has_test_bit = 0
    has_sanitize_call = 0
    has_sanitize_gate = 0
    has_entry_block_write = 0
    has_title_scan = 0
    has_slot_ptr_guard = 0
    has_slot_skip = 0
    has_slot_attr_writes = 0
    has_slot_text_write = 0
    has_slot_sentinel = 0
    has_write_bytes = 0
    has_close = 0
    has_free = 0
    in_status_scan_window = 0
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

    if (line ~ /PRIMARYGROUPENTRYCOUNT/ || line ~ /SAVEOPERATIONREADYFLAG/) has_guard = 1
    if ((line ~ /SAVEOPERATIONREADYFLAG/ && line ~ /CLR\./) || line ~ /CLR\.[A-Z]* .*6CC\(A4\)/) has_ready_flag_reset = 1
    if (line ~ /MOVEQ(\.L)? #\$?1,D0/ ||
        (line ~ /SAVEOPERATIONREADYFLAG/ && line ~ /#?1/) ||
        line ~ /MOVE\.[A-Z]* D0,__MERGEDBSS\+\$6CC\(A4\)/) has_ready_flag_restore = 1
    if (line ~ /MOVEQ(\.L)? #(-1|\$?FF),D0/) has_fail_return_neg1 = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCAT/) has_alloc = 1
    if (line ~ /DISKIO_OPENFILEWITHBUFFER/) has_open = 1
    if (line ~ /DISKIO_WRITEDECIMALFIELD/) has_header_writes = 1
    if (line ~ /WEATHERSTATUSLABELBUFFER/) has_label_scan = 1
    if (line ~ /WEATHERSTATUSTEXTPTR/ || line ~ /\$2C\(A7\)/) has_status_ptr_fallback = 1
    if (line ~ /WEATHERSTATUSLABELBUFFER/ || line ~ /WEATHERSTATUSTEXTPTR/ || line ~ /\$30\(A7\)/ || line ~ /\$2C\(A7\)/) {
        in_status_scan_window = 1
    }
    if (in_status_scan_window &&
        (line ~ /TST\.B \(A[0-3]\)/ || line ~ /TST\.B \(A[0-3]\)\+/ || line ~ /ADDQ\.L #\$?1,\$30\(A7\)/)) has_status_scan = 1
    if (in_status_scan_window && line ~ /DISKIO_WRITEDECIMALFIELD/) in_status_scan_window = 0
    if (line ~ /ESQ_TESTBIT1BASED/ || line ~ /ESQ_TESTBIT1BASE/) has_test_bit = 1
    if (line ~ /DISKIO2_COPYANDSANITIZESLOTSTRING/ || line ~ /DISKIO2_COPYANDSANITIZESLOTS/) has_sanitize_call = 1
    if (line ~ /CMPI\.W #\$64,D[0-7]/ || line ~ /CMPI\.W #100,D[0-7]/ ||
        line ~ /MOVEQ(\.L)? #(\$64|100),D[0-7]/) has_sanitize_gate = 1
    if (line ~ /PEA \(\$30\)\.W/ || line ~ /PEA 48\.W/ || line ~ /#\$30/) has_entry_block_write = 1
    if (line ~ /TST\.B \(A[023]\)/ || line ~ /TST\.B \(A[023]\)\+/) has_title_scan = 1
    if (line ~ /SLOTTEXTTABLE/ || line ~ /TST\.L (\$[0-9A-F]+|[0-9]+)\([AD][0-7],D[0-7]\.[WL]\)/ ||
        line ~ /MOVE\.L (\$[0-9A-F]+|[0-9]+)\([AD][0-7],D[0-7]\.[WL]\),D[0-7]/) has_slot_ptr_guard = 1
    if (line ~ /BEQ\.[A-Z]* / || line ~ /BNE\.[A-Z]* / || line ~ /CMP\.W #\$31,D[0-7]/ || line ~ /CMP\.W #49,D[0-7]/) has_slot_skip = 1
    if (line ~ /SLOTFLAGS/ || line ~ /SLOTATTR252/ || line ~ /SLOTATTR301/ || line ~ /SLOTATTR350/ ||
        line ~ /ADDI?\.W #(\$FC|\$12D|\$15E),D[0-7]/ || line ~ /ADD\.L #(\$FC|\$12D|\$15E),D[0-7]/) has_slot_attr_writes = 1
    if (line ~ /DISKIO_WRITEBUFFEREDBYTES/ && line !~ /ESQ_STR_B/ && line !~ /DREV_5_1/) has_slot_text_write = 1
    if (line ~ /#\$31/ || line ~ /#49/ || line ~ /\(\$31\)\.W/) has_slot_sentinel = 1
    if (line ~ /DISKIO_WRITEBUFFEREDBYTES/) has_write_bytes = 1
    if (line ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) has_close = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_free = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_READY_FLAG_RESET=" has_ready_flag_reset
    print "HAS_READY_FLAG_RESTORE=" has_ready_flag_restore
    print "HAS_FAIL_RETURN_NEG1=" has_fail_return_neg1
    print "HAS_ALLOC=" has_alloc
    print "HAS_OPEN=" has_open
    print "HAS_HEADER_WRITES=" has_header_writes
    print "HAS_LABEL_SCAN=" has_label_scan
    print "HAS_STATUS_PTR_FALLBACK=" has_status_ptr_fallback
    print "HAS_STATUS_SCAN=" has_status_scan
    print "HAS_TEST_BIT=" has_test_bit
    print "HAS_SANITIZE_CALL=" has_sanitize_call
    print "HAS_SANITIZE_GATE=" has_sanitize_gate
    print "HAS_ENTRY_BLOCK_WRITE=" has_entry_block_write
    print "HAS_TITLE_SCAN=" has_title_scan
    print "HAS_SLOT_PTR_GUARD=" has_slot_ptr_guard
    print "HAS_SLOT_SKIP=" has_slot_skip
    print "HAS_SLOT_ATTR_WRITES=" has_slot_attr_writes
    print "HAS_SLOT_TEXT_WRITE=" has_slot_text_write
    print "HAS_SLOT_SENTINEL=" has_slot_sentinel
    print "HAS_WRITE_BYTES=" has_write_bytes
    print "HAS_CLOSE=" has_close
    print "HAS_FREE=" has_free
}
