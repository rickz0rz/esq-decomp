BEGIN {
    label = 0
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

/^BRUSH_FreeBrushList:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /368\(/ || line ~ /\(368,/ || line ~ /#\$170/ || line ~ /#368/) has_main_next_offset = 1
    if (line ~ /364\(/ || line ~ /\(364,/ || line ~ /#\$16C/ || line ~ /#364/) has_aux_list_offset = 1
    if (line ~ /184\(/ || line ~ /\(184,/ || line ~ /#\$B8/ || line ~ /#184/) has_plane_count = 1
    if (line ~ /#\$90/ || line ~ / 144\(/ || line ~ /\(144,/) has_plane_base = 1
    if (line ~ /GRAPHICS_FREERASTER/) has_free_raster_call = 1
    if (line ~ /GLOBAL_STR_BRUSH_C_6/ || line ~ /DEALLOCATEMEMORY/ && line ~ /12/) has_free_aux_call = 1
    if (line ~ /GLOBAL_STR_BRUSH_C_7/ || line ~ /DEALLOCATEMEMORY/ && line ~ /372/) has_free_node_call = 1
    if (line ~ /CMP\.L .*D7/ || line ~ /#1,D0/ || line ~ /FREE_ALL/) has_free_all_cmp = 1
    if (line ~ /MOVE\.L .*,-?\(?A3\)?/ || line ~ /\(A3\)/) has_store_head = 1
}

END {
    if (label) print "HAS_LABEL"
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
