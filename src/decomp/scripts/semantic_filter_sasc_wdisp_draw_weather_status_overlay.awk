BEGIN {
    has_entry = 0
    has_fallback_source = 0
    has_fallback_guard = 0
    has_direct_brush_lookup = 0
    has_indexed_brush_lookup = 0
    has_default_brush_size = 0
    has_overlay_dup = 0
    has_overlay_split_and_clamp = 0
    has_set_rast = 0
    has_set_font = 0
    has_font_height_ref = 0
    has_font_baseline_ref = 0
    plane_mask_count = 0
    has_accumulator_capture_ref = 0
    has_accumulator_flush_ref = 0
    has_copymem = 0
    has_select_brush = 0
    has_status_text_ref = 0
    has_status_pen3 = 0
    has_layout_math = 0
    half_center_helper_count = 0
    asr_half_count = 0
    trim_count = 0
    text_length_count = 0
    move_count = 0
    text_count = 0
    has_cleanup_dealloc = 0
    has_text_pool_release = 0
    has_rts = 0

    saw_countdown_ref = 0
    saw_digit_char_ref = 0
    saw_ascii_zero = 0
    saw_default_width = 0
    saw_default_height = 0
    saw_delimiter_24 = 0
    saw_line_clamp_10 = 0
    saw_math_div = 0
    saw_math_mul = 0
    saw_pool_301 = 0
    saw_pool_tag = 0
    saw_pen3_imm = 0
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

    if (n ~ /WEATHERSTATUSCOUNTDOWN/) saw_countdown_ref = 1
    if (n ~ /WEATHERSTATUSDIGITCHAR/) saw_digit_char_ref = 1
    if (u ~ /#48/ || u ~ /#\$30/) saw_ascii_zero = 1

    if (n ~ /WEATHERBRUSHPREDICATENAM/) has_direct_brush_lookup = 1
    if (n ~ /ESQFUNCSTRI5/) has_indexed_brush_lookup = 1

    if (u ~ /#90/ || u ~ /#\$5A/) saw_default_height = 1
    if (u ~ /#\$AA/ || u ~ /#\$55/) saw_default_width = 1

    if (n ~ /REPLACEOWNEDSTRING/ ||
        n ~ /WEATHERSTATUSOVERLAYTEXTPTR/) has_overlay_dup = 1

    if (u ~ /#24/ || u ~ /#\$18/) saw_delimiter_24 = 1
    if (u ~ /#10([^0-9]|$)/ || u ~ /#\$A([^A-Z0-9]|$)/) saw_line_clamp_10 = 1

    if (n ~ /LVOSETRAST/) has_set_rast = 1
    if (n ~ /LVOSETFONT/ || n ~ /HANDLEPREVUECFONT/) has_set_font = 1
    if (u ~ /20\(A0\)/ || u ~ /\$14,A0/) has_font_height_ref = 1
    if (u ~ /26\(A0\)/ || u ~ /\$1A,A0/) has_font_baseline_ref = 1

    if (n ~ /PLANEMASKFORINDEX/) plane_mask_count++

    if (n ~ /ACCUMULATORCAPTUREACTIVE/) has_accumulator_capture_ref = 1
    if (n ~ /ACCUMULATORFLUSHPENDING/) has_accumulator_flush_ref = 1
    if (n ~ /LVOCOPYMEM/) has_copymem = 1
    if (n ~ /SELECTBRUSHSLOT/) has_select_brush = 1
    if (n ~ /WEATHERSTATUSTEXTPTR/) has_status_text_ref = 1
    if (u ~ /#3([^0-9]|$)/ || u ~ /#\$3([^A-Z0-9]|$)/ || u ~ /\(\$3\)\.W/) saw_pen3_imm = 1

    if (n ~ /MATHDIVS32/) saw_math_div = 1
    if (n ~ /MATHMULU32/) saw_math_mul = 1
    if (n ~ /HALFTOWARDZERO/) half_center_helper_count++
    if (u ~ /ASR\.L #1/ || u ~ /ASR\.L #\$1/) asr_half_count++

    if (n ~ /TRIMTEXTTOPIXELWIDTHWORD/) trim_count++
    if (n ~ /LVOTEXTLENGTH/) text_length_count++
    if (n ~ /LVOMOVE/) move_count++
    if (n ~ /LVOTEXT/ && n !~ /LVOTEXTLENGTH/) text_count++

    if (n ~ /DEALLOCATEMEMORY/) has_cleanup_dealloc = 1
    if (u ~ /301\.W/ || u ~ /\$12D/) saw_pool_301 = 1
    if (n ~ /GLOBALSTRWDISPC/) saw_pool_tag = 1
    if (u == "RTS") has_rts = 1
}

END {
    has_fallback_guard = (saw_countdown_ref && saw_digit_char_ref && saw_ascii_zero)
    has_default_brush_size = (saw_default_width && saw_default_height)
    has_overlay_split_and_clamp = (saw_delimiter_24 && saw_line_clamp_10)
    has_layout_math = (saw_math_div && saw_math_mul)
    has_text_pool_release = (saw_pool_301 && saw_pool_tag)
    has_status_pen3 = saw_pen3_imm

    print "HAS_ENTRY=" has_entry
    print "HAS_FALLBACK_SOURCE=" has_fallback_source
    print "HAS_FALLBACK_GUARD=" has_fallback_guard
    print "HAS_DIRECT_BRUSH_LOOKUP=" has_direct_brush_lookup
    print "HAS_INDEXED_BRUSH_LOOKUP=" has_indexed_brush_lookup
    print "HAS_DEFAULT_BRUSH_SIZE=" has_default_brush_size
    print "HAS_OVERLAY_DUP=" has_overlay_dup
    print "HAS_OVERLAY_SPLIT_AND_CLAMP=" has_overlay_split_and_clamp
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_SET_FONT=" has_set_font
    print "HAS_FONT_HEIGHT_REF=" has_font_height_ref
    print "HAS_FONT_BASELINE_REF=" has_font_baseline_ref
    print "HAS_PLANE_MASK_PAIR=" (plane_mask_count >= 2)
    print "HAS_ACCUMULATOR_FLAGS=" (has_accumulator_capture_ref && has_accumulator_flush_ref)
    print "HAS_COPYMEM=" has_copymem
    print "HAS_SELECT_BRUSH=" has_select_brush
    print "HAS_STATUS_TEXT_REF=" has_status_text_ref
    print "HAS_STATUS_PEN3=" has_status_pen3
    print "HAS_LAYOUT_MATH=" has_layout_math
    print "HAS_HALF_CENTERING=" (half_center_helper_count >= 3 || asr_half_count >= 3)
    print "HAS_TRIM_PAIR=" (trim_count >= 2)
    print "HAS_TEXT_LENGTHS=" (text_length_count >= 4)
    print "HAS_MOVES=" (move_count >= 4)
    print "HAS_TEXT_DRAWS=" (text_count >= 4)
    print "HAS_CLEANUP_DEALLOC=" has_cleanup_dealloc
    print "HAS_TEXT_POOL_RELEASE=" has_text_pool_release
    print "HAS_RTS=" has_rts
}
