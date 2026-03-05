BEGIN {
    has_entry = 0
    has_compose = 0
    has_findchar = 0
    has_reset_buffers = 0
    has_count_guard = 0
    has_hex_parse = 0
    has_set_high = 0
    has_set_low = 0
    has_validate = 0
    has_replace = 0
    has_alloc = 0
    has_free = 0
    has_update = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^LADFUNC_PARSEBANNERENTRYDATA:/ || u ~ /^LADFUNC_PARSEBANNERENTRYDATA[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LADFUNC_COMPOSEPACKEDPENBYTE") > 0 || index(u, "LADFUNC_COMPOSEPACKEDPENBY") > 0) has_compose = 1
    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHAR") > 0) has_findchar = 1
    if (index(u, "LADFUNC_RESETENTRYTEXTBUFFERS") > 0 || index(u, "LADFUNC_RESETENTRYTEXTBU") > 0) has_reset_buffers = 1
    if (index(u, "LADFUNC_PARSEDENTRYCOUNT") > 0) has_count_guard = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0 || index(u, "LADFUNC_PARSEHEXDIG") > 0) has_hex_parse = 1
    if (index(u, "LADFUNC_SETPACKEDPENHIGHNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENHIGHN") > 0) has_set_high = 1
    if (index(u, "LADFUNC_SETPACKEDPENLOWNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENLOWNI") > 0) has_set_low = 1
    if (index(u, "ESQIFF2_VALIDATEASCIINUMERICBYTE") > 0 || index(u, "ESQIFF2_VALIDATEASCIINUME") > 0) has_validate = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTR") > 0) has_replace = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) has_alloc = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1
    if (index(u, "LADFUNC_UPDATEHIGHLIGHTSTATE") > 0 || index(u, "LADFUNC_UPDATEHIGHLIGHTST") > 0) has_update = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COMPOSE=" has_compose
    print "HAS_FINDCHAR=" has_findchar
    print "HAS_RESET_BUFFERS=" has_reset_buffers
    print "HAS_COUNT_GUARD=" has_count_guard
    print "HAS_HEX_PARSE=" has_hex_parse
    print "HAS_SET_HIGH=" has_set_high
    print "HAS_SET_LOW=" has_set_low
    print "HAS_VALIDATE=" has_validate
    print "HAS_REPLACE=" has_replace
    print "HAS_ALLOC=" has_alloc
    print "HAS_FREE=" has_free
    print "HAS_UPDATE=" has_update
    print "HAS_RETURN=" has_return
}
