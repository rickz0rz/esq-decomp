BEGIN {
    has_entry = 0
    has_status_refresh = 0
    has_wait = 0
    has_read_serial = 0
    has_filename_loop = 0
    has_wildcard_guard = 0
    has_copy_pad_nul = 0
    has_parse_size = 0
    has_checksum_verify = 0
    has_open_file = 0
    has_alloc_buffer = 0
    has_receive_blocks = 0
    has_close_and_free = 0
    has_delete_file = 0
    has_diag_queries = 0
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
    if (line ~ /DISKIO2_HANDLEINTERACTIVEFILETRA/) has_entry = 1

    if (line ~ /UPDATESTATUSMASKANDREFRESH/ || line ~ /ESQDISP_UPDATEST/) has_status_refresh = 1
    if (line ~ /WAITFORCLOCKCHANGEANDSERVICEUI/ || line ~ /WAITFORC/) has_wait = 1
    if (line ~ /READSERIALRBFBYTE/ || line ~ /READSERIA/) has_read_serial = 1
    if (line ~ /TRANSFERFILENAMEBUFFER/) has_filename_loop = 1
    if (line ~ /WILDCARDMATCH/ || line ~ /CTASKS_EXT_GRF/) has_wildcard_guard = 1
    if (line ~ /STRING_COPYPADNUL/ || line ~ /COPYPADNUL/ || line ~ /COPYPADNU/) has_copy_pad_nul = 1
    if (line ~ /PARSE_READSIGNEDLONGSKIPCLASS3/ || line ~ /READSIGNEDLONGSKIPCLASS3/ || line ~ /PARSE_READSIGNED/) has_parse_size = 1
    if (line ~ /ESQIFF_RECORDCHECKSUMBYTE/ || line ~ /TRANSFERXORCHECKSUMBYTE/) has_checksum_verify = 1
    if (line ~ /DOS_OPENFILEWITHMODE/ || line ~ /OPENFILEWITHMODE/ || line ~ /DOS_OPENFILEWITH/) has_open_file = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /TRANSFERBLOCKBUFFERPTR/) has_alloc_buffer = 1
    if (line ~ /RECEIVETRANSFERBLOCKSTOFILE/ || line ~ /RECEIVETRANSFERBLOCKSTOF/) has_receive_blocks = 1
    if (line ~ /LVOCLOSE/ || line ~ /MEMORY_DEALLOCATEMEMORY/) has_close_and_free = 1
    if (line ~ /LVODELETEFILE/) has_delete_file = 1
    if (line ~ /QUERYDISKUSAGEPERCENT/ || line ~ /QUERYVOLUMESOFTERRORCOUNT/ || line ~ /WDISP_SPRINTF/) has_diag_queries = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_REFRESH=" has_status_refresh
    print "HAS_WAIT=" has_wait
    print "HAS_READ_SERIAL=" has_read_serial
    print "HAS_FILENAME_LOOP=" has_filename_loop
    print "HAS_WILDCARD_GUARD=" has_wildcard_guard
    print "HAS_COPY_PAD_NUL=" has_copy_pad_nul
    print "HAS_PARSE_SIZE=" has_parse_size
    print "HAS_CHECKSUM_VERIFY=" has_checksum_verify
    print "HAS_OPEN_FILE=" has_open_file
    print "HAS_ALLOC_BUFFER=" has_alloc_buffer
    print "HAS_RECEIVE_BLOCKS=" has_receive_blocks
    print "HAS_CLOSE_AND_FREE=" has_close_and_free
    print "HAS_DELETE_FILE=" has_delete_file
    print "HAS_DIAG_QUERIES=" has_diag_queries
}
