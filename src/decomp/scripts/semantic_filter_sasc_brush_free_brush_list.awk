BEGIN {
    has_entry = 0
    has_main_next_offset = 0
    has_aux_list_offset = 0
    has_plane_count = 0
    has_plane_base = 0
    has_free_raster_call = 0
    has_free_aux_call = 0
    has_free_node_call = 0
    has_free_all_cmp = 0
    has_store_head = 0
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

    if (u ~ /368\(/ || u ~ /\(368,/ || u ~ /#\$170/ || u ~ /#368/ || u ~ /\$170\([AD][0-7]\)/) has_main_next_offset = 1
    if (u ~ /364\(/ || u ~ /\(364,/ || u ~ /#\$16C/ || u ~ /#364/ || u ~ /\$16C\([AD][0-7]\)/) has_aux_list_offset = 1
    if (u ~ /184\(/ || u ~ /\(184,/ || u ~ /#\$B8/ || u ~ /#184/ || u ~ /\$B8\([AD][0-7]\)/) has_plane_count = 1
    if (u ~ /#\$90/ || u ~ / 144\(/ || u ~ /\(144,/ || u ~ /ADDI\.L #\$90/ || u ~ /\$90\([AD][0-7]\)/) has_plane_base = 1
    if (u ~ /GRAPHICS_FREERASTER/ || u ~ /_GROUP_AB_JMPTBL_GRAPHICS_FREERASTER/ || u ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERAS/ || u ~ /_GROUP_AB_JMPTBL_GRAPHICS_FREERAS/) has_free_raster_call = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_6/ || ((u ~ /DEALLOCATEMEMORY/ || u ~ /DEALLOCAT/) && u ~ /12|\$C/)) has_free_aux_call = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_7/ || ((u ~ /DEALLOCATEMEMORY/ || u ~ /DEALLOCAT/) && u ~ /372|\$174/)) has_free_node_call = 1
    if (u ~ /CMP\.L .*D7/ || u ~ /#1,D0/ || u ~ /#\$1,D0/ || u ~ /FREE_ALL/) has_free_all_cmp = 1
    if (u ~ /MOVE\.L .*\(A3\)/ || u ~ /^CLR\.L \(A3\)$/ || u ~ /\(A3\)/) has_store_head = 1
}

END {
    if (has_entry) print "HAS_LABEL"
    if (has_main_next_offset) print "HAS_MAIN_NEXT_OFFSET_368"
    if (has_aux_list_offset) print "HAS_AUX_LIST_OFFSET_364"
    if (has_plane_count) print "HAS_PLANE_COUNT_OFFSET_184"
    if (has_plane_base) print "HAS_PLANE_BASE_OFFSET_0X90"
    if (has_free_raster_call) print "HAS_FREE_RASTER_CALL"
    if (has_free_aux_call) print "HAS_FREE_AUX_CALL"
    if (has_free_node_call) print "HAS_FREE_NODE_CALL"
    if (has_free_all_cmp) print "HAS_FREE_ALL_CMP"
    if (has_store_head) print "HAS_STORE_HEAD"
}
