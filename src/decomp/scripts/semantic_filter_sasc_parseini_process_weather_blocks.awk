BEGIN {
    has_entry=0
    has_init_reset=0
    has_filename_temp_reset=0
    has_current_block_store=0
    has_list_head_seed=0
    has_current_block_guard=0
    compare_calls=0
    has_alloc_brush=0
    read_long_calls=0
    has_alloc_mem=0
    has_copy_id=0
    has_filename=0
    has_loadcolor=0
    has_all=0
    has_none=0
    has_text=0
    has_xpos=0
    has_type=0
    has_dither=0
    has_ypos=0
    has_xsource=0
    has_ysource=0
    has_sizex=0
    has_sizey=0
    has_source=0
    has_ppv=0
    has_horizontal=0
    has_right=0
    has_center_h=0
    has_vertical=0
    has_bottom=0
    has_center_v=0
    has_id=0
    has_type_init=0
    has_type_dither=0
    has_type_ppv=0
    loadcolor_store_count=0
    has_xpos_store=0
    has_ypos_store=0
    has_xsource_store=0
    has_ysource_store=0
    has_sizex_store=0
    has_sizey_store=0
    has_source_list=0
    has_source_link=0
    has_source_tail=0
    has_source_temp_store=0
    has_source_len_scan=0
    has_source_len_guard=0
    has_source_alloc_flags=0
    has_source_alloc_size=0
    has_source_alloc_line=0
    has_source_next_clear=0
    has_source_copy_loop=0
    align_h_store_count=0
    align_v_store_count=0
    has_id_copy_len=0
    has_id_terminator=0
    has_return=0
    saw_source_len_tst=0
    saw_source_copy_move=0
    saw_current_block_guard_tst=0
}
function trim(s,t){t=s; sub(/;.*/,"",t); sub(/^[ \t]+/,"",t); sub(/[ \t]+$/,"",t); return t}
{
    line=trim($0)
    if(line=="") next
    gsub(/[ \t]+/," ",line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/,"",n)

    if (n ~ /TSTLD0|TSTLD6/) {
        saw_source_len_tst=1
    } else if (saw_source_len_tst && n ~ /^BLEW/) {
        has_source_len_guard=1
        saw_source_len_tst=0
    } else if (n !~ /^B/) {
        saw_source_len_tst=0
    }

    if (n ~ /MOVEBA0A1/ || n ~ /MOVEBA0PLUSA1PLUS/) {
        saw_source_copy_move=1
    } else if (saw_source_copy_move && n ~ /^BNES/) {
        has_source_copy_loop=1
        saw_source_copy_move=0
    } else if (saw_source_copy_move && (n ~ /TSTBFFFFFFFFA0/ || n ~ /TSTBFFFFFFFFA1/)) {
        has_source_copy_loop=1
        saw_source_copy_move=0
    } else if (saw_source_copy_move && n !~ /^MOVE/ && n !~ /^TST/) {
        saw_source_copy_move=0
    }

    if (n ~ /TSTLPARSEINICURRENTWEATHERBLOCKPTR/) {
        saw_current_block_guard_tst=1
    } else if (saw_current_block_guard_tst && n ~ /^BEQ(W|S|B)/) {
        has_current_block_guard=1
        saw_current_block_guard_tst=0
    } else if (saw_current_block_guard_tst && n !~ /^B/) {
        saw_current_block_guard_tst=0
    }

    if (u ~ /^PARSEINI_PROCESSWEATHERBLOCKS:/ || u ~ /^PARSEINI_PROCESSWEATHERBLOC[A-Z0-9_]*:/) has_entry=1
    if ((n ~ /CLRLPARSEINICURRENTWEATHERBLOCKTEMP/ || n ~ /CLRLPARSEINICURRENTWEATHERBLOCKPTR/) ||
        (n ~ /MOVELA0PARSEINICURRENTWEATHERBLOCKTEMP/ || n ~ /MOVELA0PARSEINICURRENTWEATHERBLOCKPTR/)) has_init_reset=1
    if (n ~ /CLRLPARSEINICURRENTWEATHERBLOCKTEMP/) has_filename_temp_reset=1
    if (n ~ /MOVELD0PARSEINICURRENTWEATHERBLOCKPTR/) has_current_block_store=1
    if (n ~ /MOVELD0PARSEINIPARSEDDESCRIPTORLISTHEA/) has_list_head_seed=1

    if (n ~ /STRINGCOMPARENOCASE/) compare_calls++
    if (n ~ /PARSEINITAGFILENAMEWEATHERBLO/) has_filename=1
    if (n ~ /PARSEINISTRLOADCOLOR/) has_loadcolor=1
    if (n ~ /PARSEINITAGALL/) has_all=1
    if (n ~ /PARSEINITAGNONE/) has_none=1
    if (n ~ /PARSEINITAGTEXT/) has_text=1
    if (n ~ /PARSEINITAGXPOS/) has_xpos=1
    if (n ~ /PARSEINITAGTYPE/) has_type=1
    if (n ~ /PARSEINITAGDITHER/) has_dither=1
    if (n ~ /PARSEINITAGYPOS/) has_ypos=1
    if (n ~ /PARSEINITAGXSOURCE/) has_xsource=1
    if (n ~ /PARSEINITAGYSOURCE/) has_ysource=1
    if (n ~ /PARSEINITAGSIZEX/) has_sizex=1
    if (n ~ /PARSEINITAGSIZEY/) has_sizey=1
    if (n ~ /PARSEINITAGSOURCE/) has_source=1
    if (n ~ /PARSEINITAGPPV/) has_ppv=1
    if (n ~ /PARSEINISTRHORIZONTAL/) has_horizontal=1
    if (n ~ /PARSEINITAGRIGHT/) has_right=1
    if (n ~ /PARSEINITAGCENTERHORIZONTALA/) has_center_h=1
    if (n ~ /PARSEINITAGVERTICAL/) has_vertical=1
    if (n ~ /PARSEINITAGBOTTOM/) has_bottom=1
    if (n ~ /PARSEINITAGCENTERVERTICALA/) has_center_v=1
    if (n ~ /PARSEINITAGID/) has_id=1

    if (n ~ /BRUSHALLOCBRUSHNODE/) has_alloc_brush=1
    if (n ~ /PARSEREADSIGNEDLONGSKIPCLASS3A/) read_long_calls++
    if (n ~ /MEMORYALLOCATEMEMORY/) has_alloc_mem=1
    if (n ~ /STRINGCOPYPADNUL/) has_copy_id=1

    if ((n ~ /MOVEB1BEA0/ || n ~ /MOVEB1190A0/)) has_type_init=1
    if ((n ~ /MOVEB2BEA0/ || n ~ /MOVEB2190A0/)) has_type_dither=1
    if ((n ~ /MOVEB3BEA0/ || n ~ /MOVEB3190A0/)) has_type_ppv=1

    if (n ~ /CLRLC2A0|CLRL194A0|MOVELD0C2A0|MOVELD0194A0/) loadcolor_store_count++

    if (n ~ /MOVELD7C6A0|MOVELD7198A0/) has_xpos_store=1
    if (n ~ /MOVELD7CAA0|MOVELD7202A0/) has_ypos_store=1
    if (n ~ /MOVELD7CEA0|MOVELD7206A0/) has_xsource_store=1
    if (n ~ /MOVELD7D2A0|MOVELD7210A0/) has_ysource_store=1
    if (n ~ /MOVELD7D6A0|MOVELD7214A0/) has_sizex_store=1
    if (n ~ /MOVELD7DAA0|MOVELD7218A0/) has_sizey_store=1

    if (n ~ /TSTLE6A0|TSTL230A0/) has_source_list=1
    if (n ~ /MOVELA1E6A0|MOVELA1230A0/) has_source_link=1
    if (n ~ /MOVEL24A78A2|MOVELPARSEINICURRENTWEATHERBLOCKTEMP(PTR)?8A1/) has_source_tail=1
    if (n ~ /MOVELD0PARSEINICURRENTWEATHERBLOCKTEMP/) has_source_temp_store=1
    if ((n ~ /TSTBA0|TSTBA0PLUS/) ||
        (n ~ /MOVEBA0PLUSA1PLUS/ && has_source_next_clear == 0)) has_source_len_scan=1
    if (n ~ /MOVELMEMFPUBLICMEMFCLEARA7/ || n ~ /MOVEL10001A7/) has_source_alloc_flags=1
    if (n ~ /PEA12W/ || n ~ /PEACW/) has_source_alloc_size=1
    if (n ~ /PEA670W/ || n ~ /PEA29EW/) has_source_alloc_line=1
    if (n ~ /CLRLB8A0|CLRL8A0/) has_source_next_clear=1

    if (n ~ /CLRLDEA0|CLRL222A0|MOVELD0DEA0|MOVELD0222A0/) align_h_store_count++
    if (n ~ /CLRLE2A0|CLRL226A0|MOVELD0E2A0|MOVELD0226A0/) align_v_store_count++

    if (n ~ /PEA2W/) has_id_copy_len=1
    if (n ~ /CLRBC1A0|CLRB193A0/) has_id_terminator=1
    if (u=="RTS") has_return=1
}
END {
    print "HAS_ENTRY="has_entry
    print "HAS_INIT_RESET="has_init_reset
    print "HAS_FILENAME_TEMP_RESET="has_filename_temp_reset
    print "HAS_CURRENT_BLOCK_STORE="has_current_block_store
    print "HAS_LIST_HEAD_SEED="has_list_head_seed
    print "HAS_CURRENT_BLOCK_GUARD="has_current_block_guard
    print "COMPARE_CALLS="compare_calls
    print "HAS_ALLOC_BRUSH="has_alloc_brush
    print "READ_LONG_CALLS="read_long_calls
    print "HAS_ALLOC_MEM="has_alloc_mem
    print "HAS_COPY_ID="has_copy_id
    print "HAS_FILENAME="has_filename
    print "HAS_LOADCOLOR="has_loadcolor
    print "HAS_ALL="has_all
    print "HAS_NONE="has_none
    print "HAS_TEXT="has_text
    print "HAS_XPOS="has_xpos
    print "HAS_TYPE="has_type
    print "HAS_DITHER="has_dither
    print "HAS_YPOS="has_ypos
    print "HAS_XSOURCE="has_xsource
    print "HAS_YSOURCE="has_ysource
    print "HAS_SIZEX="has_sizex
    print "HAS_SIZEY="has_sizey
    print "HAS_SOURCE="has_source
    print "HAS_PPV="has_ppv
    print "HAS_HORIZONTAL="has_horizontal
    print "HAS_RIGHT="has_right
    print "HAS_CENTER_H="has_center_h
    print "HAS_VERTICAL="has_vertical
    print "HAS_BOTTOM="has_bottom
    print "HAS_CENTER_V="has_center_v
    print "HAS_ID="has_id
    print "HAS_TYPE_INIT="has_type_init
    print "HAS_TYPE_DITHER="has_type_dither
    print "HAS_TYPE_PPV="has_type_ppv
    print "LOADCOLOR_STORE_COUNT="loadcolor_store_count
    print "HAS_XPOS_STORE="has_xpos_store
    print "HAS_YPOS_STORE="has_ypos_store
    print "HAS_XSOURCE_STORE="has_xsource_store
    print "HAS_YSOURCE_STORE="has_ysource_store
    print "HAS_SIZEX_STORE="has_sizex_store
    print "HAS_SIZEY_STORE="has_sizey_store
    print "HAS_SOURCE_LIST="has_source_list
    print "HAS_SOURCE_LINK="has_source_link
    print "HAS_SOURCE_TAIL="has_source_tail
    print "HAS_SOURCE_TEMP_STORE="has_source_temp_store
    print "HAS_SOURCE_LEN_SCAN="has_source_len_scan
    print "HAS_SOURCE_LEN_GUARD="has_source_len_guard
    print "HAS_SOURCE_ALLOC_FLAGS="has_source_alloc_flags
    print "HAS_SOURCE_ALLOC_SIZE="has_source_alloc_size
    print "HAS_SOURCE_ALLOC_LINE="has_source_alloc_line
    print "HAS_SOURCE_NEXT_CLEAR="has_source_next_clear
    print "HAS_SOURCE_COPY_LOOP="has_source_copy_loop
    print "ALIGN_H_STORE_COUNT="align_h_store_count
    print "ALIGN_V_STORE_COUNT="align_v_store_count
    print "HAS_ID_COPY_LEN="has_id_copy_len
    print "HAS_ID_TERMINATOR="has_id_terminator
    print "HAS_RETURN="has_return
}
