BEGIN {
    has_entry = 0
    has_fallback_source = 0
    has_brush_lookup = 0
    has_overlay_dup = 0
    has_set_rast = 0
    has_set_font = 0
    plane_mask_count = 0
    has_accumulator_capture_ref = 0
    has_accumulator_flush_ref = 0
    has_copymem = 0
    has_select_brush = 0
    has_status_text_ref = 0
    trim_count = 0
    text_length_count = 0
    move_count = 0
    text_count = 0
    has_cleanup_dealloc = 0
    has_rts = 0
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
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^WDISP_DRAWWEATHERSTATUSOVERLAY:/ ||
        u ~ /^WDISP_DRAWWEATHERSTATUSOVERLA[A-Z0-9_]*:/) has_entry = 1

    if (n ~ /PTYPEWEATHERCURRENTMSGPTR/ ||
        n ~ /NOCURRENTWEATHE/) has_fallback_source = 1

    if (n ~ /FINDBRUSHBYPREDICATE/ ||
        n ~ /WEATHERBRUSHPREDICATENAMES/ ||
        n ~ /ESQFUNCSTRI5/) has_brush_lookup = 1

    if (n ~ /REPLACEOWNEDSTRING/ ||
        n ~ /WEATHERSTATUSOVERLAYTEXTPTR/) has_overlay_dup = 1

    if (n ~ /LVOSETRAST/) has_set_rast = 1
    if (n ~ /LVOSETFONT/ || n ~ /HANDLEPREVUECFONT/) has_set_font = 1

    if (n ~ /PLANEMASKFORINDEX/) plane_mask_count++

    if (n ~ /ACCUMULATORCAPTUREACTIVE/) has_accumulator_capture_ref = 1
    if (n ~ /ACCUMULATORFLUSHPENDING/) has_accumulator_flush_ref = 1
    if (n ~ /LVOCOPYMEM/) has_copymem = 1
    if (n ~ /SELECTBRUSHSLOT/) has_select_brush = 1
    if (n ~ /WEATHERSTATUSTEXTPTR/) has_status_text_ref = 1

    if (n ~ /TRIMTEXTTOPIXELWIDTHWORD/) trim_count++
    if (n ~ /LVOTEXTLENGTH/) text_length_count++
    if (n ~ /LVOMOVE/) move_count++
    if (n ~ /LVOTEXT/ && n !~ /LVOTEXTLENGTH/) text_count++

    if (n ~ /DEALLOCATEMEMORY/) has_cleanup_dealloc = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_FALLBACK_SOURCE=" has_fallback_source
    print "HAS_BRUSH_LOOKUP=" has_brush_lookup
    print "HAS_OVERLAY_DUP=" has_overlay_dup
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_SET_FONT=" has_set_font
    print "HAS_PLANE_MASK_PAIR=" (plane_mask_count >= 2)
    print "HAS_ACCUMULATOR_FLAGS=" (has_accumulator_capture_ref && has_accumulator_flush_ref)
    print "HAS_COPYMEM=" has_copymem
    print "HAS_SELECT_BRUSH=" has_select_brush
    print "HAS_STATUS_TEXT_REF=" has_status_text_ref
    print "HAS_TRIM_PAIR=" (trim_count >= 2)
    print "HAS_TEXT_LENGTHS=" (text_length_count >= 4)
    print "HAS_MOVES=" (move_count >= 4)
    print "HAS_TEXT_DRAWS=" (text_count >= 4)
    print "HAS_CLEANUP_DEALLOC=" has_cleanup_dealloc
    print "HAS_RTS=" has_rts
}
