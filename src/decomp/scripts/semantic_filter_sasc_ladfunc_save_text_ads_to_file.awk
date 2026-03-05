BEGIN {
    has_entry = 0
    has_compose_call = 0
    has_ready_guard = 0
    has_open_call = 0
    has_entry_loop = 0
    has_write_decimal = 0
    has_sprintf_attr = 0
    has_write_bytes = 0
    has_linebreak_write = 0
    has_close_call = 0
    has_ready_set = 0
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

    if (u ~ /^LADFUNC_SAVETEXTADSTOFILE:/ || u ~ /^LADFUNC_SAVETEXTADSTOFIL[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "LADFUNC_COMPOSEPACKEDPENBYTE") > 0) has_compose_call = 1

    if (index(u, "DISKIO_SAVEOPERATIONREADYFLAG") > 0) has_ready_guard = 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_OPENFILEWITHBUFFER") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_OPENFILEW") > 0) has_open_call = 1

    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_entry_loop = 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEDECIMALFIELD") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEDEC") > 0) has_write_decimal = 1

    if (index(u, "GROUP_AW_JMPTBL_WDISP_SPRINTF") > 0 || index(u, "LADFUNC_FMT_ATTRESCAPEPREFIXCHARHEX") > 0 || index(u, "LADFUNC_FMT_ATTRESCAPEPREFIXCHAR") > 0) has_sprintf_attr = 1
    if (index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEBUFFEREDBYTES") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_WRITEBUF") > 0) has_write_bytes = 1

    if (index(u, "LADFUNC_TEXTADLINEBREAKBUFFER") > 0 || (has_write_bytes && (u ~ /#1,/ || u ~ /#\$1,/ || u ~ / PEA 1\.W$/))) has_linebreak_write = 1

    if (index(u, "GROUP_AY_JMPTBL_DISKIO_CLOSEBUFFEREDFILEANDFLUSH") > 0 || index(u, "GROUP_AY_JMPTBL_DISKIO_CLOSEBUF") > 0) has_close_call = 1
    if (index(u, "DISKIO_SAVEOPERATIONREADYFLAG") > 0 && (u ~ /^MOVEQ(\.L)? #1,D[0-7]$/ || u ~ /^MOVE\.L D[0-7],DISKIO_SAVEOPERATIONREADYFLAG/)) has_ready_set = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COMPOSE_CALL=" has_compose_call
    print "HAS_READY_GUARD=" has_ready_guard
    print "HAS_OPEN_CALL=" has_open_call
    print "HAS_ENTRY_LOOP=" has_entry_loop
    print "HAS_WRITE_DECIMAL=" has_write_decimal
    print "HAS_SPRINTF_ATTR=" has_sprintf_attr
    print "HAS_WRITE_BYTES=" has_write_bytes
    print "HAS_LINEBREAK_WRITE=" has_linebreak_write
    print "HAS_CLOSE_CALL=" has_close_call
    print "HAS_READY_SET=" has_ready_set
    print "HAS_RETURN=" has_return
}
