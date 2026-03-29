BEGIN {
    has_entry = 0
    has_load = 0
    has_countdown_clear = 0
    has_status_packet = 0
    has_status_prefix_copy = 0
    has_consume = 0
    has_rev_match = 0
    has_entry_copy_size = 0
    has_entry_copy_size_40 = 0
    has_entry_copy_size_41 = 0
    has_entry_copy_size_46 = 0
    has_entry_copy_size_48 = 0
    has_weather_ptr = 0
    has_weather_replace_call = 0
    has_parse_long = 0
    has_alloc = 0
    has_init_defaults = 0
    has_ensure_anim = 0
    has_filter = 0
    has_replace = 0
    has_free = 0
    has_load_oi = 0
    has_pending_flags = 0
    has_group_state = 0
    has_slot_init = 0
    has_slot_attr_triplet = 0
    has_title_slot_replace = 0
    has_title_cleanup = 0
    has_table_store = 0
    has_header_count_write = 0
    has_pending_set = 0
    has_pending_clear = 0
    seen_parse_long = 0
    saw_preparse_workbuf = 0
    saw_preparse_scratch = 0
    saw_group_present = 0
    saw_group_mutation = 0
    saw_max_title_reset = 0
    saw_slot_flag_init = 0
    saw_slot_text_clear = 0
    saw_slot_attr_fc = 0
    saw_slot_attr_12d = 0
    saw_slot_attr_15e = 0
    saw_title_replace_store = 0
    saw_entry_table_store = 0
    saw_title_table_store = 0
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
    if (line ~ /DISKIO2_LOADCURDAYDATAFILE/) has_entry = 1

    if (!seen_parse_long) {
        if (line ~ /GLOBAL_PTR_WORK_BUFFER/ || line ~ /__MERGEDBSS\+\$4\(A4\)/) saw_preparse_workbuf = 1
        if (line ~ /GLOBAL_REF_LONG_FILE_SCRATCH/ || line ~ /__MERGEDBSS\(A4\)/) saw_preparse_scratch = 1
        if (saw_preparse_workbuf && saw_preparse_scratch) has_status_prefix_copy = 1
    }

    if (line ~ /DISKIO_LOADFILETOWORKBUFFER/) has_load = 1
    if ((line ~ /DST_PRIMARYCOUNTDOWN/ && line ~ /CLR\./) ||
        (line ~ /DST_PRIMARYCOUNTDOWN/ && line ~ /MOVE\.W #?0/) ||
        line ~ /CLR\.W __MERGEDBSS\+\$8\(A4\)/) has_countdown_clear = 1
    if (line ~ /APPLYINCOMINGSTATUSPACKET/ || line ~ /ESQIFF2_APPLYINC/) has_status_packet = 1
    if (line ~ /DISKIO_CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /CONSUMECSTRINGFROMWORKBUF/) has_consume = 1
    if (line ~ /WILDCARDMATCH/ || line ~ /DISKIO2_STR_DREV_/) has_rev_match = 1
    if (line ~ /WEATHERSTATUSTEXTPTR/) has_weather_ptr = 1
    if (line ~ /ESQPARS_REPLACEOWNEDSTRING/ || line ~ /ESQPARS_REPL/) has_weather_replace_call = 1
    if (line ~ /DISKIO_PARSELONGFROMWORKBUFFER/ || line ~ /PARSELONGFROMWORKBUFFER/) {
        has_parse_long = 1
        seen_parse_long = 1
    }
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /MEMORY_ALLOCAT/) has_alloc = 1
    if (line ~ /MOVEQ(\.L)? #\$28,D[0-7]/ || line ~ /MOVEQ #40,D[0-7]/) has_entry_copy_size_40 = 1
    if (line ~ /MOVEQ(\.L)? #\$29,D[0-7]/ || line ~ /MOVEQ #41,D[0-7]/) has_entry_copy_size_41 = 1
    if (line ~ /MOVEQ(\.L)? #\$2E,D[0-7]/ || line ~ /MOVEQ #46,D[0-7]/) has_entry_copy_size_46 = 1
    if (line ~ /MOVEQ(\.L)? #\$30,D[0-7]/ || line ~ /MOVEQ #48,D[0-7]/) has_entry_copy_size_48 = 1
    if (has_entry_copy_size_40 && has_entry_copy_size_41 &&
        has_entry_copy_size_46 && has_entry_copy_size_48) has_entry_copy_size = 1
    if (line ~ /ESQSHARED_INITENTRYDEFAULTS/ || line ~ /ESQSHARED_INITEN/) has_init_defaults = 1
    if (line ~ /COI_ENSUREANIMOBJECTALLOCATED/) has_ensure_anim = 1
    if (line ~ /APPLYPROGRAMTITLETEXTFILTERS/ || line ~ /ESQSHARED_APPLYP/) has_filter = 1
    if (line ~ /ESQPARS_REPLACEOWNEDSTRING/ || line ~ /ESQPARS_REPL/) has_replace = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /MEMORY_DEALLOCAT/) has_free = 1
    if (line ~ /COI_LOADOIDATAFILE/) has_load_oi = 1
    if (line ~ /PRIMARYOIWRITEPENDINGFLAG/ || line ~ /PENDINGPRIMARYOIDISKID/) has_pending_flags = 1

    if ((line ~ /TEXTDISP_PRIMARYGROUPPRESENTFLAG/ && line ~ /MOVE\.B #?\$?1/) ||
        line ~ /MOVE\.B #?\$?1,__MERGEDBSS\+\$D8\(A4\)/) saw_group_present = 1
    if ((line ~ /TEXTDISP_GROUPMUTATIONSTATE/ && line ~ /MOVE\.W #?\$?1/) ||
        line ~ /MOVE\.W #?\$?1,__MERGEDBSS\+\$DA\(A4\)/) saw_group_mutation = 1
    if ((line ~ /TEXTDISP_MAXENTRYTITLELENGTH/ && (line ~ /CLR\./ || line ~ /MOVE\.W D0/ || line ~ /MOVE\.W #?\$?0/)) ||
        line ~ /CLR\.W __MERGEDBSS\+\$DC\(A4\)/) saw_max_title_reset = 1
    if (saw_group_present && saw_group_mutation && saw_max_title_reset) has_group_state = 1

    if (line ~ /MOVE\.B #?\$?1,7\(A2,D5\.W\)/ ||
        line ~ /MOVE\.B #?\$?1,\$7\(A0,D1\.L\)/) saw_slot_flag_init = 1
    if (line ~ /CLR\.L 56\(A2,D0\.L\)/ ||
        line ~ /CLR\.L \$38\(A0,D1\.L\)/) saw_slot_text_clear = 1
    if (saw_slot_flag_init && saw_slot_text_clear) has_slot_init = 1

    if (line ~ /#\$FC,D1/ || line ~ /ADDI\.W #\$FC,D1/ || line ~ /ADD\.L #\$FC,D1/) saw_slot_attr_fc = 1
    if (line ~ /#\$12D,D1/ || line ~ /ADDI\.W #\$12D,D1/ || line ~ /ADD\.L #\$12D,D1/) saw_slot_attr_12d = 1
    if (line ~ /#\$15E,D1/ || line ~ /ADDI\.W #\$15E,D1/ || line ~ /ADD\.L #\$15E,D1/) saw_slot_attr_15e = 1
    if (saw_slot_attr_fc && saw_slot_attr_12d && saw_slot_attr_15e) has_slot_attr_triplet = 1

    if ((line ~ /MOVE\.L D0,56\(A2,D1\.L\)/ || line ~ /MOVE\.L D0,\$38\(A0,D1\.L\)/) &&
        (has_filter || has_replace)) saw_title_replace_store = 1
    if (saw_title_replace_store && has_filter && has_replace) has_title_slot_replace = 1

    if ((line ~ /GLOBAL_STR_DISKIO2_C_11/ || line ~ /\$2E0\)\.W/) &&
        (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /MEMORY_DEALLOCAT/ || line ~ /PEA /)) has_title_cleanup = 1
    if (line ~ /GLOBAL_STR_DISKIO2_C_12/ || line ~ /\$2E1\)\.W/) has_title_cleanup = 1

    if (line ~ /TEXTDISP_PRIMARYENTRYPTRTABLE/ || line ~ /LEA __MERGEDBSS\+\$DE\(A4\),A0/) saw_entry_table_store = 1
    if (line ~ /TEXTDISP_PRIMARYTITLEPTRTABLE/ || line ~ /LEA __MERGEDBSS\+\$3FE\(A4\),A0/) saw_title_table_store = 1
    if (saw_entry_table_store && saw_title_table_store) has_table_store = 1

    if ((line ~ /TEXTDISP_PRIMARYGROUPHEADERCODE/ || line ~ /__MERGEDBSS\+\$D1\(A4\)/) ||
        (line ~ /TEXTDISP_PRIMARYGROUPENTRYCOUNT/ || line ~ /__MERGEDBSS\+\$D2\(A4\)/)) has_header_count_write = 1

    if ((line ~ /PRIMARYOIWRITEPENDINGFLAG/ || line ~ /__MERGEDBSS\+\$71E\(A4\)/) &&
        (line ~ /MOVE\.B #?\$?1/ || line ~ /CLR\.B /)) has_pending_flags = 1
    if (line ~ /MOVE\.B #?\$?1,CTASKS_PRIMARYOIWRITEPENDINGFLAG/ ||
        line ~ /MOVE\.B #?\$?1,__MERGEDBSS\+\$71E\(A4\)/) has_pending_set = 1
    if (line ~ /MOVE\.B .*CTASKS_PENDINGPRIMARYOIDISKID/ ||
        line ~ /MOVE\.B \$74\(A7\),__MERGEDBSS\+\$71F\(A4\)/) has_pending_set = 1
    if (line ~ /CLR\.B CTASKS_PRIMARYOIWRITEPENDINGFLAG/ ||
        line ~ /CLR\.B __MERGEDBSS\+\$71E\(A4\)/ ||
        line ~ /MOVE\.B D0,CTASKS_PRIMARYOIWRITEPENDINGFLAG/ ||
        line ~ /MOVE\.B D0,__MERGEDBSS\+\$71E\(A4\)/) has_pending_clear = 1
    if (line ~ /CLR\.B CTASKS_PENDINGPRIMARYOIDISKID/ ||
        line ~ /CLR\.B __MERGEDBSS\+\$71F\(A4\)/ ||
        line ~ /MOVE\.B D0,CTASKS_PENDINGPRIMARYOIDISKID/ ||
        line ~ /MOVE\.B D0,__MERGEDBSS\+\$71F\(A4\)/) has_pending_clear = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_COUNTDOWN_CLEAR=" has_countdown_clear
    print "HAS_STATUS_PACKET=" has_status_packet
    print "HAS_STATUS_PREFIX_COPY=" has_status_prefix_copy
    print "HAS_CONSUME=" has_consume
    print "HAS_REV_MATCH=" has_rev_match
    print "HAS_ENTRY_COPY_SIZE=" has_entry_copy_size
    print "HAS_WEATHER_PTR=" has_weather_ptr
    print "HAS_WEATHER_REPLACE_CALL=" has_weather_replace_call
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_ALLOC=" has_alloc
    print "HAS_INIT_DEFAULTS=" has_init_defaults
    print "HAS_ENSURE_ANIM=" has_ensure_anim
    print "HAS_GROUP_STATE=" has_group_state
    print "HAS_SLOT_INIT=" has_slot_init
    print "HAS_SLOT_ATTR_TRIPLET=" has_slot_attr_triplet
    print "HAS_FILTER=" has_filter
    print "HAS_REPLACE=" has_replace
    print "HAS_TITLE_SLOT_REPLACE=" has_title_slot_replace
    print "HAS_FREE=" has_free
    print "HAS_TITLE_CLEANUP=" has_title_cleanup
    print "HAS_TABLE_STORE=" has_table_store
    print "HAS_HEADER_COUNT_WRITE=" has_header_count_write
    print "HAS_LOAD_OI=" has_load_oi
    print "HAS_PENDING_FLAGS=" has_pending_flags
    print "HAS_PENDING_SET=" has_pending_set
    print "HAS_PENDING_CLEAR=" has_pending_clear
}
