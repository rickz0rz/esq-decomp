BEGIN {
    has_label = 0

    saw_crc_table_base = 0
    saw_crc_table_count = 0
    saw_crc_table_copy_op = 0
    has_crc_table_copy = 0

    saw_parse_attempt_inc = 0
    saw_sequence_compare = 0
    saw_sequence_plus_one = 0
    has_sequence_retry = 0
    has_sequence_overlay = 0

    saw_filename_copy = 0
    saw_overlay_call = 0

    saw_zero_len_checksum = 0
    saw_crc_error_bump = 0
    saw_buffer_flush = 0
    has_eof_checksum_mismatch = 0
    has_eof_flush = 0
    has_eof_success = 0

    saw_payload_len_compare = 0
    saw_payload_wait_read = 0
    saw_payload_counter_bump = 0
    saw_payload_buffer_base = 0
    saw_payload_byte_store = 0
    has_payload_crc_fold = 0
    has_payload_store = 0
    has_payload_loop = 0

    saw_crc32_gate = 0
    saw_crc32_trip_count = 0
    saw_crc32_shift = 0
    saw_crc32_pack = 0
    has_crc32_loop = 0
    has_crc32_compare = 0

    saw_record_checksum_compare = 0
    has_record_mismatch = 0

    saw_final_threshold = 0
    saw_final_write_call = 0
    saw_success_seq_bump = 0
    saw_success_crc_clear = 0
    has_final_flush_guard = 0
    has_final_flush_error = 0
    has_success_reset = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    if (line ~ /^DISKIO2_RECEIVETRANSFERBLOCKSTOF[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (line ~ /LEA DISKIO2_TRANSFERCRC32TABLE/ || line ~ /DISKIO2_TRANSFERCRC32TABLE\(A4\)/) {
        saw_crc_table_base = 1
    }
    if (line ~ /MOVE\.W #\$FF,D0/ || line ~ /MOVEQ(\.L)? #\$FF,D6/ || line ~ /CMPI\.L #\$100,D0/) {
        saw_crc_table_count = 1
    }
    if (line ~ /MOVE\.L \(A0\)\+,\(A1\)\+/ || line ~ /MOVE\.L \$0\(A0,D1\.L\),\$2C\(A7,D1\.L\)/) {
        saw_crc_table_copy_op = 1
    }
    if (saw_crc_table_base && saw_crc_table_count && saw_crc_table_copy_op &&
        (line ~ /DBF D0,/ || line ~ /ADDQ\.L #\$1,\$24\(A7\)/ || line ~ /BRA\.B/)) {
        has_crc_table_copy = 1
    }

    if (line ~ /PARSEATTEMPTCOUNT/ && line ~ /ADDQ\.W #1/) {
        saw_parse_attempt_inc = 1
    }
    if (line ~ /TRANSFERBLOCKSEQUENCE/ && line ~ /CMP\.(B|L)/) {
        saw_sequence_compare = 1
    }
    if (line ~ /ADDQ\.(B|L) #1,D0/ || line ~ /ADDQ\.B #\$1,D0/ || line ~ /ADDQ\.L #1,D0/) {
        saw_sequence_plus_one = 1
    }
    if (saw_parse_attempt_inc && saw_sequence_compare && saw_sequence_plus_one &&
        (line ~ /MOVEQ(\.L)? #\$0,D0/ || line ~ /MOVEQ #0,D0/)) {
        has_sequence_retry = 1
    }
    if (line ~ /TRANSFERFILENAMEBUFFER/ || line ~ /BRUSH_SNAPSHOTHEADER/) {
        saw_filename_copy = 1
    }
    if (line ~ /SHOWATTENTIONOVERLAY/ || line ~ /SHOWATTE/) {
        saw_overlay_call = 1
    }
    if (saw_filename_copy && saw_overlay_call &&
        (line ~ /MOVEQ(\.L)? #\$1,D0/ || line ~ /MOVEQ #1,D0/)) {
        has_sequence_overlay = 1
    }

    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/ && line ~ /MOVE\.B/) {
        saw_zero_len_checksum = 1
    }
    if (line ~ /TRANSFERCRCERRORCOUNT/ && line ~ /ADDQ\.L #1/) {
        saw_crc_error_bump = 1
    }
    if (((line ~ /MOVE\.B #\$1,-16\(A5\)/) || (line ~ /MOVE\.B #\$1,\$28\(A7\)/)) &&
        saw_zero_len_checksum) {
        has_eof_checksum_mismatch = 1
    } else if (saw_zero_len_checksum && saw_crc_error_bump &&
        (line ~ /MOVEQ(\.L)? #\$0,D0/ || line ~ /MOVEQ #0,D0/)) {
        has_eof_checksum_mismatch = 1
    }
    if (line ~ /TRANSFERBUFFEREDBYTECOUNT/ || line ~ /TRANSFERBUFFEREDBYTECOUN/) {
        saw_buffer_flush = 1
    }
    if (saw_zero_len_checksum && saw_buffer_flush && line ~ /WRITEBYTESTOOUTPUTHANDLEG/) {
        saw_buffer_flush = 2
    }
    if (saw_buffer_flush == 2 && (line ~ /MOVEQ(\.L)? #\$3,D0/ || line ~ /MOVEQ #3,D0/)) {
        has_eof_flush = 1
    }
    if (saw_zero_len_checksum && (line ~ /MOVEQ(\.L)? #\$FF,D0/ || line ~ /MOVEQ #-1,D0/)) {
        has_eof_success = 1
    }

    if (line ~ /TRANSFERBLOCKLENGTH/ && line ~ /CMP\.(L|W)/) {
        saw_payload_len_compare = 1
    }
    if ((line ~ /WAITFORCLOCKCHANGEANDSERVICEUI|WAITFORCLOCKCHANGEANDSER/) ||
        (line ~ /READSERIALRBFBYTE|READNEXTRBFBYTE/)) {
        saw_payload_wait_read++
    }
    if ((line ~ /ADDQ\.W #1,D5/ || line ~ /ADDQ\.W #\$1,\$22\(A7\)/ || line ~ /ADDQ\.W #1,D6/ ||
         line ~ /ADDQ\.W #\$1,\$20\(A7\)/)) {
        saw_payload_counter_bump = 1
    }
    if ((line ~ /LEA -1040\(A5\),A0/ || line ~ /\$2C\(A7,D2\.L\)/) &&
        (line ~ /LSR\.L #8/ || line ~ /EOR\.L/)) {
        has_payload_crc_fold = 1
    }
    if (line ~ /TRANSFERBLOCKBUFFERPTR/ || line ~ /TRANSFERBLOCKBUFFERPTR\(A4\)/) {
        saw_payload_buffer_base = 1
    }
    if (line ~ /MOVE\.B D0,\(A0\)/ || line ~ /MOVE\.B D4,\(A0\)/) {
        saw_payload_byte_store = 1
    }
    if (saw_payload_buffer_base && saw_payload_byte_store) {
        has_payload_store = 1
    }
    if (saw_payload_len_compare && saw_payload_wait_read >= 2 &&
        saw_payload_counter_bump && has_payload_crc_fold && has_payload_store) {
        has_payload_loop = 1
    }

    if (line ~ /TST\.B D7/ || line ~ /TST\.B \$433\(A7\)/) {
        saw_crc32_gate = 1
    }
    if (line ~ /MOVEQ(\.L)? #4,D0/ || line ~ /CMPI\.L #\$4,\$24\(A7\)/) {
        saw_crc32_trip_count = 1
    }
    if (line ~ /ASL\.L #8,D1/ || line ~ /ASL\.L #\$8,D1/) {
        saw_crc32_shift = 1
    }
    if (line ~ /OR\.L D2,D1/) {
        saw_crc32_pack = 1
    }
    if (saw_crc32_gate && saw_crc32_trip_count && saw_crc32_shift && saw_crc32_pack) {
        has_crc32_loop = 1
    }
    if (line ~ /CMP\.L/ && (line ~ /D5,D6/ || line ~ /-14\(A5\),D0/ || line ~ /D6,D5/)) {
        has_crc32_compare = 1
    }

    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/ && line ~ /MOVE\.B/) {
        saw_record_checksum_compare = 1
    }
    if (saw_record_checksum_compare && line ~ /TRANSFERXORCHECKSUMBYTE/ && line ~ /CMP\.B/) {
        saw_record_checksum_compare = 2
    }
    if (saw_record_checksum_compare == 2 &&
        (line ~ /MOVEQ(\.L)? #\$0,D0/ || line ~ /MOVEQ #0,D0/)) {
        has_record_mismatch = 1
    }

    if (line ~ /TRANSFERBUFFEREDBYTECOUNT/ || line ~ /TRANSFERBUFFEREDBYTECOUN/) {
        saw_final_threshold = saw_final_threshold
    }
    if (line ~ /#\$1000/) {
        saw_final_threshold = 1
    }
    if (line ~ /WRITEBYTESTOOUTPUTHANDLEG/) {
        saw_final_write_call = 1
    }
    if (saw_final_threshold && saw_final_write_call) {
        has_final_flush_guard = 1
    }
    if (has_final_flush_guard && (line ~ /MOVEQ(\.L)? #\$2,D0/ || line ~ /MOVEQ #2,D0/)) {
        has_final_flush_error = 1
    }
    if (line ~ /TRANSFERBLOCKSEQUENCE/ && line ~ /ADDQ\.B #1/) {
        saw_success_seq_bump = 1
    }
    if (line ~ /CLR\.L DISKIO2_TRANSFERCRCERRORCOUNT/) {
        saw_success_crc_clear = 1
    }
    if (saw_success_seq_bump && saw_success_crc_clear) {
        has_success_reset = 1
    }
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_CRC_TABLE_COPY=" has_crc_table_copy
    print "HAS_SEQUENCE_RETRY=" has_sequence_retry
    print "HAS_SEQUENCE_OVERLAY=" has_sequence_overlay
    print "HAS_EOF_CHECKSUM_MISMATCH=" has_eof_checksum_mismatch
    print "HAS_EOF_FLUSH=" has_eof_flush
    print "HAS_EOF_SUCCESS=" has_eof_success
    print "HAS_PAYLOAD_CRC_FOLD=" has_payload_crc_fold
    print "HAS_PAYLOAD_STORE=" has_payload_store
    print "HAS_PAYLOAD_LOOP=" has_payload_loop
    print "HAS_CRC32_LOOP=" has_crc32_loop
    print "HAS_CRC32_COMPARE=" has_crc32_compare
    print "HAS_RECORD_MISMATCH=" has_record_mismatch
    print "HAS_FINAL_FLUSH_GUARD=" (has_final_flush_guard ? 1 : 0)
    print "HAS_FINAL_FLUSH_ERROR=" has_final_flush_error
    print "HAS_SUCCESS_RESET=" has_success_reset
}
