BEGIN {
    label = 0
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
    has_return = 0
}

/^BRUSH_LoadBrushAsset:$/ { label = 1 }

{
    line = toupper($0)

    if (line ~ /DOS_OPENFILEWITHMODE/) has_open = 1
    if (line ~ /LVOREAD/) has_read = 1
    if (line ~ /LVOSEEK/) has_seek = 1
    if (line ~ /LVOCLOSE/) has_close = 1
    if (line ~ /STRING_COMPAREN/ && line ~ /IFF_FORM|BRUSH_STR_IFF_FORM|FORM/) has_form_cmp = 1
    if (line ~ /130000|#\$1FBD0/) has_alloc_130k = 1
    if (line ~ /BITMAP_PROCESSILBMIMAGE/) has_ilbm = 1
    if (line ~ /PACKBITSDECODE/) has_packbits = 1
    if (line ~ /GLOBAL_STR_BRUSH_C_11| 372\.W|#372/) has_node_alloc = 1
    if (line ~ /GRAPHICS_ALLOCRASTER/) has_alloc_raster = 1
    if (line ~ /GRAPHICS_FREERASTER/) has_free_raster = 1
    if (line ~ /MATH_DIVS32/) has_divs = 1
    if (line ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOT/) has_alert = 1
    if (line ~ /GLOBAL_STR_BRUSH_C_16/) has_cleanup_c16 = 1
    if (line ~ /^RTS$/) has_return = 1
}

END {
    if (label) print "HAS_LABEL"
    if (has_open) print "HAS_OPEN"
    if (has_read) print "HAS_READ"
    if (has_seek) print "HAS_SEEK"
    if (has_close) print "HAS_CLOSE"
    if (has_form_cmp) print "HAS_FORM_COMPARE"
    if (has_alloc_130k) print "HAS_ALLOC_130K"
    if (has_ilbm) print "HAS_ILBM_PROCESS"
    if (has_packbits) print "HAS_PACKBITS"
    if (has_node_alloc) print "HAS_NODE_ALLOC"
    if (has_alloc_raster) print "HAS_ALLOC_RASTER"
    if (has_free_raster) print "HAS_FREE_RASTER"
    if (has_divs) print "HAS_DIVS32"
    if (has_alert) print "HAS_ALERT_PATH"
    if (has_cleanup_c16) print "HAS_DECODE_BUFFER_FREE"
    if (has_return) print "HAS_RTS"
}
