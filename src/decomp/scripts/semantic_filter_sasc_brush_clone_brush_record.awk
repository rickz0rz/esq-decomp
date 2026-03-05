BEGIN {
    has_entry = 0
    has_alloc_call = 0
    has_alloc_372 = 0
    has_init_bitmap = 0
    has_alloc_raster = 0
    has_init_rastport = 0
    has_forbid_permit = 0
    has_pending_alert = 0
    has_plane_base_0x90 = 0
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
    if (u ~ /GRAPHICS_ALLOCRASTER|GROUP_AA_JMPTBL_GRAPHICS_ALLOCRA/) has_alloc_raster = 1
    if (u ~ /LVOINITRASTPORT|_LVOINITRASTPORT/) has_init_rastport = 1
    if (u ~ /LVOFORBID|LVOPERMIT|_LVOFORBID|_LVOPERMIT/) has_forbid_permit = 1
    if (u ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOTHEADER/) has_pending_alert = 1
    if (u ~ /#\$90|144\(/ || u ~ /\(144,/ || u ~ /\$90\([AD][0-7]\)/) has_plane_base_0x90 = 1
    if (u == "RTS") has_rts = 1
}

END {
    if (ENTRY != "") print "HAS_ENTRY=" has_entry
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_372=" has_alloc_372
    print "HAS_INIT_BITMAP=" has_init_bitmap
    print "HAS_ALLOC_RASTER=" has_alloc_raster
    print "HAS_INIT_RASTPORT=" has_init_rastport
    print "HAS_FORBID_PERMIT=" has_forbid_permit
    print "HAS_PENDING_ALERT_PATH=" has_pending_alert
    print "HAS_PLANE_BASE_0X90=" has_plane_base_0x90
    print "HAS_RTS=" has_rts
}
