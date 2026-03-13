BEGIN {
    has_entry = 0
    has_wait = 0
    has_read_serial = 0
    has_attempt_count = 0
    has_seq_check = 0
    has_xor_update = 0
    has_payload_crc_fold = 0
    has_crc32_optional = 0
    has_record_checksum_check = 0
    has_flush_write = 0
    has_seq_advance = 0
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

    if (line ~ /WAITFORCLOCKCHANGEANDSERVICEUI/ || line ~ /WAITFORC/) has_wait = 1
    if (line ~ /READSERIALRBFBYTE/ || line ~ /READSERIA/ || line ~ /SCRIPTREADNEXTRBFBYTE/ || line ~ /READNEXTRBFBYTE/) has_read_serial = 1
    if (line ~ /ESQIFF_PARSEATTEMPTCOUNT/) has_attempt_count = 1
    if (line ~ /TRANSFERBLOCKSEQUENCE/ || line ~ /CMP.B D0,D1/ || line ~ /CMP.B D1,D0/) has_seq_check = 1
    if (line ~ /TRANSFERXORCHECKSUMBYTE/) has_xor_update = 1
    if (line ~ /TRANSFERCRC32TABLE/ || (line ~ /EOR\.L/ && line ~ /LSR\.L #8/)) has_payload_crc_fold = 1
    if ((line ~ /TRANSFERCRC32TABLE/ || line ~ /CMPI\.L #\$4/) && (line ~ /TST\.B D7/ || line ~ /BEQ\.B/)) has_crc32_optional = 1
    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/) has_record_checksum_check = 1
    if (line ~ /WRITEBYTESTOOUTPUTHANDLEGUARDED/ || line ~ /WRITEBYTESTOOUTPUTHANDLEG/) has_flush_write = 1
    if ((line ~ /TRANSFERBLOCKSEQUENCE/ && line ~ /ADDQ\.B #1/) || line ~ /ADDQ\.B #1,D0/) has_seq_advance = 1
    if (line ~ /SHOWATTENTIONOVERLAY/ || line ~ /SHOWATTE/ || line ~ /BRUSH_SNAPSHOTHEADER/) has_overlay_error = 1
    if (line ~ /TRANSFERCRCERRORCOUNT/) has_crc_error_count = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_WAIT=" has_wait
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_ATTEMPT_COUNT=" has_attempt_count
    print "HAS_SEQ_CHECK=" has_seq_check
    print "HAS_XOR_UPDATE=" has_xor_update
    print "HAS_PAYLOAD_CRC_FOLD=" has_payload_crc_fold
    print "HAS_CRC32_OPTIONAL=" has_crc32_optional
    print "HAS_RECORD_CHECKSUM_CHECK=" has_record_checksum_check
    print "HAS_FLUSH_WRITE=" has_flush_write
    print "HAS_SEQ_ADVANCE=" has_seq_advance
    print "HAS_OVERLAY_ERROR=" has_overlay_error
    print "HAS_CRC_ERROR_COUNT=" has_crc_error_count
}
