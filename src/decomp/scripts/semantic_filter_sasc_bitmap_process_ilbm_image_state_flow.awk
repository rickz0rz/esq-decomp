BEGIN {
    has_entry = 0
    has_status_init = 0
    has_done_init = 0
    has_loop_guard = 0
    has_tag_dispatch = 0
    direct_tag_count = 0
    chunk_tag_call_count = 0

    has_bmhd_path = 0
    saw_bmhd_size = 0
    saw_bmhd_read = 0
    saw_camg_zero = 0
    saw_width_flag = 0
    saw_height_flag = 0
    saw_clamp_220 = 0
    saw_clamp_110 = 0

    has_cmap_path = 0
    saw_cmap_call = 0
    saw_cmap_fail_guard = 0

    has_body_path = 0
    saw_body_call = 0
    saw_body_status = 0
    saw_body_done = 0

    has_camg_fallback_path = 0
    saw_camg_size = 0
    saw_camg_read = 0
    saw_camg_fail_done = 0
    saw_camg_fallback_zero = 0
    saw_camg_fallback_width = 0
    saw_camg_fallback_height = 0

    has_crng_path = 0
    saw_crng_limit = 0
    saw_crng_size = 0
    saw_crng_read = 0
    saw_crng_low_clamp = 0
    saw_crng_high_clamp = 0
    saw_crng_disable = 0
    saw_crng_increment = 0

    has_seek_skip_path = 0
    seek_call_count = 0

    has_return_status = 0
    saw_status_seed = 0
    saw_status_store = 0
    saw_bmhd_width_cmp = 0
    saw_bmhd_height_cmp = 0
    saw_bmhd_type_gate = 0
    saw_body_status_store = 0
    saw_camg_reset = 0
    saw_crng_counter_ref = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^BITMAP_PROCESSILBMIMAGE:/ || u ~ /^BITMAP_PROCESSILBMIMAG[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if ((u ~ /MOVEQ/ && u ~ /D0/ && (u ~ /#-1/ || u ~ /#\$FF/)) ||
        u ~ /MOVEQ\.L #\$FF,D0/) {
        saw_status_seed = 1
    }
    if (u ~ /MOVE\.L D0,-14\(A5\)/ || u ~ /MOVE\.L D0,\$34\(A7\)/) {
        saw_status_store = 1
    }
    if (saw_status_seed && saw_status_store) has_status_init = 1
    if (n ~ /MOVEQ0D5/ || n ~ /CLRL38A7/) {
        has_done_init = 1
    }
    if (n ~ /TSTWD5/ || n ~ /TSTL38A7/) {
        has_loop_guard = 1
    }

    if (u ~ /'ILBM'/ || u ~ /'FORM'/ || u ~ /'BMHD'/ || u ~ /'CMAP'/ ||
        u ~ /'BODY'/ || u ~ /'CAMG'/ || u ~ /'CRNG'/) {
        direct_tag_count++
    }
    if (u ~ /BSR(\.W)? CHUNK_TAG/) {
        chunk_tag_call_count++
    }

    if (u ~ /MOVEQ #20,D1/ || u ~ /MOVEQ\.L #\$14,D0/ || u ~ /CMP\.L \$2C\(A7\),D0/) {
        saw_bmhd_size = 1
    }
    if (u ~ /ADDA\.W #\$0080,A0/ || u ~ /ADD\.W #\$80,A0/ || u ~ /LEA \$80\(A0\),A6/) {
        saw_bmhd_read = 1
    }
    if (u ~ /CMPI\.W #\$0140,128\(A0\)/ || u ~ /CMPI\.W #\$140,\(A6\)/) {
        saw_bmhd_width_cmp = 1
    }
    if (u ~ /CMPI\.W #\$00C8,D0/ || u ~ /CMPI\.W #\$C8,D0/ ||
        u ~ /CMPI\.W #\$00DC,130\(A0\)/ || u ~ /CMPI\.W #\$DC,\(A1\)/ ||
        u ~ /CMPI\.W #\$6E,\(A1\)/ || u ~ /MOVEQ #110,D1/) {
        saw_bmhd_height_cmp = 1
    }
    if (u ~ /MOVE\.B 190\(A0\),D0/ || u ~ /MOVE\.B \$BE\(A0\),D0/) {
        saw_bmhd_type_gate = 1
    }
    if (u ~ /MOVE\.L D0,148\(A0\)/ || u ~ /CLR\.L 148\(A0\)/ ||
        u ~ /MOVE\.L D0,\(A1\)/ && u ~ /\$94\(A0\)/) {
        saw_camg_zero = 1
    }
    if (n ~ /BSET15D0/ || n ~ /ORIW8000D1/) {
        saw_width_flag = 1
    }
    if (n ~ /BSET2151A0/ || n ~ /ORIW4D0/) {
        saw_height_flag = 1
    }
    if (n ~ /MOVEW00DCD2130A0/ || n ~ /MOVEWDCA1/) {
        saw_clamp_220 = 1
    }
    if (n ~ /MOVEQ110D1/ || n ~ /MOVEW6EA1/) {
        saw_clamp_110 = 1
    }
    if (saw_bmhd_size && saw_bmhd_read && saw_bmhd_width_cmp && saw_bmhd_height_cmp &&
        saw_bmhd_type_gate && saw_camg_zero && saw_width_flag && saw_height_flag &&
        saw_clamp_220 && saw_clamp_110) {
        has_bmhd_path = 1
    }

    if (u ~ /BRUSH_LOADCOLORTEXTFONT/ || u ~ /BRUSHLOADCOLORTEXTFONT/) {
        saw_cmap_call = 1
    }
    if (u ~ /SUBQ\.L #1,D0/ || u ~ /SUBQ\.L #\$1,D0/) {
        saw_cmap_fail_guard = 1
    }
    if (saw_cmap_call && saw_cmap_fail_guard) {
        has_cmap_path = 1
    }

    if (u ~ /BRUSH_STREAMFONTCHUNK/ || u ~ /BRUSHSTREAMFONTCHUNK/) {
        saw_body_call = 1
    }
    if (u ~ /MOVE\.L D0,-14\(A5\)/ || u ~ /MOVE\.L D0,\$34\(A7\)/) {
        saw_body_status = 1
        saw_body_status_store = 1
    }
    if (n ~ /MOVEQ1D5/ || n ~ /MOVEQL1D0MOVELD038A7/) {
        saw_body_done = 1
    }
    if (saw_body_call && saw_body_status && saw_body_done) {
        has_body_path = 1
    }

    if (u ~ /CMP\.L -8\(A5\),D3/ || u ~ /MOVEQ\.L #\$4,D0/ && u ~ /CMP\.L \$2C\(A7\),D0/) {
        saw_camg_size = 1
    }
    if (u ~ /LEA 148\(A0\),A1/ || u ~ /ADD\.W #\$94,A0/ && u ~ /BSR\.W _LVOREAD/) {
        saw_camg_read = 1
    }
    if (u ~ /CLR\.L 148\(A0\)/ || u ~ /ADD\.W #\$94,A0/ && u ~ /CLR\.L \(A0\)/) {
        saw_camg_reset = 1
    }
    if (u ~ /MOVEQ #1,D5/ && u ~ /MOVEQ #0,D0/ ||
        u ~ /MOVEQ\.L #\$1,D0/ && u ~ /MOVE\.L D0,\$38\(A7\)/) {
        saw_camg_fail_done = 1
        saw_camg_fallback_zero = 1
    }
    if (u ~ /\.POST_CAMG_FALLBACK_FLAGS:/ || n ~ /ORIW8000D1/) {
        saw_camg_fallback_width = 1
    }
    if (n ~ /BSET2D0/ || u ~ /ORI\.W #\$4,D0/) {
        saw_camg_fallback_height = 1
    }
    if (saw_camg_size && saw_camg_read && saw_camg_reset && saw_camg_fail_done &&
        saw_camg_fallback_zero && saw_camg_fallback_width && saw_camg_fallback_height) {
        has_camg_fallback_path = 1
    }

    if (u ~ /MOVE\.W 184\(A0\),D0/ || u ~ /ADD\.W #\$B8,A1/ && u ~ /MOVE\.W \(A1\),D0/) {
        saw_crng_limit = 1
        saw_crng_counter_ref = 1
    }
    if (u ~ /MOVEQ #8,D1/ || u ~ /MOVEQ\.L #\$8,D1/) {
        saw_crng_size = 1
    }
    if (u ~ /MOVEQ #8,D3/ || u ~ /LEA \$98\(A0\),A1/) {
        saw_crng_read = 1
    }
    if (u ~ /CMPI\.B #\$1F,0\(A0,D1\.L\)/ || u ~ /CMPI\.B #\$1F,\$6\(A0\)/) {
        saw_crng_low_clamp = 1
    }
    if (u ~ /CMPI\.B #\$1F,\$7\(A0\)/ || u ~ /CMPI\.B #\$1F,0\(A0,D1\.L\)/) {
        saw_crng_high_clamp = 1
    }
    if (u ~ /\.DISABLE_CRNG_ENTRY:/ || u ~ /CLR\.W 0\(A0,D1\.L\)/ || u ~ /MOVE\.W D1,\(A6\)/) {
        saw_crng_disable = 1
    }
    if (u ~ /ADDQ\.W #1,184\(A0\)/ || u ~ /ADDQ\.W #\$1,D0/ && u ~ /MOVE\.W D0,\(A0\)/ ||
        u ~ /ADDQ\.W #1,D0/ && u ~ /MOVE\.W D0,\(A0\)/) {
        saw_crng_increment = 1
    }
    if (saw_crng_counter_ref && saw_crng_limit && saw_crng_size && saw_crng_read && saw_crng_low_clamp &&
        saw_crng_high_clamp && saw_crng_disable && saw_crng_increment) {
        has_crng_path = 1
    }

    if (n ~ /LVOSEEK/) {
        seek_call_count++
    }
    if (seek_call_count >= 1) {
        has_seek_skip_path = 1
    }

    if (n ~ /MOVEL14A5D0/ || n ~ /MOVEL34A7D0/) {
        has_return_status = 1
    }
}

END {
    if (direct_tag_count >= 7 || chunk_tag_call_count >= 7) {
        has_tag_dispatch = 1
    }
    print "HAS_ENTRY=" has_entry
    print "HAS_STATUS_INIT=" has_status_init
    print "HAS_DONE_INIT=" has_done_init
    print "HAS_LOOP_GUARD=" has_loop_guard
    print "HAS_TAG_DISPATCH=" has_tag_dispatch
    print "HAS_SEEK_SKIP_PATH=" has_seek_skip_path
    print "HAS_RETURN_STATUS=" has_return_status
}
