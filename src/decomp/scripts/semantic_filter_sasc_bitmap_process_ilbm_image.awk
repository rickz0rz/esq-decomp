BEGIN {
    has_entry=0
    has_status_init=0
    direct_tag_compare_count=0
    chunk_tag_call_count=0
    has_tag_dispatch=0
    has_crng_count_clear=0
    has_crng_slot_clear=0
    has_chunk_loop_guard=0
    has_size_guard=0
    has_read_call=0
    has_seek_call=0
    has_seek_skip_chunk=0
    has_cmap_call=0
    has_body_call=0
    has_body_status_store=0
    has_body_done_store=0
    has_bmhd_size_check=0
    has_bmhd_read=0
    has_camg_size_check=0
    has_camg_read=0
    has_camg_zero=0
    has_width_clamp=0
    has_bmhd_height_flag=0
    has_camg_height_flag=0
    has_height_clamp_220=0
    has_height_clamp_110=0
    has_crng_count_limit=0
    has_crng_size_check=0
    has_crng_read=0
    has_crng_low_clamp=0
    has_crng_high_clamp=0
    has_crng_disable=0
    has_crng_increment=0
    has_return=0
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
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^BITMAP_PROCESSILBMIMAGE:/ || u ~ /^BITMAP_PROCESSILBMIMAG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /MOVEQFFD0/ || n ~ /MOVEQLFFD0/ || n ~ /MOVEQ1D0/) has_status_init=1
    if (u ~ /'ILBM'/ || u ~ /'FORM'/ || u ~ /'BMHD'/ || u ~ /'CMAP'/ || u ~ /'BODY'/ || u ~ /'CAMG'/ || u ~ /'CRNG'/) direct_tag_compare_count++
    if (u ~ /BSR(\.W)? CHUNK_TAG/) chunk_tag_call_count++
    if (n ~ /CLRW184A0/ || n ~ /LEAB8A0A1/ || n ~ /ADD.WB8A0/) has_crng_count_clear=1
    if (n ~ /ADDIL0000009CD1/ || n ~ /LEA9CA0A1/) has_crng_slot_clear=1
    if (n ~ /CLEARCRNGTABLELOOP/ || n ~ /TSTL38A7/ || n ~ /BNEW___BITMAPPROCESSILBMIMAGE__77/) has_chunk_loop_guard=1
    if (n ~ /VALIDATECHUNKSIZENONZERO/ || n ~ /VALIDATECHUNKSIZESIGNED/ || n ~ /MOVEL2CA7D0/ || n ~ /TSTLD0BGT/ || n ~ /TSTLD0BPL/) has_size_guard=1
    if (n ~ /LVOREAD/) has_read_call=1
    if (n ~ /LVOSEEK/) has_seek_call=1
    if (u ~ /MOVEQ #0,D3/ || u ~ /CLR\.L -\(A7\)/) has_seek_skip_chunk=1
    if (n ~ /BRUSHLOADCOLORTEXTFONT/) has_cmap_call=1
    if (n ~ /BRUSHSTREAMFONTCHUNK/) has_body_call=1
    if (u ~ /MOVE\.L D0,-14\(A5\)/ || u ~ /MOVE\.L D0,\$34\(A7\)/) has_body_status_store=1
    if (n ~ /MOVEQ1D5/ || n ~ /MOVELD038A7/) has_body_done_store=1
    if (n ~ /MOVEQ20D1/ || n ~ /MOVEQL14D0/ || n ~ /CMPL2CA7D0/) has_bmhd_size_check=1
    if (n ~ /READBMHDPAYLOAD/ || n ~ /ADDAW0080A0/ || n ~ /ADDW80A0/) has_bmhd_read=1
    if (n ~ /CMPL8A5D3/ || n ~ /MOVEQL4D0/) has_camg_size_check=1
    if (n ~ /READCAMGMODE/ || n ~ /LEA148A0A1/ || n ~ /ADDW94A0/) has_camg_read=1
    if (n ~ /CLR.L148A0/ || n ~ /MOVE.LA0A1ADD.W94A1MOVEQL0D0MOVE.LD0A1/) has_camg_zero=1
    if (n ~ /BSET15D0/ || n ~ /ORIW8000D1/) has_width_clamp=1
    if (n ~ /BSET2151A0/ || n ~ /BSET297A0/) has_bmhd_height_flag=1
    if (n ~ /BSET2D0/ || n ~ /ORIW4D0/) has_camg_height_flag=1
    if (n ~ /MOVEW00DCD2130A0/ || n ~ /MOVEW00DCD2/ || n ~ /MOVEWDCA1/) has_height_clamp_220=1
    if (n ~ /MOVEQ110D1/ || n ~ /CMPIW6EA1/ || n ~ /MOVEW6EA1/) has_height_clamp_110=1
    if (u ~ /MOVE\.W 184\(A0\),D0/ || u ~ /ADD\.W #\$B8,A1/ || n ~ /BCCW___BITMAPPROCESSILBMIMAGE__73/) has_crng_count_limit=1
    if (n ~ /MOVEQ8D1CMPL8A5D1/ || n ~ /MOVEQL8D1/ && n ~ /CMPL2CA7D1/) has_crng_size_check=1
    if (n ~ /READCRNGENTRY/ || n ~ /LEA152A0A1/ || n ~ /LEA98A0A1/) has_crng_read=1
    if (n ~ /0000009E/ || n ~ /CMPIB1F6A0/ || n ~ /MOVEBD06A0/) has_crng_low_clamp=1
    if (n ~ /0000009F/ || n ~ /CMPIB1F7A0/ || n ~ /MOVEBD07A0/) has_crng_high_clamp=1
    if (n ~ /DISABLECRNGENTRY/ || n ~ /CLRW0A0D1L/ || n ~ /MOVEWD1A6/) has_crng_disable=1
    if (n ~ /ADDQW1184A0/ || n ~ /ADDQW1D0/) has_crng_increment=1
    if (u == "RTS") has_return=1
}

END {
    if (direct_tag_compare_count >= 7 || chunk_tag_call_count >= 7) has_tag_dispatch=1
    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_INIT=" has_status_init
    print "HAS_TAG_DISPATCH=" has_tag_dispatch
    print "HAS_CRNG_COUNT_CLEAR=" has_crng_count_clear
    print "HAS_CRNG_SLOT_CLEAR=" has_crng_slot_clear
    print "HAS_CHUNK_LOOP_GUARD=" has_chunk_loop_guard
    print "HAS_SIZE_GUARD=" has_size_guard
    print "HAS_READ_CALL=" has_read_call
    print "HAS_SEEK_CALL=" has_seek_call
    print "HAS_SEEK_SKIP_CHUNK=" has_seek_skip_chunk
    print "HAS_CMAP_CALL=" has_cmap_call
    print "HAS_BODY_CALL=" has_body_call
    print "HAS_BODY_STATUS_STORE=" has_body_status_store
    print "HAS_BODY_DONE_STORE=" has_body_done_store
    print "HAS_BMHD_SIZE_CHECK=" has_bmhd_size_check
    print "HAS_BMHD_READ=" has_bmhd_read
    print "HAS_CAMG_SIZE_CHECK=" has_camg_size_check
    print "HAS_CAMG_READ=" has_camg_read
    print "HAS_CAMG_ZERO=" has_camg_zero
    print "HAS_WIDTH_CLAMP=" has_width_clamp
    print "HAS_BMHD_HEIGHT_FLAG=" has_bmhd_height_flag
    print "HAS_CAMG_HEIGHT_FLAG=" has_camg_height_flag
    print "HAS_HEIGHT_CLAMP_220=" has_height_clamp_220
    print "HAS_HEIGHT_CLAMP_110=" has_height_clamp_110
    print "HAS_CRNG_COUNT_LIMIT=" has_crng_count_limit
    print "HAS_CRNG_SIZE_CHECK=" has_crng_size_check
    print "HAS_CRNG_READ=" has_crng_read
    print "HAS_CRNG_LOW_CLAMP=" has_crng_low_clamp
    print "HAS_CRNG_HIGH_CLAMP=" has_crng_high_clamp
    print "HAS_CRNG_DISABLE=" has_crng_disable
    print "HAS_CRNG_INCREMENT=" has_crng_increment
    print "HAS_RETURN=" has_return
}
