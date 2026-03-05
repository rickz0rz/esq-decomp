BEGIN {
    has_entry = 0
    has_load = 0
    has_parse_long = 0
    has_alloc = 0
    has_init_defaults = 0
    has_ensure_anim = 0
    has_consume = 0
    has_filter = 0
    has_replace = 0
    has_free = 0
    has_load_oi = 0
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

    if (line ~ /DISKIO_LOADFILETOWORKBUFFER/) has_load = 1
    if (line ~ /DISKIO_PARSELONGFROMWORKBUFFER/ || line ~ /DISKIO_PARSELONGFROMWORKB/) has_parse_long = 1
    if (line ~ /MEMORY_ALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCAT/) has_alloc = 1
    if (line ~ /ESQSHARED_INITENTRYDEFAULTS/ || line ~ /ESQSHARED_INITEN/) has_init_defaults = 1
    if (line ~ /COI_ENSUREANIMOBJECTALLOCATED/) has_ensure_anim = 1
    if (line ~ /DISKIO_CONSUMECSTRINGFROMWORKBUFFER/ || line ~ /DISKIO_CONSUMECSTRINGFROMW/) has_consume = 1
    if (line ~ /APPLYPROGRAMTITLETEXTFILTERS/ || line ~ /ESQSHARED_APPLYP/) has_filter = 1
    if (line ~ /ESQPARS_REPLACEOWNEDSTRING/ || line ~ /GROUP_AE_JMPTBL_ESQPARS_REPL/) has_replace = 1
    if (line ~ /MEMORY_DEALLOCATEMEMORY/ || line ~ /GROUP_AG_JMPTBL_MEMORY_DEALLOCAT/) has_free = 1
    if (line ~ /COI_LOADOIDATAFILE/) has_load_oi = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_PARSE_LONG=" has_parse_long
    print "HAS_ALLOC=" has_alloc
    print "HAS_INIT_DEFAULTS=" has_init_defaults
    print "HAS_ENSURE_ANIM=" has_ensure_anim
    print "HAS_CONSUME=" has_consume
    print "HAS_FILTER=" has_filter
    print "HAS_REPLACE=" has_replace
    print "HAS_FREE=" has_free
    print "HAS_LOAD_OI=" has_load_oi
}
