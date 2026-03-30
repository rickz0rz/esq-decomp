BEGIN {
    has_entry = 0

    has_guard_sequence = 0
    saw_entry_count_guard = 0
    saw_save_ready_guard = 0

    has_alloc_path = 0
    saw_ready_flag_reset = 0
    saw_zero_scratch_seed = 0
    saw_alloc_call = 0
    saw_alloc_fail_restore = 0
    saw_open_fail_restore = 0
    saw_finalize_ready_restore = 0
    saw_fail_return_neg1 = 0

    has_open_fail_cleanup = 0
    saw_open_call = 0
    saw_open_fail_free = 0

    has_header_sequence = 0
    header_write_count = 0
    saw_label_scan = 0
    saw_status_fallback = 0
    saw_status_scan = 0

    has_group_fields = 0
    group_decimal_count = 0
    saw_group_code = 0
    saw_group_count = 0
    saw_group_checksum = 0
    saw_group_length = 0

    has_entry_loop = 0
    saw_entry_loop_guard = 0
    in_entry_ptr_window = 0
    in_title_ptr_window = 0
    saw_entry_ptr_load = 0
    saw_title_ptr_load = 0
    saw_entry_block_write = 0
    saw_title_scan = 0

    has_slot_loop = 0
    saw_slot_loop_guard = 0
    saw_slot_index_write = 0
    saw_slot_flag_write = 0
    saw_slot_attr252_write = 0
    saw_slot_attr301_write = 0
    saw_slot_attr350_write = 0
    saw_slot_ptr_guard = 0
    saw_test_bit_call = 0
    saw_slot_skip = 0
    saw_sanitize_gate = 0
    saw_sanitize_call = 0
    saw_existing_ptr_path = 0
    saw_slot_text_scan = 0
    saw_slot_text_write = 0
    saw_slot_sentinel = 0

    has_finalize_sequence = 0
    saw_close = 0
    saw_ready_flag_restore = 0
    saw_free = 0
    saw_success_return_zero = 0
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
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^DISKIO2_WRITECURDAYDATAFILE:/ ||
        u ~ /^DISKIO2_WRITECURDAYDATAFILE[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ ||
        (u ~ /__MERGEDBSS/ && u ~ /86\(A4\)/) ||
        u ~ /CMPI\.W #\$C8,D0/ || u ~ /CMPI\.W #200,D0/) {
        saw_entry_count_guard = 1
    }
    if ((u ~ /DISKIO_SAVEOPERATIONREADYFLAG/ ||
         (u ~ /__MERGEDBSS/ && u ~ /6CC\(A4\)/)) &&
        (u ~ /TST\.L/ || u ~ /TST\.W/ || u ~ /MOVE\.L/)) {
        saw_save_ready_guard = 1
    }
    if (saw_entry_count_guard && saw_save_ready_guard) {
        has_guard_sequence = 1
    }

    if (u ~ /DISKIO_SAVEOPERATIONREADYFLAG/ &&
        (u ~ /CLR\.L/ || u ~ /CLR\.W/ || u ~ /MOVEQ #0/ || u ~ /MOVE\.L #0/)) {
        saw_ready_flag_reset = 1
    }
    if (u ~ /CLR\.B/ && (u ~ /-17\(A5\)/ || u ~ /2C\(A7\)/)) {
        saw_zero_scratch_seed = 1
    }
    if (u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCAT/ ||
        u ~ /MEMORY_ALLOCATEM/) {
        saw_alloc_call = 1
    }
    if ((u ~ /DISKIO_SAVEOPERATIONREADYFLAG/ ||
         (u ~ /__MERGEDBSS/ && u ~ /6CC\(A4\)/)) &&
        !(u ~ /CLR\./) && !(u ~ /TST\./)) {
        if (saw_close) {
            saw_finalize_ready_restore = 1
        } else if (saw_open_call) {
            saw_open_fail_restore = 1
        } else if (saw_alloc_call) {
            saw_alloc_fail_restore = 1
        }
    }
    if ((u ~ /^MOVE\.L D0,DISKIO_SAVEOPERATIONREADYFLAG$/ ||
         u ~ /^MOVE\.L D0,__MERGEDBSS\+\$6CC\(A4\)$/ ||
         u ~ /^MOVE\.L #1,DISKIO_SAVEOPERATIONREADYFLAG$/ ||
         u ~ /^MOVE\.L #\$1,__MERGEDBSS\+\$6CC\(A4\)$/)) {
        if (saw_close) {
            saw_finalize_ready_restore = 1
        } else if (saw_open_call) {
            saw_open_fail_restore = 1
        } else if (saw_alloc_call) {
            saw_alloc_fail_restore = 1
        }
    }
    if (u ~ /MOVEQ #\-1,D0/ || u ~ /MOVEQ\.L #\$FF,D0/) {
        saw_fail_return_neg1 = 1
    }

    if (u ~ /DISKIO_OPENFILEWITHBUFFER/) {
        saw_open_call = 1
    }
    if ((u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/ ||
         u ~ /MEMORY_DEALLOCAT/) && saw_open_call) {
        saw_open_fail_free = 1
    }

    if (u ~ /DISKIO_WRITEBUFFEREDBYTES/ || u ~ /DISKIO_WRITEDECIMALFIELD/) {
        header_write_count++
    }
    if ((u ~ /WDISP_WEATHERSTATUSLABELBUFFER/ ||
         (u ~ /__MERGEDBSS/ && u ~ /2\(A4\)/)) &&
        (u ~ /LEA/ || u ~ /MOVEA\.L/)) {
        saw_label_scan = 1
    }
    if (u ~ /WDISP_WEATHERSTATUSTEXTPTR/ ||
        u ~ /LEA -17\(A5\),A0/ || u ~ /MOVE\.L A0,-12\(A5\)/ ||
        u ~ /LEA \$2C\(A7\),A2/ || u ~ /MOVE\.L A2,\$30\(A7\)/ ||
        (u ~ /__MERGEDBSS/ && u ~ /82\(A4\)/)) {
        saw_status_fallback = 1
    }
    if ((u ~ /TST\.B \(A[01]\)\+/ || u ~ /TST\.B \(A[01]\)/) &&
        (saw_label_scan || saw_status_fallback)) {
        saw_status_scan = 1
    }
    if (header_write_count >= 7 && saw_label_scan && saw_status_fallback && saw_status_scan) {
        has_header_sequence = 1
    }

    if (u ~ /TEXTDISP_PRIMARYGROUPCODE/ || (u ~ /__MERGEDBSS/ && u ~ /88\(A4\)/)) saw_group_code = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || (u ~ /__MERGEDBSS/ && u ~ /86\(A4\)/)) saw_group_count = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPRECORDCHECKSUM/ || (u ~ /__MERGEDBSS/ && u ~ /89\(A4\)/)) saw_group_checksum = 1
    if (u ~ /TEXTDISP_PRIMARYGROUPRECORDLENGTH/ || (u ~ /__MERGEDBSS/ && u ~ /8A\(A4\)/)) saw_group_length = 1
    if (u ~ /DISKIO_WRITEDECIMALFIELD/ &&
        (saw_group_code || saw_group_count || saw_group_checksum || saw_group_length)) {
        group_decimal_count++
    }
    if (group_decimal_count >= 4 && saw_group_code && saw_group_count &&
        saw_group_checksum && saw_group_length) {
        has_group_fields = 1
    }

    if (u ~ /WRITECUR_ENTRY_LOOP:/ ||
        ((u ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || (u ~ /__MERGEDBSS/ && u ~ /86\(A4\)/)) && u ~ /CMP\.W D0,D7/) ||
        u ~ /CMP\.W D0,D7/) {
        saw_entry_loop_guard = 1
    }
    if (u ~ /^LEA TEXTDISP_PRIMARYENTRYPTRTABLE,A0$/ ||
        u ~ /^LEA __MERGEDBSS\+\$8C\(A4\),A0$/) {
        in_entry_ptr_window = 1
    }
    if (u ~ /^LEA TEXTDISP_PRIMARYTITLEPTRTABLE,A0$/ ||
        u ~ /^LEA __MERGEDBSS\+\$3AC\(A4\),A1$/) {
        in_title_ptr_window = 1
    }
    if ((u ~ /MOVE\.L \(A0\),-4\(A5\)/ || u ~ /MOVE\.L \(A0\),\$28\(A7\)/ ||
         u ~ /MOVE\.L \$0\(A0,D0\.L\),A0/) &&
        (in_entry_ptr_window || u ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || (u ~ /__MERGEDBSS/ && u ~ /8C\(A4\)/))) {
        saw_entry_ptr_load = 1
        in_entry_ptr_window = 0
    }
    if ((u ~ /MOVE\.L \(A0\),-8\(A5\)/ || u ~ /MOVE\.L \(A1,D0\.L\),\$30\(A7\)/ || u ~ /MOVE\.L \$0\(A1,D0\.L\),\$30\(A7\)/) &&
        (in_title_ptr_window || u ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/ || (u ~ /__MERGEDBSS/ && u ~ /3AC\(A4\)/))) {
        saw_title_ptr_load = 1
        in_title_ptr_window = 0
    }
    if (u ~ /PEA 48\.W/ || u ~ /PEA \(\$30\)\.W/) {
        saw_entry_block_write = 1
    }
    if ((u ~ /TST\.B \(A0\)\+/ || u ~ /TST\.B \(A1\)\+/ ||
         u ~ /TST\.B \(A0\)/ || u ~ /TST\.B \(A1\)/) && saw_title_ptr_load) {
        saw_title_scan = 1
    }
    if (saw_entry_loop_guard && saw_entry_ptr_load && saw_title_ptr_load &&
        saw_entry_block_write && saw_title_scan) {
        has_entry_loop = 1
    }

    if (u ~ /WRITECUR_SLOT_LOOP:/ ||
        (u ~ /CMP\.W D0,D6/ && (u ~ /#49/ || u ~ /#\$31/ || u ~ /MOVEQ #49,D0/ || u ~ /MOVEQ\.L #\$31,D0/))) {
        saw_slot_loop_guard = 1
    }
    if (u ~ /SLOTTEXTTABLE/ || u ~ /TST\.L 56\(A0,D0\.L\)/ || u ~ /TST\.L \$38\(A0,D0\.L\)/ ||
        u ~ /MOVEA\.L 56\(A0,D0\.L\),A0/ || u ~ /MOVE\.L \$38\(A0,D0\.L\),A0/) {
        saw_slot_ptr_guard = 1
    }
    if (u ~ /ESQ_TESTBIT1BASED/ || u ~ /GROUP_AH_JMPTBL_ESQ_TESTBIT1BASED/) {
        saw_test_bit_call = 1
    }
    if ((u ~ /^BEQ\./ || u ~ /^BNE\./ || u ~ /^BEQ / || u ~ /^BNE /) && saw_test_bit_call) {
        saw_slot_skip = 1
    }
    if (u ~ /DISKIO_WRITEDECIMALFIELD/ && saw_test_bit_call) {
        if (!saw_slot_index_write) {
            saw_slot_index_write = 1
        } else if (!saw_slot_flag_write) {
            saw_slot_flag_write = 1
        } else if (!saw_slot_attr252_write && (u ~ /DISKIO_WRITEDECIMALFIELD/ || u ~ /ADD\.L #\$FC,D2/ || u ~ /ADDI\.W #\$FC,D1/)) {
            saw_slot_attr252_write = 1
        } else if (!saw_slot_attr301_write && (u ~ /DISKIO_WRITEDECIMALFIELD/ || u ~ /ADD\.L #\$12D,D2/ || u ~ /ADDI\.W #\$12D,D1/)) {
            saw_slot_attr301_write = 1
        } else if (!saw_slot_attr350_write && (u ~ /DISKIO_WRITEDECIMALFIELD/ || u ~ /ADD\.L #\$15E,D2/ || u ~ /ADDI\.W #\$15E,D1/)) {
            saw_slot_attr350_write = 1
        }
    }
    if (u ~ /MOVE\.B 7\(A0,D6\.W\),D0/ || u ~ /MOVE\.B \$7\(A0,D0\.L\),D5/) {
        saw_slot_flag_write = 1
    }
    if (u ~ /ADD\.L #\$FC,D2/ || u ~ /ADDI\.W #\$FC,D1/) saw_slot_attr252_write = 1
    if (u ~ /ADD\.L #\$12D,D2/ || u ~ /ADDI\.W #\$12D,D1/) saw_slot_attr301_write = 1
    if (u ~ /ADD\.L #\$15E,D2/ || u ~ /ADDI\.W #\$15E,D1/) saw_slot_attr350_write = 1
    if (u ~ /CMPI\.W #\$64,D[0-7]/ || u ~ /CMPI\.W #100,D[0-7]/ || u ~ /MOVEQ\.L #\$64,D1/) {
        saw_sanitize_gate = 1
    }
    if (u ~ /DISKIO2_COPYANDSANITIZESLOTSTRING/ ||
        u ~ /DISKIO2_COPYANDSANITIZESLOTSTRIN/) {
        saw_sanitize_call = 1
    }
    if (u ~ /MOVEA\.L 56\(A0,D0\.L\),A0/ || u ~ /MOVE\.L \$38\(A0,D0\.L\),A0/ ||
        u ~ /MOVE\.L A0,-12\(A5\)/ || u ~ /MOVE\.L A0,\$28\(A7\)/) {
        saw_existing_ptr_path = 1
    }
    if ((u ~ /TST\.B \(A0\)\+/ || u ~ /TST\.B \(A1\)\+/) &&
        (saw_sanitize_call || saw_existing_ptr_path)) {
        saw_slot_text_scan = 1
    }
    if (u ~ /DISKIO_WRITEBUFFEREDBYTES/ &&
        !(u ~ /ESQ_STR_B/) && !(u ~ /GLOBAL_STR_DREV_5_1/)) {
        saw_slot_text_write = 1
    }
    if (u ~ /MOVE\.L D6,D0/ && saw_slot_loop_guard) {
        saw_slot_sentinel = 1
    }
    if (saw_slot_loop_guard && saw_slot_ptr_guard && saw_test_bit_call &&
        saw_slot_skip && saw_slot_index_write && saw_slot_flag_write &&
        saw_sanitize_gate && saw_sanitize_call &&
        saw_slot_text_write && saw_slot_sentinel) {
        has_slot_loop = 1
    }

    if (u ~ /DISKIO_CLOSEBUFFEREDFILEANDFLUSH/) {
        saw_close = 1
    }
    if ((u ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/ ||
         u ~ /MEMORY_DEALLOCAT/) && saw_close) {
        saw_free = 1
    }
    if ((u ~ /MOVEQ #0,D0/ || u ~ /MOVEQ\.L #\$0,D0/) && saw_close) {
        saw_success_return_zero = 1
    }
}

END {
    has_alloc_path = (saw_alloc_call && saw_fail_return_neg1)
    has_open_fail_cleanup = (saw_open_call && saw_open_fail_restore &&
        saw_open_fail_free && saw_fail_return_neg1)
    has_finalize_sequence = (saw_close && saw_finalize_ready_restore &&
        saw_free && saw_success_return_zero)

    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD_SEQUENCE=" has_guard_sequence
    print "HAS_ALLOC_PATH=" has_alloc_path
    print "HAS_OPEN_FAIL_CLEANUP=" has_open_fail_cleanup
    print "HAS_HEADER_SEQUENCE=" has_header_sequence
    print "HAS_GROUP_FIELDS=" has_group_fields
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_SLOT_LOOP=" has_slot_loop
    print "HAS_FINALIZE_SEQUENCE=" has_finalize_sequence
}
