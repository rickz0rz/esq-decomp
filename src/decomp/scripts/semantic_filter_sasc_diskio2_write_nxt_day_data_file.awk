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

    has_entry_count_limit = 0
    has_entry_count_threshold = 0
    has_slot_limit = 0
    has_entry_block_write = 0
    has_entry_ptr_table = 0
    has_title_ptr_table = 0
    has_slot_text_table = 0
    has_slot_mask_base = 0
    has_slot_flag_attr = 0
    has_slot_attr252 = 0
    has_slot_attr301 = 0
    has_slot_attr350 = 0
    has_alloc_line_817 = 0
    has_free_line_839 = 0
    has_free_line_901 = 0

    decimal_write_calls = 0
    buffered_write_calls = 0
    free_calls = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function is_call(line, symbol) {
    return line ~ ("^(JSR|BSR)(\\.[A-Z])? " symbol)
}

{
    line = trim($0)
    if (line == "") next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (line ~ /SECONDARYGROUPENTRYCOUNT/ || line ~ /SAVEOPERATIONREADYFLAG/) has_guard = 1
    if (is_call(line, "(GROUP_AG_JMPTBL_MEMORY_ALLOCATEMEMORY|GROUP_AG_JMPTBL_MEMORY_ALLOCAT)")) has_alloc = 1
    if (is_call(line, "DISKIO_OPENFILEWITHBUFFER")) has_open = 1
    if (is_call(line, "DISKIO_WRITEDECIMALFIELD")) {
        has_header_writes = 1
        decimal_write_calls++
    }
    if (is_call(line, "(GROUP_AH_JMPTBL_ESQ_TESTBIT1BASED|ESQ_TESTBIT1BASED|ESQ_TESTBIT1BASE)")) has_test_bit = 1
    if (is_call(line, "(DISKIO2_COPYANDSANITIZESLOTSTRING|DISKIO2_COPYANDSANITIZESLOTS)")) has_sanitize_call = 1
    if (is_call(line, "DISKIO_WRITEBUFFEREDBYTES")) {
        has_write_bytes = 1
        buffered_write_calls++
    }
    if (is_call(line, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH")) has_close = 1
    if (is_call(line, "(GROUP_AG_JMPTBL_MEMORY_DEALLOCATEMEMORY|GROUP_AG_JMPTBL_MEMORY_DEALLOCAT)")) {
        has_free = 1
        free_calls++
    }

    if (line ~ /CMPI\.W #200,D0/ || line ~ /CMPI\.W #\$C8,D0/) has_entry_count_limit = 1
    if (line ~ /MOVEQ #100,D1/ || line ~ /MOVEQ\.L #\$64,D1/) has_entry_count_threshold = 1
    if (line ~ /MOVEQ #49,D0/ || line ~ /MOVEQ\.L #\$31,D0/ || line ~ /PEA \(\$31\)\.W/) has_slot_limit = 1
    if (line ~ /PEA 48\.W/ || line ~ /PEA \(\$30\)\.W/) has_entry_block_write = 1

    if (line ~ /TEXTDISP_SECONDARYENTRYPTRTABLE/ || line ~ /__MERGEDBSS\+\$6\(A4\)/) has_entry_ptr_table = 1
    if (line ~ /TEXTDISP_SECONDARYTITLEPTRTABLE/ || line ~ /__MERGEDBSS\+\$326\(A4\)/) has_title_ptr_table = 1
    if (line ~ /TST\.L 56\(A0,D0\.L\)/ || line ~ /MOVEA\.L 56\(A0,D0\.L\),A0/ || line ~ /TST\.L \$38\(A2,D0\.L\)/ || line ~ /MOVE\.L \$38\(A2,D0\.L\),A0/) has_slot_text_table = 1
    if (line ~ /ADDA\.W #28,A1/ || line ~ /LEA \$1C\(A3\),A0/) has_slot_mask_base = 1
    if (line ~ /MOVE\.B 7\(A0,D6\.W\),D0/ || line ~ /MOVE\.B \$7\(A2,D0\.L\),D5/) has_slot_flag_attr = 1
    if (line ~ /ADDI\.W #252,D1/ || line ~ /ADD\.L #\$FC,D2/) has_slot_attr252 = 1
    if (line ~ /ADDI\.W #301,D1/ || line ~ /ADD\.L #\$12D,D2/) has_slot_attr301 = 1
    if (line ~ /ADDI\.W #350,D1/ || line ~ /ADD\.L #\$15E,D2/) has_slot_attr350 = 1

    if (line ~ /PEA 817\.W/ || line ~ /PEA \(\$331\)\.W/) has_alloc_line_817 = 1
    if (line ~ /PEA 839\.W/ || line ~ /PEA \(\$347\)\.W/) has_free_line_839 = 1
    if (line ~ /PEA 901\.W/ || line ~ /PEA \(\$385\)\.W/) has_free_line_901 = 1
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
    print "HAS_ENTRY_COUNT_LIMIT=" has_entry_count_limit
    print "HAS_ENTRY_COUNT_THRESHOLD=" has_entry_count_threshold
    print "HAS_SLOT_LIMIT=" has_slot_limit
    print "HAS_ENTRY_BLOCK_WRITE=" has_entry_block_write
    print "HAS_ENTRY_PTR_TABLE=" has_entry_ptr_table
    print "HAS_TITLE_PTR_TABLE=" has_title_ptr_table
    print "HAS_SLOT_TEXT_TABLE=" has_slot_text_table
    print "HAS_SLOT_MASK_BASE=" has_slot_mask_base
    print "HAS_SLOT_FLAG_ATTR=" has_slot_flag_attr
    print "HAS_SLOT_ATTR252=" has_slot_attr252
    print "HAS_SLOT_ATTR301=" has_slot_attr301
    print "HAS_SLOT_ATTR350=" has_slot_attr350
    print "HAS_ALLOC_LINE_817=" has_alloc_line_817
    print "HAS_FREE_LINE_839=" has_free_line_839
    print "HAS_FREE_LINE_901=" has_free_line_901
    print "DECIMAL_WRITE_CALLS=" decimal_write_calls
    print "BUFFERED_WRITE_CALLS=" buffered_write_calls
    print "FREE_CALLS=" free_calls
}
