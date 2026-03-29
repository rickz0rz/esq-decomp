BEGIN {
    has_entry=0
    has_init_reset=0
    compare_calls=0
    read_long_calls=0
    has_filename_alloc=0
    has_filename_type_init=0
    has_head_seed=0
    has_current_block_guard=0
    loadcolor_tag_count=0
    has_loadcolor_store=0
    numeric_store_count=0
    has_source_scan=0
    has_source_guard=0
    has_source_ppv=0
    has_source_alloc=0
    has_source_copy_loop=0
    has_source_link_init=0
    has_source_link_append=0
    horiz_tag_count=0
    has_horiz_default=0
    vert_tag_count=0
    has_vert_default=0
    has_id_copy=0
    has_id_terminator=0
    has_return=0
    saw_source_copy=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^PARSEINI_PROCESSWEATHERBLOCKS:/ || u ~ /^PARSEINI_PROCESSWEATHERBLOC[A-Z0-9_]*:/) has_entry=1

    if (n ~ /CLRLPARSEINICURRENTWEATHERBLOCKTEMP/ || n ~ /CLRLPARSEINICURRENTWEATHERBLOCKPTR/) has_init_reset=1
    if (n ~ /STRINGCOMPARENOCASE/) compare_calls++
    if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) read_long_calls++

    if (n ~ /BRUSHALLOCBRUSHNODE/) has_filename_alloc=1
    if (n ~ /MOVEB1BEA0/ || n ~ /MOVEB1190A0/) has_filename_type_init=1
    if (n ~ /PARSEINIPARSEDDESCRIPTORLISTHEA/ && n ~ /MOVELD0/) has_head_seed=1
    if (n ~ /TSTLPARSEINICURRENTWEATHERBLOCKPTR/ || n ~ /BEQWRETURN/ || n ~ /BEQWPARSEINIPROCESSWEATHERBLOCKS63/) has_current_block_guard=1

    if (n ~ /PARSEINISTRLOADCOLOR/ || n ~ /PARSEINITAGALL/ || n ~ /PARSEINITAGNONE/ || n ~ /PARSEINITAGTEXT/) loadcolor_tag_count++
    if (n ~ /CLRLC2A0/ || n ~ /CLRL194A0/ || n ~ /MOVELD0C2A0/ || n ~ /MOVELD0194A0/) has_loadcolor_store=1

    if (n ~ /MOVELD7C6A0/ || n ~ /MOVELD7198A0/ ||
        n ~ /MOVELD7CAA0/ || n ~ /MOVELD7202A0/ ||
        n ~ /MOVELD7CEA0/ || n ~ /MOVELD7206A0/ ||
        n ~ /MOVELD7D2A0/ || n ~ /MOVELD7210A0/ ||
        n ~ /MOVELD7D6A0/ || n ~ /MOVELD7214A0/ ||
        n ~ /MOVELD7DAA0/ || n ~ /MOVELD7218A0/) numeric_store_count++

    if (n ~ /PARSEINITAGSOURCE/ || n ~ /TSTBA0PLUS/ || n ~ /SUBQL1A0/ || n ~ /SUBLD1D0/) has_source_scan=1
    if (n ~ /^BLEW/ || n ~ /^BLEB/ || n ~ /^BLES/) has_source_guard=1
    if (n ~ /PARSEINITAGPPV/ || n ~ /MOVEB3BEA0/ || n ~ /MOVEB3190A0/) has_source_ppv=1
    if (n ~ /MEMORYALLOCATEMEMORY/ || n ~ /MOVELMEMFPUBLICMEMFCLEARA7/ || n ~ /MOVEL10001A7/ || n ~ /PEA12W/ || n ~ /PEACW/ || n ~ /PEA670W/ || n ~ /PEA29EW/) has_source_alloc=1

    if (n ~ /MOVEBA0PLUSA1PLUS/ || n ~ /MOVEBA0A1/) {
        saw_source_copy=1
    } else if (saw_source_copy && (n ~ /BNES/ || n ~ /BNEB/ || n ~ /TSTBFFFFFFFFA1/ || n ~ /TSTBFFFFFFFFA0/)) {
        has_source_copy_loop=1
        saw_source_copy=0
    } else if (saw_source_copy && n !~ /^MOVE/ && n !~ /^TST/ && n !~ /^BNE/) {
        saw_source_copy=0
    }

    if (n ~ /TSTLE6A0/ || n ~ /TSTL230A0/ || n ~ /MOVELA1E6A0/ || n ~ /MOVELA1230A0/) has_source_link_init=1
    if (n ~ /MOVELPARSEINICURRENTWEATHERBLOCKTEMPPTR8A1/ || n ~ /MOVEL24A78A2/ || n ~ /MOVEL248A78A2/) has_source_link_append=1

    if (n ~ /PARSEINISTRHORIZONTAL/ || n ~ /PARSEINITAGRIGHT/ || n ~ /PARSEINITAGCENTERHORIZONTALA/) horiz_tag_count++
    if (n ~ /CLRLDEA0/ || n ~ /CLRL222A0/) has_horiz_default=1
    if (n ~ /PARSEINITAGVERTICAL/ || n ~ /PARSEINITAGBOTTOM/ || n ~ /PARSEINITAGCENTERVERTICALA/) vert_tag_count++
    if (n ~ /CLRLE2A0/ || n ~ /CLRL226A0/) has_vert_default=1

    if (n ~ /STRINGCOPYPADNUL/ || n ~ /PEA2W/) has_id_copy=1
    if (n ~ /CLRBC1A0/ || n ~ /CLRB193A0/) has_id_terminator=1
    if (u == "RTS") has_return=1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INIT_RESET=" has_init_reset
    print "COMPARE_CALLS=" compare_calls
    print "READ_LONG_CALLS=" read_long_calls
    print "HAS_FILENAME_ALLOC=" has_filename_alloc
    print "HAS_FILENAME_TYPE_INIT=" has_filename_type_init
    print "HAS_HEAD_SEED=" has_head_seed
    print "HAS_CURRENT_BLOCK_GUARD=" has_current_block_guard
    print "LOADCOLOR_TAG_COUNT=" loadcolor_tag_count
    print "HAS_LOADCOLOR_STORE=" has_loadcolor_store
    print "NUMERIC_STORE_COUNT=" numeric_store_count
    print "HAS_SOURCE_SCAN=" has_source_scan
    print "HAS_SOURCE_GUARD=" has_source_guard
    print "HAS_SOURCE_PPV=" has_source_ppv
    print "HAS_SOURCE_ALLOC=" has_source_alloc
    print "HAS_SOURCE_COPY_LOOP=" has_source_copy_loop
    print "HAS_SOURCE_LINK_INIT=" has_source_link_init
    print "HAS_SOURCE_LINK_APPEND=" has_source_link_append
    print "HORIZ_TAG_COUNT=" horiz_tag_count
    print "HAS_HORIZ_DEFAULT=" has_horiz_default
    print "VERT_TAG_COUNT=" vert_tag_count
    print "HAS_VERT_DEFAULT=" has_vert_default
    print "HAS_ID_COPY=" has_id_copy
    print "HAS_ID_TERMINATOR=" has_id_terminator
    print "HAS_RETURN=" has_return
}
