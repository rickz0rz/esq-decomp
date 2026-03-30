BEGIN {
    has_entry = 0
    has_compose = 0
    count_findchar = 0
    has_reset_buffers = 0
    has_count_guard = 0
    count_hex_parse = 0
    count_set_high = 0
    count_set_low = 0
    count_validate = 0
    has_replace = 0
    count_alloc = 0
    count_free = 0
    has_update = 0
    has_reset_tag = 0
    has_allowed_tag = 0
    has_status_ready_flag = 0
    has_entry_table = 0
    has_reset_sentinel = 0
    has_entry_limit = 0
    has_default_end = 0
    has_text_limit = 0
    has_ctrl_set_pens = 0
    has_ctrl_set_time_window = 0
    has_nibble_bound = 0
    has_return_zero = 0
    has_return_one = 0
    has_rts = 0
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
    if (index(u, "GROUP_AS_JMPTBL_STR_FINDCHARPTR") > 0 || index(u, "GROUP_AS_JMPTBL_STR_FINDCHAR") > 0) count_findchar++
    if (index(u, "LADFUNC_RESETENTRYTEXTBUFFERS") > 0 || index(u, "LADFUNC_RESETENTRYTEXTBU") > 0) has_reset_buffers = 1
    if (index(u, "LADFUNC_PARSEDENTRYCOUNT") > 0) has_count_guard = 1
    if (index(u, "LADFUNC_PARSEHEXDIGIT") > 0 || index(u, "LADFUNC_PARSEHEXDIG") > 0) count_hex_parse++
    if (index(u, "LADFUNC_SETPACKEDPENHIGHNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENHIGHN") > 0) count_set_high++
    if (index(u, "LADFUNC_SETPACKEDPENLOWNIBBLE") > 0 || index(u, "LADFUNC_SETPACKEDPENLOWNI") > 0) count_set_low++
    if (index(u, "ESQIFF2_VALIDATEASCIINUMERICBYTE") > 0 || index(u, "ESQIFF2_VALIDATEASCIINUME") > 0) count_validate++
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0 || index(u, "ESQPARS_REPLACEOWNEDSTR") > 0) has_replace = 1
    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) count_alloc++
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) count_free++
    if (index(u, "LADFUNC_UPDATEHIGHLIGHTSTATE") > 0 || index(u, "LADFUNC_UPDATEHIGHLIGHTST") > 0) has_update = 1
    if (index(u, "LADFUNC_TAG_RS_RESETTRIGGERSET") > 0 || index(u, "LADFUNC_TAG_RS_RESETTRIGGE") > 0) has_reset_tag = 1
    if (index(u, "LADFUNC_TAG_RS_PARSEALLOWEDSET") > 0 || index(u, "LADFUNC_TAG_RS_PARSEALLOW") > 0) has_allowed_tag = 1
    if (index(u, "ESQIFF_STATUSPACKETREADYFLAG") > 0) has_status_ready_flag = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0) has_entry_table = 1
    if (index(u, "#$92") > 0 || u ~ /CMP\.(B|W|L) .* 146(,|$)/ || u ~ /MOVEQ(\.L)? #73,D0/) has_reset_sentinel = 1
    if (index(u, "#$2E") > 0 || u ~ /CMP\.(B|W|L) .* 46(,|$)/ || u ~ /MOVEQ(\.L)? #46,D0/) has_entry_limit = 1
    if (index(u, "#$30") > 0 || index(u, "48") > 0) has_default_end = 1
    if (index(u, "#$190") > 0 || index(u, "400") > 0) has_text_limit = 1
    if (index(u, "#$3") > 0 || u ~ /MOVEQ(\.L)? #3,D0/) has_ctrl_set_pens = 1
    if (index(u, "#$14") > 0 || u ~ /MOVEQ(\.L)? #20,D0/) has_ctrl_set_time_window = 1
    if (index(u, "#$7") > 0 || u ~ /MOVEQ(\.L)? #7,D0/) has_nibble_bound = 1
    if (u ~ /^MOVEQ(\.L)? #0,D0$/ || u ~ /^MOVEQ(\.L)? #\$0,D0$/) has_return_zero = 1
    if (u ~ /^MOVEQ(\.L)? #1,D0$/ || u ~ /^MOVEQ(\.L)? #\$1,D0$/) has_return_one = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_COMPOSE=" has_compose
    print "COUNT_FINDCHAR=" count_findchar
    print "HAS_RESET_BUFFERS=" has_reset_buffers
    print "HAS_COUNT_GUARD=" has_count_guard
    print "COUNT_HEX_PARSE=" count_hex_parse
    print "COUNT_SET_HIGH=" count_set_high
    print "COUNT_SET_LOW=" count_set_low
    print "COUNT_VALIDATE=" count_validate
    print "HAS_REPLACE=" has_replace
    print "COUNT_ALLOC=" count_alloc
    print "COUNT_FREE=" count_free
    print "HAS_UPDATE=" has_update
    print "HAS_RESET_TAG=" has_reset_tag
    print "HAS_ALLOWED_TAG=" has_allowed_tag
    print "HAS_STATUS_READY_FLAG=" has_status_ready_flag
    print "HAS_ENTRY_TABLE=" has_entry_table
    print "HAS_RESET_SENTINEL=" has_reset_sentinel
    print "HAS_ENTRY_LIMIT=" has_entry_limit
    print "HAS_DEFAULT_END=" has_default_end
    print "HAS_TEXT_LIMIT=" has_text_limit
    print "HAS_CTRL_SET_PENS=" has_ctrl_set_pens
    print "HAS_CTRL_SET_TIME_WINDOW=" has_ctrl_set_time_window
    print "HAS_NIBBLE_BOUND=" has_nibble_bound
    print "HAS_RETURN_ZERO=" has_return_zero
    print "HAS_RETURN_ONE=" has_return_one
    print "HAS_RTS=" has_rts
}
