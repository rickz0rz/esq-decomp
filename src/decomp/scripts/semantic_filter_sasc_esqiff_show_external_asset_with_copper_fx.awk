BEGIN {
    has_entry = 0
    has_missing_retry_gads = 0
    has_missing_retry_logo = 0
    has_select_slot = 0
    has_build_ctx = 0
    has_divs = 0
    has_begin_banner = 0
    has_plane_mask = 0
    has_run_rise = 0
    has_run_drop = 0
    has_set_apen = 0
    has_set_rast = 0
    has_copy_mem = 0
    has_accum_capture_enable = 0
    has_accum_flush_clear = 0
    has_accum_capture_disable = 0
    has_accum_flush_set = 0
    has_mode_full = 0
    has_mode_compact = 0
    has_mode_wide = 0
    has_mode_fallback = 0
    has_palette_gate = 0
    has_palette_copy_loop = 0
    has_capture_limit = 0
    has_capture_store_rows = 0
    has_capture_active_result = 0
    has_sum_reset = 0
    has_saturate_reset = 0
    has_return = 0

    saw_palette_mode_test = 0
    saw_plane_mask_fixed = 0
    saw_plane_mask_depth = 0
    saw_palette_dst = 0
    saw_palette_src = 0
    saw_capture_index_limit = 0
    saw_capture_value_limit = 0
    saw_missing_retry_or = 0
    saw_missing_retry_value1 = 0
    saw_missing_retry_value2 = 0
    saw_mode_const4 = 0
    saw_mode_const5 = 0
    saw_mode_const6 = 0
    saw_mode_const7 = 0
    saw_palette_fixed_const = 0
    saw_palette_depth_load = 0
    saw_capture_limit_const = 0
    capture_store_count = 0
    sum_reset_count = 0
    saturate_reset_count = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQIFF_SHOWEXTERNALASSETWITHCOPPERFX:/ ||
        uline ~ /^ESQIFF_SHOWEXTERNALASSETWITHC[A-Z0-9_]*:/) has_entry = 1
    if (uline ~ /^MOVEQ(\.L)? #\$?1,D[0-7]$/ || uline ~ /^MOVEQ #1,D[0-7]$/) saw_missing_retry_value1 = 1
    if (uline ~ /^MOVEQ(\.L)? #\$?2,D[0-7]$/ || uline ~ /^MOVEQ #2,D[0-7]$/) saw_missing_retry_value2 = 1
    if (uline ~ /ESQFUNC_MISSINGASSETRETRYMASK/ && uline ~ /BSET/ && uline ~ /#\$0/) has_missing_retry_gads = 1
    if (uline ~ /ESQFUNC_MISSINGASSETRETRYMASK/ && uline ~ /BSET/ && uline ~ /#\$1/) has_missing_retry_logo = 1
    if (uline ~ /ESQFUNC_MISSINGASSETRETRYMASK/ && uline ~ /OR\.L/) saw_missing_retry_or = 1
    if (saw_missing_retry_or && saw_missing_retry_value1) has_missing_retry_gads = 1
    if (saw_missing_retry_or && saw_missing_retry_value2) has_missing_retry_logo = 1
    if (uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHS/ ||
        uline ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/) has_select_slot = 1
    if (uline ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLA/ ||
        uline ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/) has_build_ctx = 1
    if (uline ~ /ESQIFF_JMPTBL_MATH_DIVS32/) has_divs = 1
    if (uline ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNER/ ||
        uline ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNERCHARTRANSITION/) has_begin_banner = 1
    if (uline ~ /ESQPARS_JMPTBL_BRUSH_PLANEMASKFO/ ||
        uline ~ /ESQPARS_JMPTBL_BRUSH_PLANEMASKFORINDEX/ ||
        uline ~ /BRUSH_PLANEMASKFO/ ||
        uline ~ /BRUSH_PLANEMASKFORINDEX/) has_plane_mask = 1
    if (uline ~ /ESQIFF_RUNCOPPERRISETRANSITION/) has_run_rise = 1
    if (uline ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) has_run_drop = 1
    if (uline ~ /_LVOSETAPEN/) has_set_apen = 1
    if (uline ~ /_LVOSETRAST/) has_set_rast = 1
    if (uline ~ /_LVOCOPYMEM/) has_copy_mem = 1

    if (uline ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ && uline ~ /(MOVE\.W #1|MOVE\.W #\$1|MOVEQ #1|MOVEQ #\$1)/) has_accum_capture_enable = 1
    if (uline ~ /WDISP_ACCUMULATORFLUSHPENDING/ && uline ~ /(CLR\.W|CLR\.L|MOVEQ #0|MOVE\.W #0|MOVE\.L #0)/) has_accum_flush_clear = 1
    if (uline ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ && uline ~ /(CLR\.W|CLR\.L|MOVEQ #0|MOVE\.W #0|MOVE\.L #0)/) has_accum_capture_disable = 1
    if (uline ~ /WDISP_ACCUMULATORFLUSHPENDING/ && uline ~ /(MOVE\.W #1|MOVE\.W #\$1|MOVEQ #1|MOVEQ #\$1)/) has_accum_flush_set = 1

    if (uline ~ /^PEA 4\.W$/ || uline ~ /^MOVEQ(\.L)? #\$?4,D[0-7]$/ || uline ~ /^MOVEQ #4,D[0-7]$/) saw_mode_const4 = 1
    if (uline ~ /^PEA 5\.W$/ || uline ~ /^MOVEQ(\.L)? #\$?5,D[0-7]$/ || uline ~ /^MOVEQ #5,D[0-7]$/) saw_mode_const5 = 1
    if (uline ~ /^PEA 6\.W$/ || uline ~ /^MOVEQ(\.L)? #\$?6,D[0-7]$/ || uline ~ /^MOVEQ #6,D[0-7]$/) saw_mode_const6 = 1
    if (uline ~ /^PEA 7\.W$/ || uline ~ /^MOVEQ(\.L)? #\$?7,D[0-7]$/ || uline ~ /^MOVEQ #7,D[0-7]$/) saw_mode_const7 = 1
    if (has_build_ctx && saw_mode_const4) has_mode_full = 1
    if (has_build_ctx && saw_mode_const5) has_mode_wide = 1
    if (has_build_ctx && saw_mode_const6) has_mode_compact = 1
    if (has_build_ctx && saw_mode_const7) has_mode_fallback = 1

    if (uline ~ /(TST\.L 328|CMP\.L 328|PALETTEMODEOFFSET|PALETTEMODE|\$148\(A5\))/) saw_palette_mode_test = 1
    if (uline ~ /^PEA 5\.W$/ || uline ~ /^PEA \(\$5\)\.W$/ || uline ~ /^MOVEQ(\.L)? #\$?5,D[0-7]$/ || uline ~ /^MOVEQ #5,D[0-7]$/) saw_palette_fixed_const = 1
    if (uline ~ /184\(A0\)/ || uline ~ /BRUSH_PLANE_DEPTH_OFFSET/ || uline ~ /\$B8\(A5\)/ || uline ~ /^MOVE\.B \$B8\(A5\),D0$/) saw_palette_depth_load = 1
    if (saw_palette_mode_test && uline ~ /BRUSH_PLANEMASKFORINDEX/ && saw_palette_fixed_const) saw_plane_mask_fixed = 1
    if (saw_palette_mode_test && uline ~ /BRUSH_PLANEMASKFORINDEX/ && saw_palette_depth_load) saw_plane_mask_depth = 1
    if (uline ~ /WDISP_PALETTETRIPLESRBASE/) saw_palette_dst = 1
    if (uline ~ /#\$E8/ || uline ~ /PALETTE_BYTES_OFFSET/ || uline ~ /^MOVEQ\.L #\$74,D1$/) saw_palette_src = 1
    if (saw_palette_mode_test && saw_plane_mask_fixed) has_palette_gate = 1
    if (saw_plane_mask_fixed && saw_plane_mask_depth && saw_palette_dst && saw_palette_src) has_palette_copy_loop = 1

    if (uline ~ /^MOVEQ(\.L)? #\$?32,D[0-7]$/ || uline ~ /^PEA 32\.W$/ || uline ~ /^MOVEQ #32,D[0-7]$/ || uline ~ /COPPER_LIMIT/) saw_capture_limit_const = 1
    if ((uline ~ /CMP\.B D1/ && uline ~ /BCC/) || (uline ~ /CMP\.B/ && uline ~ /BCC/ && saw_capture_limit_const)) saw_capture_index_limit = 1
    if (uline ~ /#\$4000/ || uline ~ /ACCUMULATOR_VALUE_LIMIT/) saw_capture_value_limit = 1
    if (saw_capture_index_limit && saw_capture_value_limit) has_capture_limit = 1
    if (uline ~ /ACCUMULATOR_ROW[0-3]_CAPTUREVALUE/) capture_store_count++
    if (capture_store_count >= 4) has_capture_store_rows = 1
    if (uline ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ &&
        (uline ~ /(MOVE\.W #1|MOVE\.W #\$1|MOVEQ #1|MOVEQ #\$1)/ ||
         uline ~ /(CLR\.W|CLR\.L|MOVEQ #0|MOVE\.W #0|MOVE\.L #0)/)) has_capture_active_result = 1

    if (uline ~ /ACCUMULATOR_ROW[0-3]_SUM/) sum_reset_count++
    if (uline ~ /ACCUMULATOR_ROW[0-3]_SATURATEFLAG/) saturate_reset_count++
    if (sum_reset_count >= 4) has_sum_reset = 1
    if (saturate_reset_count >= 4) has_saturate_reset = 1
    if (uline == "RTS" || uline ~ /SHOWEXTERNALASSETWITHCOPPERFX_RETURN/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_MISSING_RETRY_GADS=" has_missing_retry_gads
    print "HAS_MISSING_RETRY_LOGO=" has_missing_retry_logo
    print "HAS_SELECT_SLOT=" has_select_slot
    print "HAS_BUILD_CTX=" has_build_ctx
    print "HAS_DIVS=" has_divs
    print "HAS_BEGIN_BANNER=" has_begin_banner
    print "HAS_PLANE_MASK=" has_plane_mask
    print "HAS_RUN_RISE=" has_run_rise
    print "HAS_RUN_DROP=" has_run_drop
    print "HAS_SET_APEN=" has_set_apen
    print "HAS_SET_RAST=" has_set_rast
    print "HAS_COPY_MEM=" has_copy_mem
    print "HAS_ACCUM_CAPTURE_ENABLE=" has_accum_capture_enable
    print "HAS_ACCUM_FLUSH_CLEAR=" has_accum_flush_clear
    print "HAS_ACCUM_CAPTURE_DISABLE=" has_accum_capture_disable
    print "HAS_ACCUM_FLUSH_SET=" has_accum_flush_set
    print "HAS_MODE_FULL=" has_mode_full
    print "HAS_MODE_COMPACT=" has_mode_compact
    print "HAS_MODE_WIDE=" has_mode_wide
    print "HAS_MODE_FALLBACK=" has_mode_fallback
    print "HAS_PALETTE_GATE=" has_palette_gate
    print "HAS_PALETTE_COPY_LOOP=" has_palette_copy_loop
    print "HAS_CAPTURE_LIMIT=" has_capture_limit
    print "HAS_CAPTURE_STORE_ROWS=" has_capture_store_rows
    print "HAS_CAPTURE_ACTIVE_RESULT=" has_capture_active_result
    print "HAS_SUM_RESET=" has_sum_reset
    print "HAS_SATURATE_RESET=" has_saturate_reset
    print "HAS_RETURN=" has_return
}
