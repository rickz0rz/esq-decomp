function norm(s, t) {
    t = toupper(s)
    sub(/;.*/, "", t)
    gsub(/^[ \t]+|[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return t
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^LOCAVAIL_LOADAVAILABILITYDATAFILE:/ || line ~ /^LOCAVAIL_LOADAVAILABILITYDATAFIL[A-Z0-9_]*:/) has_entry = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_LOADFILET/ || line ~ /LOADFILETOWORKBUFFER/) has_load_file = 1
    if (line ~ /LOCAVAIL_PATH_DF0_COLON_LOCAVAIL/) has_load_path = 1
    if (line ~ /LOCAVAIL_FREERESOURCECHAIN/) has_free_chain = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_CONSUMECS/ || line ~ /CONSUMECSTRINGFROMWORKBUFFER/) has_consume_cstring = 1
    if ((line ~ /GROUP_AY_JMPTBL_STRING_COMPARENO/ || line ~ /COMPARENOCASEN/) && line ~ /LOCAVAIL_STR_LA_VER/) has_version_check = 1
    if (line ~ /GROUP_AY_JMPTBL_DISKIO_PARSELONG/ || line ~ /PARSELONGFROMWORKBUFFER/) has_parse_long = 1
    if (line ~ /LOCAVAIL_ALLOCNODEARRAYSFORSTATE/) has_alloc_arrays = 1
    if ((line ~ /NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY/ || line ~ /ALLOCATEMEMORY/) && line ~ /GLOBAL_STR_LOCAVAIL_C_7/) has_alloc_payload = 1
    if (line ~ /LOCAVAIL_COPYFILTERSTATESTRUCTRE/ || line ~ /COPYFILTERSTATESTRUCTRETAINREFS/) has_copy_state = 1
    if (line ~ /NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY/ && line ~ /GLOBAL_STR_LOCAVAIL_C_8/) has_free_filebuf = 1
    if (line == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD_FILE=" has_load_file
    print "HAS_LOAD_PATH=" has_load_path
    print "HAS_FREE_CHAIN=" has_free_chain
    print "HAS_CONSUME_CSTRING=" has_consume_cstring
    print "HAS_VERSION_CHECK=" has_version_check
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_ALLOC_ARRAYS=" has_alloc_arrays
    print "HAS_ALLOC_PAYLOAD=" has_alloc_payload
    print "HAS_COPY_STATE=" has_copy_state
    print "HAS_FREE_FILEBUF=" has_free_filebuf
    print "HAS_RETURN=" has_return
}
