BEGIN {
    has_entry = 0
    init_stage = 0
    has_filename_compare = 0
    has_filename_alloc = 0
    has_filename_type_init = 0
    has_filename_head_store = 0
    has_current_block_guard = 0

    loadcolor_stage = 0
    loadcolor_store_count = 0

    numeric_key_stage = 0
    numeric_store_count = 0
    saw_parse_call = 0

    type_stage = 0

    source_stage = 0
    saw_source_scan_test = 0
    saw_source_scan_bne = 0
    saw_source_copy_move = 0
    has_source_len_calc = 0
    has_source_alloc = 0
    has_source_next_clear = 0
    has_source_copy_loop = 0
    has_source_attach_head = 0
    has_source_attach_tail = 0

    horiz_stage = 0
    vert_stage = 0
    has_id_flow = 0
    has_return = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function advance_stage(stage, target) {
    if (stage == target - 1) {
        return target
    }
    return stage
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^PARSEINI_PROCESSWEATHERBLOCKS:/ || u ~ /^PARSEINI_PROCESSWEATHERBLOC[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (n ~ /TSTLPARSEINIPARSEDDESCRIPTORLISTHEA/) {
        init_stage = advance_stage(init_stage, 1)
    }
    if (init_stage >= 1 && (n ~ /CLRLPARSEINICURRENTWEATHERBLOCKTEMP/ || n ~ /MOVELA0PARSEINICURRENTWEATHERBLOCKTEMP/)) {
        init_stage = advance_stage(init_stage, 2)
    }
    if (init_stage >= 2 && (n ~ /CLRLPARSEINICURRENTWEATHERBLOCKPTR/ || n ~ /MOVELA0PARSEINICURRENTWEATHERBLOCKPTR/)) {
        init_stage = advance_stage(init_stage, 3)
    }

    if (n ~ /PARSEINITAGFILENAMEWEATHERBLO/) {
        has_filename_compare = 1
    }
    if (n ~ /BRUSHALLOCBRUSHNODE/) {
        has_filename_alloc = 1
    }
    if (n ~ /MOVEB1BEA0/ || n ~ /MOVEB1190A0/) {
        has_filename_type_init = 1
    }
    if (n ~ /MOVELD0PARSEINIPARSEDDESCRIPTORLISTHEA/) {
        has_filename_head_store = 1
    }
    if (n ~ /TSTLPARSEINICURRENTWEATHERBLOCKPTR/ && n !~ /PARSEINIPARSEDDESCRIPTORLISTHEAD/) {
        has_current_block_guard = 1
    }

    if (n ~ /PARSEINISTRLOADCOLOR/) {
        loadcolor_stage = advance_stage(loadcolor_stage, 1)
    }
    if (loadcolor_stage >= 1 && n ~ /PARSEINITAGALL/) {
        loadcolor_stage = advance_stage(loadcolor_stage, 2)
    }
    if (loadcolor_stage >= 2 && (n ~ /CLRLC2A0/ || n ~ /CLRL194A0/)) {
        loadcolor_store_count++
        loadcolor_stage = advance_stage(loadcolor_stage, 3)
    }
    if (loadcolor_stage >= 3 && n ~ /PARSEINITAGNONE/) {
        loadcolor_stage = advance_stage(loadcolor_stage, 4)
    }
    if (loadcolor_stage >= 4 && (n ~ /MOVEQL2D0/ || n ~ /MOVEQ2D0/)) {
        loadcolor_stage = advance_stage(loadcolor_stage, 5)
    }
    if (loadcolor_stage >= 5 && (n ~ /MOVELD0C2A0/ || n ~ /MOVELD0194A0/)) {
        loadcolor_store_count++
        loadcolor_stage = advance_stage(loadcolor_stage, 6)
    }
    if (loadcolor_stage >= 6 && n ~ /PARSEINITAGTEXT/) {
        loadcolor_stage = advance_stage(loadcolor_stage, 7)
    }
    if (loadcolor_stage >= 7 && (n ~ /MOVEQL3D0/ || n ~ /MOVEQ3D0/)) {
        loadcolor_stage = advance_stage(loadcolor_stage, 8)
    }
    if (loadcolor_stage >= 8 && (n ~ /MOVELD0C2A0/ || n ~ /MOVELD0194A0/)) {
        loadcolor_store_count++
        loadcolor_stage = advance_stage(loadcolor_stage, 9)
    }
    if (loadcolor_stage >= 9 && (n ~ /MOVEQL1D0/ || n ~ /MOVEQ1D0/)) {
        loadcolor_stage = advance_stage(loadcolor_stage, 10)
    }
    if (loadcolor_stage >= 10 && (n ~ /MOVELD0C2A0/ || n ~ /MOVELD0194A0/)) {
        loadcolor_store_count++
        loadcolor_stage = advance_stage(loadcolor_stage, 11)
    }

    if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) {
        saw_parse_call = 1
    } else if (saw_parse_call && (n ~ /MOVELD7C6A0/ || n ~ /MOVELD7198A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 2)
        saw_parse_call = 0
    } else if (saw_parse_call && (n ~ /MOVELD7CAA0/ || n ~ /MOVELD7202A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 4)
        saw_parse_call = 0
    } else if (saw_parse_call && (n ~ /MOVELD7CEA0/ || n ~ /MOVELD7206A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 6)
        saw_parse_call = 0
    } else if (saw_parse_call && (n ~ /MOVELD7D2A0/ || n ~ /MOVELD7210A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 8)
        saw_parse_call = 0
    } else if (saw_parse_call && (n ~ /MOVELD7D6A0/ || n ~ /MOVELD7214A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 10)
        saw_parse_call = 0
    } else if (saw_parse_call && (n ~ /MOVELD7DAA0/ || n ~ /MOVELD7218A0/)) {
        numeric_store_count++
        numeric_key_stage = advance_stage(numeric_key_stage, 12)
        saw_parse_call = 0
    } else if (saw_parse_call && n !~ /^MOVE/ && n !~ /^ADDQW4A7/) {
        saw_parse_call = 0
    }

    if (numeric_key_stage == 0 && n ~ /PARSEINITAGXPOS/) numeric_key_stage = 1
    if (numeric_key_stage == 2 && n ~ /PARSEINITAGYPOS/) numeric_key_stage = 3
    if (numeric_key_stage == 4 && n ~ /PARSEINITAGXSOURCE/) numeric_key_stage = 5
    if (numeric_key_stage == 6 && n ~ /PARSEINITAGYSOURCE/) numeric_key_stage = 7
    if (numeric_key_stage == 8 && n ~ /PARSEINITAGSIZEX/) numeric_key_stage = 9
    if (numeric_key_stage == 10 && n ~ /PARSEINITAGSIZEY/) numeric_key_stage = 11

    if (n ~ /PARSEINITAGTYPE/) {
        type_stage = advance_stage(type_stage, 1)
    }
    if (type_stage >= 1 && n ~ /PARSEINITAGDITHER/) {
        type_stage = advance_stage(type_stage, 2)
    }
    if (type_stage >= 2 && (n ~ /MOVEB2BEA0/ || n ~ /MOVEB2190A0/)) {
        type_stage = advance_stage(type_stage, 3)
    }

    if (n ~ /PARSEINITAGSOURCE/ && source_stage == 0) {
        source_stage = 1
    }
    if (source_stage >= 1 && (n ~ /TSTBA0PLUS/ || n ~ /TSTBA0/)) {
        saw_source_scan_test = 1
    }
    if (saw_source_scan_test && n ~ /^BNES/) {
        saw_source_scan_bne = 1
    }
    if (source_stage >= 1 && saw_source_scan_test &&
        (n ~ /SUBQL1A0/ || n ~ /SUBALA2A0/ || n ~ /SUBLD1D0/ || n ~ /MOVELA0D1/)) {
        has_source_len_calc = 1
        source_stage = advance_stage(source_stage, 2)
    }
    if (source_stage >= 2 && n ~ /PARSEINITAGPPV/) {
        source_stage = advance_stage(source_stage, 3)
    }
    if (source_stage >= 3 && (n ~ /MOVEB3BEA0/ || n ~ /MOVEB3190A0/)) {
        source_stage = advance_stage(source_stage, 4)
    }
    if (source_stage >= 2 && n ~ /MEMORYALLOCATEMEMORY/) {
        has_source_alloc = 1
        source_stage = advance_stage(source_stage, 5)
    }
    if (source_stage >= 5 && (n ~ /CLRLB8A0/ || n ~ /CLRL8A0/)) {
        has_source_next_clear = 1
        source_stage = advance_stage(source_stage, 6)
    }
    if (source_stage >= 6 && (n ~ /MOVEBA0PLUSA1PLUS/ || n ~ /MOVEBA0A1/)) {
        saw_source_copy_move = 1
    } else if (saw_source_copy_move && (n ~ /^BNES/ || n ~ /TSTBFFFFFFFFA0/ || n ~ /TSTBFFFFFFFFA1/)) {
        has_source_copy_loop = 1
        source_stage = advance_stage(source_stage, 7)
        saw_source_copy_move = 0
    } else if (saw_source_copy_move && n !~ /^MOVE/ && n !~ /^TST/) {
        saw_source_copy_move = 0
    }
    if (source_stage >= 7 && (n ~ /MOVELA1E6A0/ || n ~ /MOVELA1230A0/ || n ~ /MOVEALPARSEINICURRENTWEATHERBLOCKTEMP(A|PTR)A1/)) {
        has_source_attach_head = 1
        source_stage = advance_stage(source_stage, 8)
    }
    if (source_stage >= 7 && (n ~ /MOVEL24A78A2/ || n ~ /MOVEL24A18A2/ || n ~ /MOVELPARSEINICURRENTWEATHERBLOCKTEMP8A2/ || n ~ /MOVELPARSEINICURRENTWEATHERBLOCKTEMP8A1/ || n ~ /MOVEAL8A5A1/)) {
        has_source_attach_tail = 1
        source_stage = advance_stage(source_stage, 9)
    }

    if (n ~ /PARSEINISTRHORIZONTAL/) {
        horiz_stage = advance_stage(horiz_stage, 1)
    }
    if (horiz_stage >= 1 && n ~ /PARSEINITAGRIGHT/) {
        horiz_stage = advance_stage(horiz_stage, 2)
    }
    if (horiz_stage >= 2 && (n ~ /MOVEQL2D0/ || n ~ /MOVEQ2D0/)) {
        horiz_stage = advance_stage(horiz_stage, 3)
    }
    if (horiz_stage >= 3 && (n ~ /MOVELD0DEA0/ || n ~ /MOVELD0222A0/)) {
        horiz_stage = advance_stage(horiz_stage, 4)
    }
    if (horiz_stage >= 4 && n ~ /PARSEINITAGCENTERHORIZONTALA/) {
        horiz_stage = advance_stage(horiz_stage, 5)
    }
    if (horiz_stage >= 5 && (n ~ /MOVEQL1D0/ || n ~ /MOVEQ1D0/)) {
        horiz_stage = advance_stage(horiz_stage, 6)
    }
    if (horiz_stage >= 6 && (n ~ /MOVELD0DEA0/ || n ~ /MOVELD0222A0/)) {
        horiz_stage = advance_stage(horiz_stage, 7)
    }
    if (horiz_stage >= 7 && (n ~ /CLRLDEA0/ || n ~ /CLRL222A0/)) {
        horiz_stage = advance_stage(horiz_stage, 8)
    }

    if (n ~ /PARSEINITAGVERTICAL/) {
        vert_stage = advance_stage(vert_stage, 1)
    }
    if (vert_stage >= 1 && n ~ /PARSEINITAGBOTTOM/) {
        vert_stage = advance_stage(vert_stage, 2)
    }
    if (vert_stage >= 2 && (n ~ /MOVEQL2D0/ || n ~ /MOVEQ2D0/)) {
        vert_stage = advance_stage(vert_stage, 3)
    }
    if (vert_stage >= 3 && (n ~ /MOVELD0E2A0/ || n ~ /MOVELD0226A0/)) {
        vert_stage = advance_stage(vert_stage, 4)
    }
    if (vert_stage >= 4 && n ~ /PARSEINITAGCENTERVERTICALA/) {
        vert_stage = advance_stage(vert_stage, 5)
    }
    if (vert_stage >= 5 && (n ~ /MOVEQL1D0/ || n ~ /MOVEQ1D0/)) {
        vert_stage = advance_stage(vert_stage, 6)
    }
    if (vert_stage >= 6 && (n ~ /MOVELD0E2A0/ || n ~ /MOVELD0226A0/)) {
        vert_stage = advance_stage(vert_stage, 7)
    }
    if (vert_stage >= 7 && (n ~ /CLRLE2A0/ || n ~ /CLRL226A0/)) {
        vert_stage = advance_stage(vert_stage, 8)
    }

    if (n ~ /PARSEINITAGID/ && n !~ /PARSEINITAGDITHER/) {
        has_id_flow = 1
    }
    if (u ~ /^RTS$/) {
        has_return = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_INIT_RESET_FLOW=" (init_stage >= 3 ? 1 : 0)
    print "HAS_FILENAME_ALLOC_FLOW=" (has_filename_compare && has_filename_alloc && has_filename_type_init ? 1 : 0)
    print "HAS_FILENAME_HEAD_STORE=" has_filename_head_store
    print "HAS_CURRENT_BLOCK_GUARD=" has_current_block_guard
    print "HAS_LOADCOLOR_FLOW=" (loadcolor_stage >= 11 && loadcolor_store_count >= 4 ? 1 : 0)
    print "HAS_NUMERIC_FIELD_FLOW=" (numeric_key_stage >= 12 && numeric_store_count >= 6 ? 1 : 0)
    print "HAS_TYPE_DITHER_FLOW=" (type_stage >= 3 ? 1 : 0)
    print "HAS_SOURCE_SCAN_AND_ALLOC_FLOW=" (source_stage >= 7 && has_source_len_calc && has_source_alloc && has_source_next_clear && has_source_copy_loop ? 1 : 0)
    print "HAS_SOURCE_ATTACH_HEAD=" has_source_attach_head
    print "HAS_SOURCE_ATTACH_TAIL=" has_source_attach_tail
    print "HAS_HORIZONTAL_ALIGN_FLOW=" (horiz_stage >= 8 ? 1 : 0)
    print "HAS_VERTICAL_ALIGN_FLOW=" (vert_stage >= 8 ? 1 : 0)
    print "HAS_ID_FLOW=" has_id_flow
    print "HAS_RETURN=" has_return
}
