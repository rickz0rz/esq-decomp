BEGIN {
    has_entry = 0
    has_status_refresh = 0
    status_update_count = 0
    has_wait = 0
    has_read_serial = 0
    has_checksum_seed_default = 0
    has_checksum_seed_crc32 = 0
    has_filename_len_cap = 0
    has_size_token_len_cap = 0
    wait_call_count = 0
    read_serial_call_count = 0
    has_filename_loop = 0
    has_wildcard_guard = 0
    has_copy_pad_nul = 0
    has_short_name_nul = 0
    has_parse_size = 0
    has_oversize_overlay = 0
    has_checksum_verify = 0
    has_open_file = 0
    has_alloc_buffer = 0
    has_receive_blocks = 0
    has_delete_marker = 0
    has_close_and_free = 0
    has_delete_file = 0
    has_copy_execute = 0
    has_diag_queries = 0
    has_sync_marker_55 = 0
    has_sync_marker_aa = 0
    has_data_marker_h = 0
    has_data_marker_crc32 = 0
    append_at_null_call_count = 0
    display_call_count = 0
    delete_file_call_count = 0
    receive_blocks_call_count = 0
    save_read_mode_count = 0
    restore_read_mode_count = 0
    has_success_cleanup = 0
    has_success_stored_text = 0
    has_diag_clear_y210 = 0
    has_diag_clear_y240 = 0
    checksum_gate_count = 0
    delete_bb_count = 0
    delete_ff_count = 0
    finalize_stage = 0
    has_finalize_diag = 0
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
    if (line ~ /^XREF /) next

    if (ENTRY_PREFIX != "" && index(line, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(line, ENTRY_ALT_PREFIX) == 1) has_entry = 1
    if (line ~ /DISKIO2_HANDLEINTERACTIVEFILETRA/) has_entry = 1

    if (line ~ /UPDATESTATUSMASKANDREFRESH/ || line ~ /ESQDISP_UPDATEST/) {
        has_status_refresh = 1
        status_update_count++
    }
    if (line ~ /WAITFORCLOCKCHANGEANDSERVICEUI/ || line ~ /WAITFORC/) has_wait = 1
    if (line ~ /#\$B7/ || line ~ /#183/ || line ~ /NOT\.B D0/) has_checksum_seed_default = 1
    if (line ~ /#\$C2/ || line ~ /#194/ || line ~ /MOVEQ #\$61,D0/ || line ~ /MOVEQ\.L #\$61,D0/) has_checksum_seed_crc32 = 1
    if (line ~ /CMPI\.B #\$1F/ || line ~ /MOVEQ #\$1F,D0/ || line ~ /MOVEQ\.L #\$1F,D0/) has_filename_len_cap = 1
    if (line ~ /CMPI\.B #\$8/ || line ~ /MOVEQ #\$8,D0/ || line ~ /MOVEQ\.L #\$8,D0/) has_size_token_len_cap = 1
    if (line ~ /^(JSR|BSR\.W) .*WAITFORCLOCKCHANGEANDSERVICEUI/ || line ~ /^(JSR|BSR\.W) ESQFUNC_WAITFORCLOCKCHANGEANDSER/) wait_call_count++
    if (line ~ /READSERIALRBFBYTE/ || line ~ /SCRIPT_READNEXTRBFBYTE/ || line ~ /READSERIA/) has_read_serial = 1
    if (line ~ /^(JSR|BSR\.W) .*READSERIALRBFBYTE/ || line ~ /^(JSR|BSR\.W) SCRIPT_READNEXTRBFBYTE/) read_serial_call_count++
    if (line ~ /TRANSFERFILENAMEBUFFER/) has_filename_loop = 1
    if (line ~ /WILDCARDMATCH/ || line ~ /CTASKS_EXT_GRF/) has_wildcard_guard = 1
    if (line ~ /STRING_COPYPADNUL/ || line ~ /COPYPADNUL/ || line ~ /COPYPADNU/) has_copy_pad_nul = 1
    if (line ~ /MOVE\.B D0,-64\(A5\)/ || line ~ /CLR\.B \$C8\(A7\)/) has_short_name_nul = 1
    if (line ~ /PARSE_READSIGNEDLONGSKIPCLASS3/ || line ~ /READSIGNEDLONGSKIPCLASS3/ || line ~ /PARSE_READSIGNED/) has_parse_size = 1
    if (line ~ /SHOWATTENTIONOVERLAY/ || line ~ /BRUSH_SNAPSHOTHEADER/) has_oversize_overlay = 1
    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/ || line ~ /TRANSFERXORCHECKSUMBYTE/) {
        has_checksum_verify = 1
        checksum_gate_count++
    }
    if (line ~ /DOS_OPENFILEWITHMODE/ || line ~ /OPENFILEWITHMODE/ || line ~ /DOS_OPENFILEWITH/) has_open_file = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /TRANSFERBLOCKBUFFERPTR/) has_alloc_buffer = 1
    if (line ~ /RECEIVETRANSFERBLOCKSTOFILE/ || line ~ /RECEIVETRANSFERBLOCKSTOF/) has_receive_blocks = 1
    if (line ~ /#\$55/ || line ~ /MOVEQ #85,D0/ || line ~ /MOVEQ\.L #\$55,D0/) has_sync_marker_55 = 1
    if (line ~ /#\$AA/ || line ~ /CMPI\.B #\$AA/ || line ~ /ADD\.L D0,D0/) has_sync_marker_aa = 1
    if (line ~ /#\$48/ || line ~ /MOVEQ #72,D1/ || line ~ /MOVEQ\.L #\$48,D0/) has_data_marker_h = 1
    if (line ~ /#\$3D/ || line ~ /MOVEQ #61,D1/ || line ~ /MOVEQ\.L #\$3D,D0/) has_data_marker_crc32 = 1
    if (line ~ /CMPI\.B #\$BB/ || line ~ /MOVEQ #68,D0/ || line ~ /MOVEQ\.L #\$4,D0/) {
        has_delete_marker = 1
        delete_bb_count++
    }
    if (line ~ /CMPI\.B #\$FF/ || line ~ /MOVEQ #68,D0/ || line ~ /MOVEQ\.L #\$4,D0/) {
        has_delete_marker = 1
        delete_ff_count++
    }
    if (line ~ /LVOCLOSE/ || line ~ /MEMORY_DEALLOCATEMEMORY/) has_close_and_free = 1
    if (line ~ /LVODELETEFILE/) has_delete_file = 1
    if (line ~ /LVOEXECUTE/ || line ~ /STRING_APPENDATNULL/ || line ~ /GLOBAL_STR_COPY_NIL/) has_copy_execute = 1
    if (line ~ /QUERYDISKUSAGEPERCENT/ || line ~ /QUERYVOLUMESOFTERRORCOUNT/ || line ~ /WDISP_SPRINTF/) has_diag_queries = 1
    if (line ~ /^(JSR|BSR\.W) .*STRING_APPENDATNULL/ || line ~ /^(JSR|BSR\.W) STRING_APPENDATNULL/) append_at_null_call_count++
    if (line ~ /^(JSR|BSR\.W) DISPLIB_DISPLAYTEXTATPOSITION/) display_call_count++
    if (line ~ /^(JSR|BSR\.W) _LVODELETEFILE/) delete_file_call_count++
    if (line ~ /^(JSR|BSR\.W) DISKIO2_RECEIVETRANSFERBLOCKSTOF/) receive_blocks_call_count++
    if (line ~ /^MOVE\.W ESQPARS2_READMODEFLAGS.*DISKIO_SAVEDREADMODEFLAGS/) save_read_mode_count++
    if (line ~ /^MOVE\.W DISKIO_SAVEDREADMODEFLAGS.*ESQPARS2_READMODEFLAGS/) restore_read_mode_count++
    if (line ~ /DISKIO_FORCEUIREFRESHIFIDLE/ || line ~ /DISKIO_RESETCTRLINPUTSTATEIFIDLE/) has_success_cleanup = 1
    if (line ~ /GLOBAL_STR_STORED/ || line ~ /__MERGED\(A4\)/) has_success_stored_text = 1
    if (line ~ /PEA \(\$D2\)\.W/ || line ~ /PEA 210\.W/) has_diag_clear_y210 = 1
    if (line ~ /PEA \(\$F0\)\.W/ || line ~ /PEA 240\.W/) has_diag_clear_y240 = 1

    if (line ~ /INTERACTIVETRANSFERARMED/) {
        if (finalize_stage == 0) finalize_stage = 1
    }
    if ((line ~ /UPDATESTATUSMASKANDREFRESH/ || line ~ /ESQDISP_UPDATEST/) && finalize_stage >= 1) {
        if (finalize_stage == 1) finalize_stage = 2
    }
    if ((line ~ /QUERYDISKUSAGEPERCENT/ || line ~ /QUERYDISKUSAGEPERCENTANDSETBUFFERSIZE/) &&
        finalize_stage >= 2) {
        if (finalize_stage == 2) finalize_stage = 3
    }
    if (line ~ /QUERYVOLUMESOFTERRORCOUNT/ && finalize_stage >= 3) {
        if (finalize_stage == 3) finalize_stage = 4
    }
    if ((line ~ /WDISP_SPRINTF/ || line ~ /SPRINTF/) && finalize_stage >= 4) {
        if (finalize_stage == 4) finalize_stage = 5
    }
    if (line ~ /DISPLIB_DISPLAYTEXTATPOSITION/ &&
        (line ~ /#\$5A/ || line ~ /#90/) &&
        finalize_stage >= 5) {
        has_finalize_diag = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_REFRESH=" has_status_refresh
    print "HAS_STATUS_BUSY_TOGGLE=" (status_update_count >= 2)
    print "HAS_WAIT=" has_wait
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_CHECKSUM_SEED_DEFAULT=" has_checksum_seed_default
    print "HAS_CHECKSUM_SEED_CRC32=" has_checksum_seed_crc32
    print "HAS_FILENAME_LEN_CAP=" has_filename_len_cap
    print "HAS_SIZE_TOKEN_LEN_CAP=" has_size_token_len_cap
    print "WAIT_CALL_COUNT=" wait_call_count
    print "READ_SERIAL_CALL_COUNT=" read_serial_call_count
    print "HAS_FILENAME_LOOP=" has_filename_loop
    print "HAS_WILDCARD_GUARD=" has_wildcard_guard
    print "HAS_COPY_PAD_NUL=" has_copy_pad_nul
    print "HAS_SHORT_NAME_NUL=" has_short_name_nul
    print "HAS_PARSE_SIZE=" has_parse_size
    print "HAS_OVERSIZE_OVERLAY=" has_oversize_overlay
    print "HAS_CHECKSUM_VERIFY=" has_checksum_verify
    print "HAS_CHECKSUM_GATE=" (checksum_gate_count >= 3)
    print "HAS_OPEN_FILE=" has_open_file
    print "HAS_ALLOC_BUFFER=" has_alloc_buffer
    print "HAS_RECEIVE_BLOCKS=" has_receive_blocks
    print "HAS_SYNC_MARKER_55=" has_sync_marker_55
    print "HAS_SYNC_MARKER_AA=" has_sync_marker_aa
    print "HAS_DATA_MARKER_H=" has_data_marker_h
    print "HAS_DATA_MARKER_CRC32=" has_data_marker_crc32
    print "HAS_DELETE_MARKER=" has_delete_marker
    print "HAS_DELETE_MARKER_FLOW=" (delete_bb_count >= 2 && delete_ff_count >= 1)
    print "HAS_CLOSE_AND_FREE=" has_close_and_free
    print "HAS_DELETE_FILE=" has_delete_file
    print "HAS_COPY_EXECUTE=" has_copy_execute
    print "HAS_DIAG_QUERIES=" has_diag_queries
    print "APPEND_AT_NULL_CALL_COUNT=" append_at_null_call_count
    print "DISPLAY_CALL_COUNT=" display_call_count
    print "DELETE_FILE_CALL_COUNT=" delete_file_call_count
    print "RECEIVE_BLOCKS_CALL_COUNT=" receive_blocks_call_count
    print "SAVE_READ_MODE_COUNT=" save_read_mode_count
    print "RESTORE_READ_MODE_COUNT=" restore_read_mode_count
    print "HAS_SUCCESS_CLEANUP=" has_success_cleanup
    print "HAS_SUCCESS_STORED_TEXT=" has_success_stored_text
    print "HAS_DIAG_CLEAR_LINES=" (has_diag_clear_y210 && has_diag_clear_y240)
    print "HAS_FINALIZE_DIAG=" has_finalize_diag
}
