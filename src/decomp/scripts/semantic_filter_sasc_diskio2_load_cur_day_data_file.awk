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
    seen_parse_long = 0
    saw_preparse_workbuf = 0
    saw_preparse_scratch = 0
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
    print "HAS_FILTER=" has_filter
    print "HAS_REPLACE=" has_replace
    print "HAS_FREE=" has_free
    print "HAS_LOAD_OI=" has_load_oi
    print "HAS_PENDING_FLAGS=" has_pending_flags
}
