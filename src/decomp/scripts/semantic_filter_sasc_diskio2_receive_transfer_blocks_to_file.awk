BEGIN {
    has_entry = 0
    has_crc_table_copy = 0
    has_wait = 0
    has_read_serial = 0
    has_attempt_count = 0
    has_seq_check = 0
    has_replay_fast_return = 0
    has_xor_update = 0
    has_payload_crc_fold = 0
    has_crc32_optional = 0
    has_record_checksum_check = 0
    has_flush_write = 0
    has_eof_complete = 0
    has_seq_advance = 0
    has_crc_error_reset = 0
    has_overlay_error = 0
    has_crc_error_count = 0
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
    if (line ~ /DISKIO2_RECEIVETRANSFERBLOCKSTO/) has_entry = 1

    if ((line ~ /TRANSFERCRC32TABLE/ && line ~ /LEA/) ||
        (line ~ /MOVE\.L \(A0\)\+,\(A1\)\+/) ||
        (line ~ /MOVE\.L \$0\(A0,D1\.L\),\$2C\(A7,D1\.L\)/)) {
        has_crc_table_copy = 1
    }
    if (line ~ /WAITFORCLOCKCHANGEANDSERVICEUI/ || line ~ /WAITFORC/) has_wait = 1
    if (line ~ /READSERIALRBFBYTE/ || line ~ /READSERIA/ || line ~ /SCRIPTREADNEXTRBFBYTE/ || line ~ /READNEXTRBFBYTE/) has_read_serial = 1
    if (line ~ /ESQIFF_PARSEATTEMPTCOUNT/) has_attempt_count = 1
    if (line ~ /TRANSFERBLOCKSEQUENCE/ || line ~ /CMP.B D0,D1/ || line ~ /CMP.B D1,D0/) has_seq_check = 1
    if (line ~ /ADDQ\.(B|L) #1,D0/ || line ~ /ADDQ\.(B|L) #\$1,D0/) replay_inc_seen = 1
    if (line ~ /CMP\.(B|L) D1,D0/ || line ~ /CMP\.(B|L) D0,D1/) replay_cmp_seen = 1
    if (line ~ /MOVEQ(\.L)? #\$?0,D0/ || line ~ /CLR\.L D0/) replay_zero_seen = 1
    if (line ~ /TRANSFERXORCHECKSUMBYTE/) has_xor_update = 1
    if (line ~ /TRANSFERCRC32TABLE/ || (line ~ /EOR\.L/ && line ~ /LSR\.L #8/)) has_payload_crc_fold = 1
    if (line ~ /TST\.B D7/) crc32_gate_seen = 1
    if ((line ~ /MOVEQ #4,D0/ || line ~ /CMPI\.L #\$4/ || line ~ /CMP\.W D0,D6/) && crc32_gate_seen) crc32_loop_seen = 1
    if ((line ~ /ASL\.L #8,D1/ || line ~ /ASL\.L #\$8,D1/) && crc32_loop_seen) crc32_shift_seen = 1
    if ((line ~ /OR\.L D2,D1/ || line ~ /MOVE\.L D1,D5/) && crc32_shift_seen) has_crc32_optional = 1
    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/) has_record_checksum_check = 1
    if (line ~ /WRITEBYTESTOOUTPUTHANDLEGUARDED/ || line ~ /WRITEBYTESTOOUTPUTHANDLEG/) has_flush_write = 1
    if (line ~ /MOVEQ #-1,D0/ || line ~ /MOVEQ\.L #\$FF,D0/) eof_minus_one_seen = 1
    if ((line ~ /BRA\.(S|W|B)/ || line ~ /RTS$/) && eof_minus_one_seen) {
        has_eof_complete = 1
        eof_minus_one_seen = 0
    }
    if (line ~ /ADDQ\.B #1,D0/ || line ~ /ADDQ\.B #\$1,D0/ ||
        line ~ /ADDQ\.B #1,D1/ || line ~ /ADDQ\.B #\$1,D1/) {
        seq_advance_pending = 1
    }
    if ((line ~ /MOVE\.B D0,DISKIO2_TRANSFERBLOCKSEQUENCE/ ||
         line ~ /MOVE\.B D1,DISKIO2_TRANSFERBLOCKSEQUENCE/) &&
        seq_advance_pending) {
        has_seq_advance = 1
    }
    if (line ~ /CLR\.L DISKIO2_TRANSFERCRCERRORCOUNT/ ||
        line ~ /MOVE\.L D0,DISKIO2_TRANSFERCRCERRORCOUNT/ ||
        (line ~ /MOVEQ #0,D0/ && line ~ /TRANSFERCRCERRORCOUNT/)) {
        has_crc_error_reset = 1
    }
    if (line ~ /SHOWATTENTIONOVERLAY/ || line ~ /SHOWATTE/ || line ~ /BRUSH_SNAPSHOTHEADER/) has_overlay_error = 1
    if (line ~ /TRANSFERCRCERRORCOUNT/) has_crc_error_count = 1

    if (line ~ /BNE\.(W|S|B) .*UNEXPECTED_SEQUENCE/ || line ~ /BNE\.(W|S|B) .*__8$/) {
        seq_advance_pending = 0
    }
}

END {
    if (has_seq_check && replay_zero_seen) has_replay_fast_return = 1

    print "HAS_ENTRY=" has_entry
    print "HAS_CRC_TABLE_COPY=" has_crc_table_copy
    print "HAS_WAIT=" has_wait
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_ATTEMPT_COUNT=" has_attempt_count
    print "HAS_SEQ_CHECK=" has_seq_check
    print "HAS_REPLAY_FAST_RETURN=" has_replay_fast_return
    print "HAS_XOR_UPDATE=" has_xor_update
    print "HAS_PAYLOAD_CRC_FOLD=" has_payload_crc_fold
    print "HAS_CRC32_OPTIONAL=" has_crc32_optional
    print "HAS_RECORD_CHECKSUM_CHECK=" has_record_checksum_check
    print "HAS_FLUSH_WRITE=" has_flush_write
    print "HAS_EOF_COMPLETE=" has_eof_complete
    print "HAS_SEQ_ADVANCE=" has_seq_advance
    print "HAS_CRC_ERROR_RESET=" has_crc_error_reset
    print "HAS_OVERLAY_ERROR=" has_overlay_error
    print "HAS_CRC_ERROR_COUNT=" has_crc_error_count
}
