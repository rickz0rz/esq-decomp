BEGIN {
    has_entry = 0
    has_open = 0
    has_read = 0
    has_seek = 0
    has_close = 0
    has_form_cmp = 0
    has_alloc_130k = 0
    has_ilbm = 0
    has_packbits = 0
    has_node_alloc = 0
    has_alloc_raster = 0
    has_free_raster = 0
    has_divs = 0
    has_alert = 0
    has_cleanup_c16 = 0
    has_restore_planes = 0
    has_clone_alloc = 0
    has_mode_clamp = 0
    has_init_bitmap = 0
    has_init_rastport = 0
    has_row_offsets = 0
    has_width_limit = 0
    has_height_limit = 0
    has_state_copy = 0
    has_node_free = 0
    has_rts = 0
    snapshot_refs = 0
    zero_368_refs = 0
    saw_string_compare = 0
    saw_form_token = 0
    saw_width_default = 0
    saw_width_limit_src = 0
    saw_height_default = 0
    saw_height_limit_src = 0
    saw_row_offset_src = 0
    saw_row_offset_dst = 0
    saw_state_copy_len = 0
    saw_state_copy_src = 0
    saw_state_copy_dst = 0
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

    if (u ~ /DOS_OPENFILEWITHMODE/ || u ~ /GROUP_AG_JMPTBL_DOS_OPENFILEWITHMO/ || u ~ /GROUP_AG_JMPTBL_DOS_OPENFILEWITH/) has_open = 1
    if (u ~ /LVOREAD/ || u ~ /_LVOREAD/) has_read = 1
    if (u ~ /LVOSEEK/ || u ~ /_LVOSEEK/) has_seek = 1
    if (u ~ /LVOCLOSE/ || u ~ /_LVOCLOSE/) has_close = 1
    if (u ~ /STRING_COMPAREN/ || u ~ /GROUP_AA_JMPTBL_STRING_COMPAR/) saw_string_compare = 1
    if (u ~ /IFF_FORM|BRUSH_STR_IFF_FORM|FORM/) saw_form_token = 1
    if (u ~ /130000|#\$1FBD0/) has_alloc_130k = 1
    if ((u ~ /BTST[[:space:]]+#7/ || u ~ /BTST[[:space:]]+#\$7/) &&
        (u ~ /150\(A3\)|\$96\(A5\)/)) has_mode_clamp = 1
    if ((u ~ /#320|#\$140/) && (u ~ /-58\(A5\)|\$60\(A7\)/)) has_mode_clamp = 1
    if (u ~ /#640|#\$280/) has_mode_clamp = 1
    if (u ~ /BITMAP_PROCESSILBMIMAGE/ || u ~ /BITMAP_PROCESSILBMIMAG/) has_ilbm = 1
    if (u ~ /PACKBITSDECODE/ || u ~ /ESQ_PACKBITSDECODE/) has_packbits = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_11| 372\.W|#372|#\$174/) has_node_alloc = 1
    if (u ~ /GRAPHICS_ALLOCRASTER/ || u ~ /GROUP_AA_JMPTBL_GRAPHICS_ALLOCRA/) has_alloc_raster = 1
    if (u ~ /GRAPHICS_FREERASTER/ || u ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERAS/) has_free_raster = 1
    if (u ~ /MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_divs = 1
    if (u ~ /LVOINITBITMAP/ || u ~ /_LVOINITBITMAP/) has_init_bitmap = 1
    if (u ~ /LVOINITRASTPORT/ || u ~ /_LVOINITRASTPORT/) has_init_rastport = 1
    if (u ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOT/) has_alert = 1
    if (u ~ /BRUSH_SNAPSHOTHEADER/) snapshot_refs++
    if (u ~ /GLOBAL_STR_BRUSH_C_16/) has_cleanup_c16 = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_14|1205|#1205|#\$4B5/) has_node_free = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_15/) has_clone_alloc = 1
    if (u ~ /-42\(A5/ || u ~ /\$24\(A7,D0\.L\)/) has_restore_planes = 1
    if (u ~ /368\(A0\)|368\(A1\)|\$170\(A0\)|\$170\(A1\)/) zero_368_refs++
    if (u ~ /LEA 200\(A0\),A2|LEA \$C8\(A0\),A1|ADD\.W #\$C8,A0|ADD\.W #200,A0/) saw_row_offset_dst = 1
    if (u ~ /LEA 152\(A1\)|LEA 152\(A3\)|LEA \$98\(A5\)/) saw_row_offset_src = 1
    if (u ~ /TST\.L 214\(A3\)|LEA \$D6\(A5\)/) saw_width_limit_src = 1
    if ((u ~ /MOVE\.L 214\(A3\),348\(A0\)/) || (u ~ /LEA \$15C\(A0\)/)) saw_width_limit_src = 1
    if (u ~ /MOVE\.L D0,348\(A0\)|MOVE\.L D0,\(A1\)/) saw_width_default = 1
    if (u ~ /TST\.L 218\(A3\)|LEA \$DA\(A5\)/) saw_height_limit_src = 1
    if ((u ~ /MOVE\.L 218\(A3\),352\(A0\)/) || (u ~ /LEA \$160\(A0\)/)) saw_height_limit_src = 1
    if (u ~ /MOVE\.L D0,352\(A0\)|MOVE\.L D0,\(A1\)/) saw_height_default = 1
    if (u ~ /MOVEQ #96,D0|MOVEQ\.L #\$60,D1/) saw_state_copy_len = 1
    if (u ~ /32\(A3,D6\.L\)|\$20\(A5,D0\.L\)/) saw_state_copy_src = 1
    if (u ~ /#\$E8|ADDI\.L #\$E8|ADD\.L #\$E8/) saw_state_copy_dst = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_OPEN=" has_open
    print "HAS_READ=" has_read
    print "HAS_SEEK=" has_seek
    print "HAS_CLOSE=" has_close
    has_form_cmp = (saw_string_compare && saw_form_token)
    print "HAS_FORM_COMPARE=" has_form_cmp
    print "HAS_ALLOC_130K=" has_alloc_130k
    print "HAS_MODE_CLAMP=" has_mode_clamp
    print "HAS_ILBM_PROCESS=" has_ilbm
    print "HAS_PACKBITS=" has_packbits
    print "HAS_NODE_ALLOC=" has_node_alloc
    print "HAS_INIT_BITMAP=" has_init_bitmap
    print "HAS_INIT_RASTPORT=" has_init_rastport
    has_row_offsets = (saw_row_offset_src && saw_row_offset_dst)
    print "HAS_ROW_OFFSET_COPY=" has_row_offsets
    has_width_limit = (saw_width_limit_src && saw_width_default)
    print "HAS_WIDTH_LIMIT_FALLBACK=" has_width_limit
    has_height_limit = (saw_height_limit_src && saw_height_default)
    print "HAS_HEIGHT_LIMIT_FALLBACK=" has_height_limit
    print "HAS_ALLOC_RASTER=" has_alloc_raster
    print "HAS_FREE_RASTER=" has_free_raster
    has_state_copy = (saw_state_copy_len && saw_state_copy_src && saw_state_copy_dst)
    print "HAS_STATE_COPY=" has_state_copy
    print "HAS_DIVS32=" has_divs
    print "HAS_ALERT_PATH=" has_alert
    print "HAS_ALERT_SNAPSHOT_RECOPY=" (snapshot_refs >= 2)
    print "HAS_RESTORE_PLANES=" has_restore_planes
    print "HAS_CLONE_ALLOC=" has_clone_alloc
    print "HAS_CLONE_ZERO368=" (zero_368_refs >= 2)
    print "HAS_NODE_FREE=" has_node_free
    print "HAS_DECODE_BUFFER_FREE=" has_cleanup_c16
    print "HAS_RTS=" has_rts
}
