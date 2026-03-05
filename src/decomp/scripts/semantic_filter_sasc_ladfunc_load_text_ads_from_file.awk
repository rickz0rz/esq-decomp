BEGIN {
    has_entry = 0
    has_compose_call = 0
    has_load_file_call = 0
    has_reset_call = 0
    has_entry_loop = 0
    has_parse_long_calls = 0
    has_consume_cstr_call = 0
    has_alloc_text = 0
    has_alloc_attr = 0
    has_parse_hex = 0
    has_set_high = 0
    has_set_low = 0
    has_file_free = 0
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

    if (u ~ /^LADFUNC_LOADTEXTADSFROMFILE:/ || u ~ /^LADFUNC_LOADTEXTADSFROMFIL[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LADFUNC_COMPOSEPACKEDPENBYTE") > 0) has_compose_call = 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILETOWORKBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILETOW") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_LOADFILET") > 0) has_load_file_call = 1
    if (index(u, "LADFUNC_RESETENTRYTEXTBUFFERS") > 0) has_reset_call = 1

    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_entry_loop = 1

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_PARSELONGFROMWORKBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_PARSELONGF") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_PARSELONG") > 0) has_parse_long_calls += 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_CONSUMECSTRINGFROMWORKBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_CONSUMECST") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_CONSUMECS") > 0) has_consume_cstr_call = 1

    if (index(u, "GLOBAL_STR_LADFUNC_C_9") > 0 || u ~ /591/ || u ~ /\$24F/) has_alloc_text = 1
    if (index(u, "GLOBAL_STR_LADFUNC_C_10") > 0 || u ~ /600/ || u ~ /\$258/) has_alloc_attr = 1

    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0) has_parse_hex = 1
    if (index(u, "LADFUNC_SETPACKEDPENHIGHNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENHIGHNIB") > 0) has_set_high = 1
    if (index(u, "LADFUNC_SETPACKEDPENLOWNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENLOWNIB") > 0) has_set_low = 1

    if (index(u, "GLOBAL_STR_LADFUNC_C_13") > 0 || u ~ /653/ || u ~ /\$28D/ || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_file_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COMPOSE_CALL=" has_compose_call
    print "HAS_LOAD_FILE_CALL=" has_load_file_call
    print "HAS_RESET_CALL=" has_reset_call
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_PARSE_LONG_CALLS_GE2=" (has_parse_long_calls >= 2 ? 1 : 0)
    print "HAS_CONSUME_CSTR_CALL=" has_consume_cstr_call
    print "HAS_ALLOC_TEXT=" has_alloc_text
    print "HAS_ALLOC_ATTR=" has_alloc_attr
    print "HAS_PARSE_HEX=" has_parse_hex
    print "HAS_SET_HIGH=" has_set_high
    print "HAS_SET_LOW=" has_set_low
    print "HAS_FILE_FREE=" has_file_free
    print "HAS_RETURN=" has_return
}
