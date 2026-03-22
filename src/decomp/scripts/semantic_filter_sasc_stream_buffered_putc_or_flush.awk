BEGIN {
    has_entry=0
    has_ensure_alloc=0
    seek_calls=0
    read_calls=0
    write_calls=0
    recurse_calls=0
    has_mode_flags=0
    has_state_flags=0
    has_write_remaining=0
    has_buffer_cursor=0
    has_write_reject=0
    has_flush_reject=0
    has_const31=0
    has_const30=0
    has_const1a=0
    has_const0a=0
    has_const0d=0
    has_movep_callback=0
    has_text_translate_test=0
    has_unbuffered_test=0
    has_prewrite_scan_gate=0
    has_pending_write_set=0
    has_short_write_set=0
    has_io_error_set=0
    has_cr_store=0
    has_buffer_cursor_reset=0
    has_flush_zero_return=0
    has_byte_return=0
    has_rts=0
    saw_reset_base_to_a0=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^STREAM_BUFFEREDPUTCORFLUSH:/ || u ~ /^STREAM_BUFFEREDPUTCORFLUSH[A-Z0-9_]*:/) has_entry=1
    if (n ~ /BUFFERENSUREALLOCATED/) has_ensure_alloc=1
    if (n ~ /DOSSEEKBYINDEX/) seek_calls+=1
    if (n ~ /DOSREADBYINDEX/) read_calls+=1
    if (n ~ /DOSWRITEBYINDEX/) write_calls+=1
    if ((n ~ /BSRWSTREAMBUFFEREDPUTCORFLUSH/) || (n ~ /JSRSTREAMBUFFEREDPUTCORFLUSH/)) recurse_calls+=1
    if (n ~ /MODEFLAGS/ || u ~ /^LEA \$2\(A0\),A2$/) has_mode_flags=1
    if (n ~ /STATEFLAGS/ || u ~ /^LEA \$1\(A2\),A3$/) has_state_flags=1
    if (n ~ /WRITEREMAINING/ || n ~ /12A3/ || n ~ /12A5/ || n ~ /CA3/ || n ~ /CA5/) has_write_remaining=1
    if (n ~ /BUFFERCURSOR/ || n ~ /4A3/ || n ~ /4A5/) has_buffer_cursor=1
    if (n ~ /OPENMASKWRITEREJECT/ || u ~ /#\$31/ || u ~ /#49([^0-9]|$)/) has_write_reject=1
    if (n ~ /OPENMASKFLUSHREJECT/ || u ~ /#\$30/ || u ~ /#48([^0-9]|$)/) has_flush_reject=1
    if (u ~ /#\$31/ || u ~ /#49([^0-9]|$)/ || n ~ /OPENMASKWRITEREJECT/) has_const31=1
    if (u ~ /#\$30/ || u ~ /#48([^0-9]|$)/ || n ~ /OPENMASKFLUSHREJECT/) has_const30=1
    if (u ~ /#\$1A/ || u ~ /#26([^0-9]|$)/) has_const1a=1
    if (u ~ /#\$0A/ || u ~ /#\$A/ || u ~ /#10([^0-9]|$)/) has_const0a=1
    if (u ~ /#\$0D/ || u ~ /#\$D/ || u ~ /#13([^0-9]|$)/) has_const0d=1
    if (n ~ /DOSMOVEPWORDREADCALLBACK/) has_movep_callback=1
    if (n ~ /MODEFLAGTEXTTRANSLATE/ || u ~ /^BTST #\$7,\(A2\)$/) has_text_translate_test=1
    if (n ~ /OPENFLAGSLOWBIT2UNBUFFERED/ || u ~ /^BTST #\$2,\(A3\)$/) has_unbuffered_test=1
    if (n ~ /MODEFLAGPREWRITESCAN/ || u ~ /^BTST #\$6,\(A2\)$/) has_prewrite_scan_gate=1
    if (n ~ /OPENFLAGSLOWBIT1WRITEPENDING/ || u ~ /^BSET #\$1,\(A3\)$/ || u ~ /^BSET #1,\(A3\)$/) has_pending_write_set=1
    if (n ~ /OPENFLAGSLOWBIT4EOFORSHORT/ || u ~ /^BSET #\$4,\(A3\)$/ || u ~ /^BSET #4,\(A3\)$/) has_short_write_set=1
    if (n ~ /OPENFLAGSLOWBIT5IOERROR/ || u ~ /^BSET #\$5,\(A3\)$/ || u ~ /^BSET #5,\(A3\)$/) has_io_error_set=1
    if (u ~ /^MOVE\.B #\$D,\(A0\)$/ || u ~ /^MOVE\.B #\$0D,\(A0\)$/ || n ~ /MOVEB0DA0/) has_cr_store=1
    if (n ~ /BUFFERCURSOR/ && n ~ /BUFFERBASE/) has_buffer_cursor_reset=1
    if (u ~ /^MOVE\.L \$10\(A5\),\$4\(A5\)$/) has_buffer_cursor_reset=1
    if (u ~ /^MOVEA\.L STRUCT_PREALLOCHANDLENODE__BUFFERBASE\(A3\),A0$/) saw_reset_base_to_a0=1
    if (saw_reset_base_to_a0 &&
        u ~ /^MOVE\.L A0,STRUCT_PREALLOCHANDLENODE__BUFFERCURSOR\(A3\)$/) has_buffer_cursor_reset=1
    if (u ~ /^MOVEQ\.L #\$0,D0$/ || u ~ /^MOVEQ #0,D0$/) has_flush_zero_return=1
    if (u ~ /^MOVE\.B D0,D1$/ || u ~ /^MOVE\.L D1,D0$/ || u ~ /^MOVE\.L D4,D0$/) has_byte_return=1
    if (u == "RTS") has_rts=1

    prev_u=u
    prev_n=n
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_ENSURE_ALLOCATED_CALL="has_ensure_alloc
    print "COUNT_DOS_SEEK_CALLS="seek_calls
    print "COUNT_DOS_READ_CALLS="read_calls
    print "COUNT_DOS_WRITE_CALLS="write_calls
    print "COUNT_RECURSE_CALLS="recurse_calls
    print "HAS_MODE_FLAGS_ACCESS="has_mode_flags
    print "HAS_STATE_FLAGS_ACCESS="has_state_flags
    print "HAS_WRITE_REMAINING_ACCESS="has_write_remaining
    print "HAS_BUFFER_CURSOR_ACCESS="has_buffer_cursor
    print "HAS_WRITE_REJECT_MASK="has_write_reject
    print "HAS_FLUSH_REJECT_MASK="has_flush_reject
    print "HAS_CONST_31="has_const31
    print "HAS_CONST_30="has_const30
    print "HAS_CONST_1A="has_const1a
    print "HAS_CONST_0A="has_const0a
    print "HAS_CONST_0D="has_const0d
    print "HAS_MOVEP_CALLBACK_WRITE="has_movep_callback
    print "HAS_TEXT_TRANSLATE_TEST="has_text_translate_test
    print "HAS_UNBUFFERED_TEST="has_unbuffered_test
    print "HAS_PREWRITE_SCAN_GATE="has_prewrite_scan_gate
    print "HAS_PENDING_WRITE_SET="has_pending_write_set
    print "HAS_SHORT_WRITE_SET="has_short_write_set
    print "HAS_IO_ERROR_SET="has_io_error_set
    print "HAS_CR_STORE="has_cr_store
    print "HAS_BUFFER_CURSOR_RESET="has_buffer_cursor_reset
    print "HAS_FLUSH_ZERO_RETURN="has_flush_zero_return
    print "HAS_BYTE_RETURN="has_byte_return
    print "HAS_RTS="has_rts
}
