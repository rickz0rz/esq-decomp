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
    has_rts = 0
    saw_string_compare = 0
    saw_form_token = 0
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
    if (u ~ /BITMAP_PROCESSILBMIMAGE/ || u ~ /BITMAP_PROCESSILBMIMAG/) has_ilbm = 1
    if (u ~ /PACKBITSDECODE/ || u ~ /ESQ_PACKBITSDECODE/) has_packbits = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_11| 372\.W|#372|#\$174/) has_node_alloc = 1
    if (u ~ /GRAPHICS_ALLOCRASTER/ || u ~ /GROUP_AA_JMPTBL_GRAPHICS_ALLOCRA/) has_alloc_raster = 1
    if (u ~ /GRAPHICS_FREERASTER/ || u ~ /GROUP_AB_JMPTBL_GRAPHICS_FREERAS/) has_free_raster = 1
    if (u ~ /MATH_DIVS32/ || u ~ /GROUP_AG_JMPTBL_MATH_DIVS32/) has_divs = 1
    if (u ~ /BRUSH_PENDINGALERTCODE|BRUSH_SNAPSHOT/) has_alert = 1
    if (u ~ /GLOBAL_STR_BRUSH_C_16/) has_cleanup_c16 = 1
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
    print "HAS_ILBM_PROCESS=" has_ilbm
    print "HAS_PACKBITS=" has_packbits
    print "HAS_NODE_ALLOC=" has_node_alloc
    print "HAS_ALLOC_RASTER=" has_alloc_raster
    print "HAS_FREE_RASTER=" has_free_raster
    print "HAS_DIVS32=" has_divs
    print "HAS_ALERT_PATH=" has_alert
    print "HAS_DECODE_BUFFER_FREE=" has_cleanup_c16
    print "HAS_RTS=" has_rts
}
