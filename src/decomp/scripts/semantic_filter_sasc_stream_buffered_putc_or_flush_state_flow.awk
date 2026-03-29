BEGIN {
    has_entry = 0

    write_reject_stage = 0
    has_write_reject_flow = 0

    has_text_translate_bool = 0
    has_ensure_alloc_call = 0
    has_ensure_alloc_error = 0
    has_pending_write_set = 0
    has_negative_write_budget = 0
    has_positive_write_budget = 0

    recurse_calls = 0
    write_calls = 0
    seek_calls = 0
    read_calls = 0

    direct_stage = 0
    has_direct_lf_callback_flow = 0

    buffered_cr_stage = 0
    has_buffered_cr_flush_flow = 0

    scan_stage = 0
    has_ctrl_z_scan_flow = 0

    has_pending_count_calc = 0
    has_status_io_error = 0
    has_status_short_write = 0

    has_reset_write_remaining = 0
    has_reset_buffer_cursor = 0
    has_retry_after_reset = 0

    flush_reject_stage = 0
    has_flush_reject_flow = 0
    has_flush_zero_return = 0
    has_byte_return = 0
    has_rts = 0

    saw_reset_base_to_a0 = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^STREAM_BUFFEREDPUTCORFLUSH[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /DOSWRITEBYINDEX/) {
        write_calls += 1
    }
    if (n ~ /DOSSEEKBYINDEX/) {
        seek_calls += 1
    }
    if (n ~ /DOSREADBYINDEX/) {
        read_calls += 1
    }
    if (n ~ /BSRWSTREAMBUFFEREDPUTCORFLUSH/ || n ~ /JSRSTREAMBUFFEREDPUTCORFLUSH/) {
        recurse_calls += 1
    }

    if (u ~ /^MOVEQ(\.L)? #STRUCT_PREALLOCHANDLENODE_OPENMASK_WRITEREJECT,D0$/ ||
        u ~ /^MOVEQ(\.L)? #\$31,D0$/ ||
        u ~ /^MOVEQ(\.L)? #49,D0$/) {
        write_reject_stage = 1
    } else if (write_reject_stage == 1 &&
               (u ~ /^AND\.L STRUCT_PREALLOCHANDLENODE__OPENFLAGS\(A3\),D0$/ ||
                u ~ /^AND\.L \$18\(A5\),D0$/)) {
        write_reject_stage = 2
    } else if (write_reject_stage == 2 &&
               (u ~ /^MOVEQ(\.L)? #\-1,D0$/ ||
                u ~ /^MOVEQ(\.L)? #\$FF,D0$/)) {
        has_write_reject_flow = 1
    }

    if ((u ~ /^BTST #STRUCT_PREALLOCHANDLENODE_MODEFLAG_TEXTTRANSLATE_BIT,STRUCT_PREALLOCHANDLENODE__MODEFLAGS\(A3\)$/ ||
         u ~ /^BTST #\$7,\(A2\)$/) &&
        has_text_translate_bool == 0) {
        has_text_translate_bool = 1
    }
    if (n ~ /BUFFERENSUREALLOCATED/) {
        has_ensure_alloc_call = 1
    }
    if ((u ~ /^BSET #STRUCT_PREALLOCHANDLENODE_OPENFLAGSLOWBIT5_IOERROR_BIT,STRUCT_PREALLOCHANDLENODE__STATEFLAGS\(A3\)$/ ||
         u ~ /^BSET #\$5,\(A3\)$/) &&
        has_ensure_alloc_call) {
        has_ensure_alloc_error = 1
    }
    if (u ~ /^BSET #STRUCT_PREALLOCHANDLENODE_OPENFLAGSLOWBIT1_WRITEPENDING_BIT,STRUCT_PREALLOCHANDLENODE__STATEFLAGS\(A3\)$/ ||
        u ~ /^BSET #\$1,\(A3\)$/ ||
        u ~ /^BSET #1,\(A3\)$/) {
        has_pending_write_set = 1
    }
    if (u ~ /^NEG\.L D1$/ || u ~ /^NEG\.L D2$/) {
        has_negative_write_budget = 1
    }
    if (u ~ /^MOVE\.L STRUCT_PREALLOCHANDLENODE__BUFFERCAPACITY\(A3\),STRUCT_PREALLOCHANDLENODE__WRITEREMAINING\(A3\)$/ ||
        u ~ /^MOVE\.L \$14\(A5\),\$C\(A5\)$/) {
        has_positive_write_budget = 1
    }

    if (u ~ /^MOVE\.B D0,\-1\(A5\)$/ || u ~ /^MOVE\.B D0,\$23\(A7\)$/) {
        direct_stage = 1
    } else if (direct_stage == 1 &&
               (u ~ /^MOVEQ(\.L)? #10,D1$/ || u ~ /^MOVEQ(\.L)? #\$A,D1$/)) {
        direct_stage = 2
    } else if (direct_stage == 2 &&
               (u ~ /^MOVEQ(\.L)? #2,D1$/ || u ~ /^PEA \(\$2\)\.W$/)) {
        direct_stage = 3
    } else if (direct_stage >= 2 && n ~ /DOSMOVEPWORDREADCALLBACK/) {
        direct_stage = 4
    } else if (direct_stage >= 3 && n ~ /DOSWRITEBYINDEX/) {
        has_direct_lf_callback_flow = 1
    }

    if (u ~ /^ADDQ\.L #2,STRUCT_PREALLOCHANDLENODE__WRITEREMAINING\(A3\)$/ ||
        u ~ /^ADDQ\.L #\$2,\$C\(A5\)$/ ||
        u ~ /^ADDQ\.L #2,\$C\(A5\)$/) {
        buffered_cr_stage = 1
    } else if (buffered_cr_stage == 1 &&
               (u ~ /^MOVE\.B #\$D,\(A0\)$/ || u ~ /^MOVE\.B #\$0D,\(A0\)$/)) {
        buffered_cr_stage = 2
    } else if (buffered_cr_stage == 2 &&
               (u ~ /^MOVE\.L A3,\-\(A7\)$/ || u ~ /^MOVE\.L A5,\-\(A7\)$/)) {
        buffered_cr_stage = 3
    } else if (buffered_cr_stage == 3 &&
               (u ~ /^MOVE\.L D0,\-\(A7\)$/ || u ~ /^CLR\.L \-\(A7\)$/)) {
        buffered_cr_stage = 4
    } else if (buffered_cr_stage == 4 &&
               (n ~ /BSRWSTREAMBUFFEREDPUTCORFLUSH/ || n ~ /JSRSTREAMBUFFEREDPUTCORFLUSH/)) {
        has_buffered_cr_flush_flow = 1
    }

    if (u ~ /^MOVE\.L STRUCT_PREALLOCHANDLENODE__BUFFERCURSOR\(A3\),D0$/ ||
        u ~ /^MOVE\.L \$4\(A5\),D0$/) {
        scan_stage = 1
    } else if (scan_stage == 1 &&
               (u ~ /^SUB\.L STRUCT_PREALLOCHANDLENODE__BUFFERBASE\(A3\),D0$/ ||
                u ~ /^SUB\.L \$10\(A5\),D0$/)) {
        has_pending_count_calc = 1
        scan_stage = 2
    } else if (scan_stage >= 2 &&
               (u ~ /^BTST #STRUCT_PREALLOCHANDLENODE_MODEFLAG_PREWRITESCAN_BIT,STRUCT_PREALLOCHANDLENODE__MODEFLAGS\(A3\)$/ ||
                u ~ /^BTST #\$6,\(A2\)$/)) {
        scan_stage = 3
    } else if (scan_stage >= 3 && seek_calls >= 1 && read_calls >= 1 &&
               u ~ /^TST\.L GLOBAL_DOSIOERR\(A4\)$/) {
        scan_stage = 4
    } else if (scan_stage == 4 &&
               (u ~ /^MOVEQ(\.L)? #26,D1$/ || u ~ /^MOVEQ(\.L)? #\$1A,D1$/)) {
        scan_stage = 5
    } else if (scan_stage == 5 &&
               u ~ /^CMP\.B D1,D0$/) {
        has_ctrl_z_scan_flow = 1
    }

    if (u ~ /^BSET #STRUCT_PREALLOCHANDLENODE_OPENFLAGSLOWBIT5_IOERROR_BIT,STRUCT_PREALLOCHANDLENODE__STATEFLAGS\(A3\)$/ ||
        u ~ /^BSET #\$5,\(A3\)$/) {
        has_status_io_error = 1
    }
    if (u ~ /^BSET #STRUCT_PREALLOCHANDLENODE_OPENFLAGSLOWBIT4_EOFORSHORT_BIT,STRUCT_PREALLOCHANDLENODE__STATEFLAGS\(A3\)$/ ||
        u ~ /^BSET #\$4,\(A3\)$/) {
        has_status_short_write = 1
    }

    if (u ~ /^MOVE\.L STRUCT_PREALLOCHANDLENODE__BUFFERCAPACITY\(A3\),D1$/ ||
        u ~ /^MOVE\.L \$14\(A5\),D1$/ ||
        u ~ /^MOVEQ(\.L)? #0,D1$/ ||
        u ~ /^MOVEQ(\.L)? #0,D0$/ ||
        u ~ /^CLR\.L \$C\(A5\)$/) {
        has_reset_write_remaining = 1
    }
    if (u ~ /^MOVEA\.L STRUCT_PREALLOCHANDLENODE__BUFFERBASE\(A3\),A0$/) {
        saw_reset_base_to_a0 = 1
    }
    if (u ~ /^MOVE\.L A0,STRUCT_PREALLOCHANDLENODE__BUFFERCURSOR\(A3\)$/ ||
        u ~ /^MOVE\.L \$10\(A5\),\$4\(A5\)$/ ||
        (saw_reset_base_to_a0 && u ~ /^MOVE\.L A0,STRUCT_PREALLOCHANDLENODE__BUFFERCURSOR\(A3\)$/)) {
        has_reset_buffer_cursor = 1
    }
    if ((u ~ /^SUBQ\.L #1,STRUCT_PREALLOCHANDLENODE__WRITEREMAINING\(A3\)$/ ||
         u ~ /^SUBQ\.L #\$1,\$C\(A5\)$/ ||
         u ~ /^SUBQ\.L #1,\$C\(A5\)$/) &&
        has_reset_buffer_cursor) {
        has_retry_after_reset = 1
    }

    if (u ~ /^MOVEQ(\.L)? #STRUCT_PREALLOCHANDLENODE_OPENMASK_FLUSHREJECT,D0$/ ||
        u ~ /^MOVEQ(\.L)? #\$30,D0$/ ||
        u ~ /^MOVEQ(\.L)? #48,D0$/) {
        flush_reject_stage = 1
    } else if (flush_reject_stage == 1 &&
               (u ~ /^AND\.L STRUCT_PREALLOCHANDLENODE__OPENFLAGS\(A3\),D0$/ ||
                u ~ /^AND\.L \$18\(A5\),D0$/)) {
        flush_reject_stage = 2
    } else if (flush_reject_stage == 2 &&
               (u ~ /^MOVEQ(\.L)? #\-1,D0$/ ||
                u ~ /^MOVEQ(\.L)? #\$FF,D0$/)) {
        has_flush_reject_flow = 1
    }

    if (u ~ /^MOVEQ(\.L)? #0,D0$/ || u ~ /^MOVEQ(\.L)? #\$0,D0$/ || u ~ /^MOVEQ #0,D0$/) {
        has_flush_zero_return = 1
    }
    if (u ~ /^MOVE\.L D4,D0$/ || u ~ /^MOVE\.L D7,D0$/ || u ~ /^MOVE\.L D1,D0$/) {
        has_byte_return = 1
    }
    if (u == "RTS") {
        has_rts = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_WRITE_REJECT_FLOW=" has_write_reject_flow
    print "HAS_TEXT_TRANSLATE_BOOL=" has_text_translate_bool
    print "HAS_ENSURE_ALLOC_CALL=" has_ensure_alloc_call
    print "HAS_ENSURE_ALLOC_ERROR=" has_ensure_alloc_error
    print "HAS_PENDING_WRITE_SET=" has_pending_write_set
    print "HAS_NEGATIVE_WRITE_BUDGET=" has_negative_write_budget
    print "HAS_POSITIVE_WRITE_BUDGET=" has_positive_write_budget
    print "COUNT_RECURSE_CALLS=" recurse_calls
    print "COUNT_DOS_WRITE_CALLS=" write_calls
    print "COUNT_DOS_SEEK_CALLS=" seek_calls
    print "COUNT_DOS_READ_CALLS=" read_calls
    print "HAS_DIRECT_LF_CALLBACK_FLOW=" has_direct_lf_callback_flow
    print "HAS_BUFFERED_CR_FLUSH_FLOW=" has_buffered_cr_flush_flow
    print "HAS_PENDING_COUNT_CALC=" has_pending_count_calc
    print "HAS_CTRL_Z_SCAN_FLOW=" has_ctrl_z_scan_flow
    print "HAS_STATUS_IO_ERROR=" has_status_io_error
    print "HAS_STATUS_SHORT_WRITE=" has_status_short_write
    print "HAS_RESET_WRITE_REMAINING=" has_reset_write_remaining
    print "HAS_RESET_BUFFER_CURSOR=" has_reset_buffer_cursor
    print "HAS_RETRY_AFTER_RESET=" has_retry_after_reset
    print "HAS_FLUSH_REJECT_FLOW=" has_flush_reject_flow
    print "HAS_FLUSH_ZERO_RETURN=" has_flush_zero_return
    print "HAS_BYTE_RETURN=" has_byte_return
    print "HAS_RTS=" has_rts
}
