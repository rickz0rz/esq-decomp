BEGIN {
    has_entry = 0
    has_alloc_call = 0
    has_alloc_372 = 0
    has_init_bitmap = 0
    has_row_pair_copy = 0
    has_label_copy = 0
    has_width_src = 0
    has_width_dst = 0
    has_width_word = 0
    has_height_src = 0
    has_height_dst = 0
    has_height_word = 0
    has_alloc_raster = 0
    has_depth_guard = 0
    has_plane_cap_guard = 0
    has_init_rastport = 0
    has_bitmap_link = 0
    has_palette_len = 0
    has_palette_src = 0
    has_palette_dst = 0
    has_forbid_permit = 0
    has_pending_alert = 0
    has_snapshot_set = 0
    has_snapshot_dst = 0
    has_plane_base_0x90 = 0
    has_return_value = 0
    has_rts = 0
}

function trim(s,    t) {
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

    if (ENTRY != "" && u == toupper(ENTRY) ":") has_entry = 1
    if (ENTRY_REGEX != "" && u ~ toupper(ENTRY_REGEX)) has_entry = 1

    if (u ~ /MEMORY_ALLOCATEMEMORY/ || u ~ /GROUP_AG_JMPTBL_MEMORY_ALLOCATEM/) has_alloc_call = 1
    if (u ~ /372\.W|#372|#\$174|\(\$174\)\.W/) has_alloc_372 = 1
    if (u ~ /LVOINITBITMAP|_LVOINITBITMAP/) has_init_bitmap = 1
    if ((u ~ /200\(A0\)|204\(A0\)|152\(A1\)|156\(A1\)/) ||
        (u ~ /\$C8\(A0\)|\$CC\(A0\)|\$98\(A0\)|\$9C\(A0\)/)) has_row_pair_copy = 1
    if ((u ~ /191\(A3\)|33\(A0\)|33\(A2\)/) ||
        (u ~ /\$BF\(A3\)|\$21\(A2\)/)) has_label_copy = 1
    if (u ~ /214\(A3\)|\$D6\(A3\)/) has_width_src = 1
    if (u ~ /348\(A0\)|\$15C\(A2\)/) has_width_dst = 1
    if (u ~ /176\(A0\)|\$B0\(A2\)/) has_width_word = 1
    if (u ~ /218\(A3\)|\$DA\(A3\)/) has_height_src = 1
    if (u ~ /352\(A0\)|\$160\(A2\)/) has_height_dst = 1
    if (u ~ /178\(A0\)|\$B2\(A2\)/) has_height_word = 1
    if (u ~ /GRAPHICS_ALLOCRASTER|GROUP_AA_JMPTBL_GRAPHICS_ALLOCRA/) has_alloc_raster = 1
    if (u ~ /MOVE\.B 184\(A0\),D0|MOVE\.B \$B8\(A2\),D0|CMP\.L D0,D7/) has_depth_guard = 1
    if (u ~ /MOVEQ #5,D0|MOVEQ\.L #\$5,D0/) has_plane_cap_guard = 1
    if (u ~ /LVOINITRASTPORT|_LVOINITRASTPORT/) has_init_rastport = 1
    if ((u ~ /40\(A1\)|40\(A0\)|136\(A0\)|136\(A2\)/) ||
        (u ~ /\$28\(A2\)|\$88\(A2\)/)) has_bitmap_link = 1
    if (u ~ /MOVEQ #96,D0|MOVEQ\.L #\$60,D0/) has_palette_len = 1
    if (u ~ /32\(A3,D7\.L\)|\$20\(A3,D7\.L\)/) has_palette_src = 1
    if (u ~ /232\(A0,D0\.L\)|232|E8|\$E8/) has_palette_dst = 1
    if (u ~ /LVOFORBID|LVOPERMIT|_LVOFORBID|_LVOPERMIT/) has_forbid_permit = 1
    if (u ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOTHEADER/) has_pending_alert = 1
    if ((u ~ /MOVEQ #1,D0|MOVEQ\.L #\$1,D0/) || u ~ /MOVE\.L D0,BRUSH_PENDINGALERTCODE/) has_snapshot_set = 1
    if (u ~ /BRUSH_SNAPSHOTHEADER/) has_snapshot_dst = 1
    if (u ~ /#\$90|144\(/ || u ~ /\(144,/ || u ~ /\$90\([AD][0-7]\)/) has_plane_base_0x90 = 1
    if (u ~ /MOVE\.L -8\(A5\),D0|MOVE\.L A2,D0/) has_return_value = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_372=" has_alloc_372
    print "HAS_INIT_BITMAP=" has_init_bitmap
    print "HAS_ROW_PAIR_COPY=" has_row_pair_copy
    print "HAS_LABEL_COPY=" has_label_copy
    print "HAS_WIDTH_FALLBACK=" (has_width_src && has_width_dst && has_width_word)
    print "HAS_HEIGHT_FALLBACK=" (has_height_src && has_height_dst && has_height_word)
    print "HAS_ALLOC_RASTER=" has_alloc_raster
    print "HAS_DEPTH_GUARD=" has_depth_guard
    print "HAS_PLANE_CAP_GUARD=" has_plane_cap_guard
    print "HAS_INIT_RASTPORT=" has_init_rastport
    print "HAS_BITMAP_LINK=" has_bitmap_link
    print "HAS_PALETTE_COPY=" (has_palette_len && has_palette_src && has_palette_dst)
    print "HAS_FORBID_PERMIT=" has_forbid_permit
    print "HAS_PENDING_ALERT_PATH=" has_pending_alert
    print "HAS_SNAPSHOT_COPY=" (has_snapshot_set && has_snapshot_dst)
    print "HAS_PLANE_BASE_0X90=" has_plane_base_0x90
    print "HAS_RETURN_VALUE=" has_return_value
    print "HAS_RTS=" has_rts
}
