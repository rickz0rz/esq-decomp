BEGIN {
    label = 0
    has_alloc_call = 0
    has_alloc_372 = 0
    has_init_bitmap = 0
    has_alloc_raster = 0
    has_init_rastport = 0
    has_forbid_permit = 0
    has_pending_alert = 0
    has_plane_base_0x90 = 0
    has_return = 0
}

/^BRUSH_CloneBrushRecord:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /MEMORY_ALLOCATEMEMORY/) has_alloc_call = 1
    if (line ~ /372\.W|#372|#\$174/) has_alloc_372 = 1
    if (line ~ /LVOINITBITMAP/) has_init_bitmap = 1
    if (line ~ /GRAPHICS_ALLOCRASTER/) has_alloc_raster = 1
    if (line ~ /LVOINITRASTPORT/) has_init_rastport = 1
    if (line ~ /LVOFORBID|LVOPERMIT/) has_forbid_permit = 1
    if (line ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOTHEADER/) has_pending_alert = 1
    if (line ~ /#\$90|144\(/ || line ~ /\(144,/) has_plane_base_0x90 = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_alloc_call) print "HAS_ALLOC_CALL"
    if (has_alloc_372) print "HAS_ALLOC_372"
    if (has_init_bitmap) print "HAS_INIT_BITMAP"
    if (has_alloc_raster) print "HAS_ALLOC_RASTER"
    if (has_init_rastport) print "HAS_INIT_RASTPORT"
    if (has_forbid_permit) print "HAS_FORBID_PERMIT"
    if (has_pending_alert) print "HAS_PENDING_ALERT_PATH"
    if (has_plane_base_0x90) print "HAS_PLANE_BASE_0X90"
    if (has_return) print "HAS_RTS"
}
