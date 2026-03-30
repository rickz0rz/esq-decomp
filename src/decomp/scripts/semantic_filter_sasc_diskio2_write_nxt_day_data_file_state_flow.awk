BEGIN {
    has_entry = 0
    has_entry_count_guard = 0
    has_save_ready_gate = 0
    has_save_ready_clear = 0
    has_alloc_call = 0
    has_alloc_fail_restore = 0
    has_open_call = 0
    has_open_fail_restore = 0
    has_open_fail_free = 0
    header_write_count = 0
    has_entry_table_lookup = 0
    has_title_table_lookup = 0
    has_entry_record_write = 0
    has_title_scan = 0
    has_title_write = 0
    has_slot_loop_limit = 0
    has_slot_ptr_guard = 0
    has_slot_mask_test = 0
    has_slot_decimal_burst = 0
    has_sanitize_gate = 0
    has_sanitize_call = 0
    has_existing_slot_ptr_path = 0
    has_slot_text_scan = 0
    has_slot_text_write = 0
    has_slot_sentinel = 0
    has_close_call = 0
    has_finalize_restore = 0
    has_finalize_free = 0
    has_zero_return = 0
    has_negative_return = 0
    has_rts = 0

    saw_entry_count_ref = 0
    saw_save_ready_test = 0
    saw_alloc_fail_flag = 0
    saw_open_fail_flag = 0
    saw_entry_ptr_test = 0
    saw_title_ptr_test = 0
    saw_slot_limit_cmp = 0
    saw_slot_ptr_access = 0
    saw_slot_mask_call = 0
    saw_sanitize_cmp = 0
    saw_title_base = 0
    saw_slot_text_base = 0
    write_buffered_count = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^DISKIO2_WRITENXTDAYDATAFILE:/ ||
        line ~ /^DISKIO2_WRITENXTDAYDATAFILE[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (index(line, "TEXTDISP_SECONDARYGROUPENTRYCOUNT") > 0) {
        saw_entry_count_ref = 1
    }
    if ((saw_entry_count_ref && (line ~ /^CMPI\.W #\$C8,D0$/ || line ~ /^CMPI\.W #200,D0$/)) ||
        line ~ /^CMPI\.W #\$C8,D0$/ || line ~ /^CMPI\.W #200,D0$/) {
        has_entry_count_guard = 1
        saw_entry_count_ref = 0
    }

    if ((index(line, "DISKIO_SAVEOPERATIONREADYFLAG") > 0 && line ~ /^TST\.L /) ||
        line ~ /^MOVE\.L __MERGEDBSS\+\$646\(A4\),D0$/) {
        saw_save_ready_test = 1
    } else if (saw_save_ready_test && line ~ /^BNE\./) {
        has_save_ready_gate = 1
        saw_save_ready_test = 0
    } else if (saw_save_ready_test && line !~ /^B/) {
        saw_save_ready_test = 0
    }

    if ((index(line, "DISKIO_SAVEOPERATIONREADYFLAG") > 0 &&
         (line ~ /^CLR\.L / || line ~ /^MOVE\.L D0,DISKIO_SAVEOPERATIONREADYFLAG$/)) ||
        line ~ /^CLR\.L __MERGEDBSS\+\$646\(A4\)$/) {
        has_save_ready_clear = 1
    }

    if (index(line, "GROUP_AG_JMPTBL_MEMORY_ALLOCATEM") > 0 ||
        index(line, "MEMORY_ALLOCATEMEMORY") > 0) {
        has_alloc_call = 1
    }

    if (index(line, "DISKIO_OPENFILEWITHBUFFER") > 0) {
        has_open_call = 1
    }

    if ((index(line, "DISKIO_SAVEOPERATIONREADYFLAG") > 0 &&
         line ~ /^MOVE\.L D0,DISKIO_SAVEOPERATIONREADYFLAG$/) ||
        line ~ /^MOVE\.L D0,__MERGEDBSS\+\$646\(A4\)$/) {
        if (!has_open_call) {
            saw_alloc_fail_flag = 1
        } else {
            saw_open_fail_flag = 1
        }
    }

    if (saw_alloc_fail_flag &&
        (line ~ /^MOVEQ #-1,D0$/ || line ~ /^MOVEQ\.L #-1,D0$/ || line ~ /^MOVEQ\.L #\$FF,D0$/)) {
        has_alloc_fail_restore = 1
        saw_alloc_fail_flag = 0
    }

    if (saw_open_fail_flag &&
        (index(line, "GROUP_AG_JMPTBL_MEMORY_DEALLOCAT") > 0 ||
         index(line, "MEMORY_DEALLOCATEMEMORY") > 0)) {
        has_open_fail_free = 1
    }
    if (saw_open_fail_flag &&
        (line ~ /^MOVEQ #-1,D0$/ || line ~ /^MOVEQ\.L #-1,D0$/ || line ~ /^MOVEQ\.L #\$FF,D0$/)) {
        has_open_fail_restore = 1
        saw_open_fail_flag = 0
    }

    if (index(line, "DISKIO_WRITEDECIMALFIELD") > 0) header_write_count++

    if (index(line, "TEXTDISP_SECONDARYENTRYPTRTABLE") > 0 ||
        line ~ /^LEA __MERGEDBSS\+\$6\(A4\),A0$/) {
        saw_entry_ptr_test = 1
    }
    if (saw_entry_ptr_test &&
        (line ~ /^MOVE\.L \(A0\),-4\(A5\)$/ || line ~ /^MOVE\.L \$0\(A0,D0\.L\),A3$/)) {
        has_entry_table_lookup = 1
        saw_entry_ptr_test = 0
    }

    if (index(line, "TEXTDISP_SECONDARYTITLEPTRTABLE") > 0 ||
        line ~ /^LEA __MERGEDBSS\+\$326\(A4\),A0$/) {
        saw_title_ptr_test = 1
    }
    if (saw_title_ptr_test &&
        (line ~ /^MOVE\.L \(A0\),-8\(A5\)$/ || line ~ /^MOVE\.L \$0\(A0,D0\.L\),A2$/)) {
        has_title_table_lookup = 1
        saw_title_ptr_test = 0
    }

    if (index(line, "DISKIO_WRITEBUFFEREDBYTES") > 0) {
        write_buffered_count++
        if (!has_entry_record_write) {
            has_entry_record_write = 1
        } else if (has_title_scan) {
            has_title_write = 1
        } else if (has_slot_text_scan) {
            has_slot_text_write = 1
        }
    }

    if (line ~ /^MOVEA?\.L -8\(A5\),A0$/ || line ~ /^MOVE\.L A2,A0$/) {
        saw_title_base = 1
    }
    if (saw_title_base && (line ~ /^TST\.B \(A0\)\+$/ || line ~ /^TST\.B \(A0\)$/)) {
        has_title_scan = 1
        saw_title_base = 0
    }

    if ((line ~ /^MOVEQ #49,D0$/ || line ~ /^MOVEQ\.L #\$31,D0$/ || line ~ /^MOVEQ\.L #49,D0$/) &&
        !has_slot_loop_limit) {
        saw_slot_limit_cmp = 1
    } else if (saw_slot_limit_cmp && line ~ /^CMP\.W D0,D6$/) {
        has_slot_loop_limit = 1
        saw_slot_limit_cmp = 0
    }

    if (line ~ /^TST\.L 56\(A0,D0\.L\)$/ || line ~ /^TST\.L \$38\(A2,D0\.L\)$/ || line ~ /^TST\.L STRUCT_/) {
        saw_slot_ptr_access = 1
    } else if (saw_slot_ptr_access && line ~ /^BEQ\./) {
        has_slot_ptr_guard = 1
        saw_slot_ptr_access = 0
    } else if (saw_slot_ptr_access && line !~ /^B/) {
        saw_slot_ptr_access = 0
    }

    if (index(line, "GROUP_AH_JMPTBL_ESQ_TESTBIT1BASED") > 0 ||
        index(line, "ESQ_TESTBIT1BASED") > 0) {
        saw_slot_mask_call = 1
    } else if (saw_slot_mask_call && (line ~ /^ADDQ\.L #1,D0$/ || line ~ /^ADDQ\.L #\$1,D0$/)) {
        has_slot_mask_test = 1
        saw_slot_mask_call = 0
    } else if (saw_slot_mask_call && line !~ /^ADDQ\.L #1,D0$/ && line !~ /^ADDQ\.L #\$1,D0$/ &&
               line !~ /^ADDQ\.W #8,A7$/ && line !~ /^ADDQ\.W #\$8,A7$/) {
        saw_slot_mask_call = 0
    }

    if ((index(line, "TEXTDISP_SECONDARYGROUPENTRYCOUNT") > 0 &&
         (line ~ /#\$64/ || line ~ /#100/)) ||
        line ~ /^MOVEQ\.L #\$64,D1$/ || line ~ /^MOVEQ #100,D1$/) {
        saw_sanitize_cmp = 1
    } else if (saw_sanitize_cmp && line ~ /^BLS\./) {
        has_sanitize_gate = 1
        saw_sanitize_cmp = 0
    } else if (saw_sanitize_cmp && line !~ /^B/) {
        saw_sanitize_cmp = 0
    }

    if (index(line, "DISKIO2_COPYANDSANITIZESLOTSTRIN") > 0 ||
        index(line, "DISKIO2_COPYANDSANITIZESLOTSTRING") > 0) {
        has_sanitize_call = 1
    }

    if (line ~ /^MOVEA\.L 56\(A0,D0\.L\),A0$/ ||
        line ~ /^MOVE\.L \$38\(A2,D0\.L\),A0$/ ||
        line ~ /^MOVE\.L A0,-12\(A5\)$/ ||
        line ~ /^MOVE\.L A0,\$24\(A7\)$/) {
        has_existing_slot_ptr_path = 1
    }

    if (line ~ /^MOVEA?\.L -12\(A5\),A0$/ || line ~ /^MOVE\.L \$24\(A7\),\$1C\(A7\)$/ || line ~ /^MOVE\.L \$1C\(A7\),A0$/) {
        saw_slot_text_base = 1
    }
    if (saw_slot_text_base && (line ~ /^TST\.B \(A0\)$/ || line ~ /^TST\.B \(A0\)\+$/)) {
        has_slot_text_scan = 1
        saw_slot_text_base = 0
    }

    if (line ~ /^MOVE\.L D6,D0$/ && has_slot_loop_limit) {
        has_slot_sentinel = 1
    }

    if (index(line, "DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0) {
        has_close_call = 1
    }

    if (has_close_call &&
        ((index(line, "DISKIO_SAVEOPERATIONREADYFLAG") > 0 &&
          line ~ /^MOVE\.L D0,DISKIO_SAVEOPERATIONREADYFLAG$/) ||
         line ~ /^MOVE\.L D0,__MERGEDBSS\+\$646\(A4\)$/)) {
        has_finalize_restore = 1
    }

    if (has_close_call &&
        (index(line, "GROUP_AG_JMPTBL_MEMORY_DEALLOCAT") > 0 ||
         index(line, "MEMORY_DEALLOCATEMEMORY") > 0)) {
        has_finalize_free = 1
    }

    if (line ~ /^MOVEQ #0,D0$/ || line ~ /^MOVEQ\.L #\$0,D0$/ || line ~ /^MOVEQ\.L #0,D0$/) {
        has_zero_return = 1
    }
    if (line ~ /^MOVEQ #-1,D0$/ || line ~ /^MOVEQ\.L #-1,D0$/ || line ~ /^MOVEQ\.L #\$FF,D0$/ || line ~ /^MOVEQ\.L #\$FFFFFFFF,D0$/) {
        has_negative_return = 1
    }
    if (line == "RTS") {
        has_rts = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_ENTRY_COUNT_GUARD=" has_entry_count_guard
    print "HAS_SAVE_READY_GATE=" has_save_ready_gate
    print "HAS_SAVE_READY_CLEAR=" has_save_ready_clear
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_FAIL_RESTORE=" has_alloc_fail_restore
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_OPEN_FAIL_RESTORE=" has_open_fail_restore
    print "HAS_OPEN_FAIL_FREE=" has_open_fail_free
    print "HAS_HEADER_WRITE_BURST=" (header_write_count >= 4)
    print "HAS_ENTRY_TABLE_LOOKUP=" has_entry_table_lookup
    print "HAS_TITLE_TABLE_LOOKUP=" has_title_table_lookup
    print "HAS_ENTRY_RECORD_WRITE=" has_entry_record_write
    print "HAS_TITLE_SCAN=" has_title_scan
    if (write_buffered_count >= 2) has_title_write = 1
    print "HAS_TITLE_WRITE=" has_title_write
    print "HAS_SLOT_LOOP_LIMIT=" has_slot_loop_limit
    print "HAS_SLOT_PTR_GUARD=" has_slot_ptr_guard
    print "HAS_SLOT_MASK_TEST=" has_slot_mask_test
    print "HAS_SLOT_DECIMAL_BURST=" (header_write_count >= 9)
    print "HAS_SANITIZE_GATE=" has_sanitize_gate
    print "HAS_SANITIZE_CALL=" has_sanitize_call
    print "HAS_EXISTING_SLOT_PTR_PATH=" has_existing_slot_ptr_path
    print "HAS_SLOT_TEXT_SCAN=" has_slot_text_scan
    if (write_buffered_count >= 3) has_slot_text_write = 1
    print "HAS_SLOT_TEXT_WRITE=" has_slot_text_write
    print "HAS_SLOT_SENTINEL=" has_slot_sentinel
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_FINALIZE_RESTORE=" has_finalize_restore
    print "HAS_FINALIZE_FREE=" has_finalize_free
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_NEGATIVE_RETURN=" has_negative_return
    print "HAS_RTS=" has_rts
}
