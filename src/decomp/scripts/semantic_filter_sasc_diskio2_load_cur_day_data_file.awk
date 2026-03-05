BEGIN {
    has_entry = 0
    has_load = 0
    has_status_packet = 0
    has_consume = 0
    has_rev_match = 0
    has_weather_replace = 0
    has_parse_long = 0
    has_alloc = 0
    has_init_defaults = 0
    has_ensure_anim = 0
    has_filter = 0
    has_replace = 0
    has_free = 0
    has_load_oi = 0
    has_pending_flags = 0
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

    if (line ~ /DISKIO_LOADFILETOWORKBUFFER/) has_load = 1
    if (line ~ /APPLYINCOMINGSTATUSPACKET/ || line ~ /ESQIFF2_APPLYINC/) has_status_packet = 1
    if (line ~ /DISKIO_CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /CONSUMECSTRINGFROMWORKBUF/) has_consume = 1
    if (line ~ /WILDCARDMATCH/ || line ~ /DISKIO2_STR_DREV_/) has_rev_match = 1
    if (line ~ /WEATHERSTATUSTEXTPTR/ && line ~ /REPLACEOWNEDSTRING/) has_weather_replace = 1
    if (line ~ /DISKIO_PARSELONGFROMWORKBUFFER/ || line ~ /PARSELONGFROMWORKBUFFER/) has_parse_long = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /MEMORY_ALLOCAT/) has_alloc = 1
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
    print "HAS_STATUS_PACKET=" has_status_packet
    print "HAS_CONSUME=" has_consume
    print "HAS_REV_MATCH=" has_rev_match
    print "HAS_WEATHER_REPLACE=" has_weather_replace
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
