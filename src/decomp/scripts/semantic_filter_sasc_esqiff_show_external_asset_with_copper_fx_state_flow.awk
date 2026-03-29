BEGIN {
    has_entry = 0

    has_brush_head_select = 0
    saw_gads_head = 0
    saw_logo_head = 0

    has_missing_retry_bits = 0
    saw_retry_mask = 0
    saw_retry_bit0 = 0
    saw_retry_bit1 = 0
    saw_retry_or_mask = 0

    has_transition_sequence = 0
    saw_drop = 0
    saw_divs = 0
    saw_begin_banner = 0
    saw_wait_flag = 0

    has_accumulator_copy_setup = 0
    saw_capture_enable = 0
    saw_flush_clear = 0
    saw_row_table = 0
    saw_copy_mem = 0
    saw_capture_disable = 0
    saw_flush_set = 0

    has_display_mode_selection = 0
    saw_full_mask_gate = 0
    saw_compact_gate = 0
    saw_wide_gate = 0
    saw_mode4 = 0
    saw_mode5 = 0
    saw_mode6 = 0
    saw_mode7 = 0
    saw_dsty20 = 0
    saw_dsty10 = 0
    saw_build_context = 0

    has_draw_sequence = 0
    saw_set_rast = 0
    saw_set_apen = 0
    saw_select_slot = 0

    has_palette_refresh = 0
    saw_palette_mode = 0
    plane_mask_calls = 0
    saw_palette_triples = 0

    has_capture_sequence = 0
    capture_calls = 0
    capture_value_hits = 0

    has_capture_enable_gate = 0
    capture_enable_refs = 0

    has_accumulator_resets = 0
    accumulator_reset_hits = 0

    has_rise_transition = 0
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
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ESQIFF_SHOWEXTERNALASSETWITHCOPPERFX:/ ||
        u ~ /^ESQIFF_SHOWEXTERNALASSETWITHC[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (u ~ /ESQIFF_GADSBRUSHLISTHEAD/) {
        saw_gads_head = 1
    }
    if (u ~ /ESQIFF_LOGOBRUSHLISTHEAD/) {
        saw_logo_head = 1
    }
    if (saw_gads_head && saw_logo_head) {
        has_brush_head_select = 1
    }

    if (u ~ /ESQFUNC_MISSINGASSETRETRYMASK/) {
        saw_retry_mask = 1
    }
    if (u ~ /BSET #\$0/ || u ~ /BSET #0/ ||
        u ~ /MOVEQ\.L #\$1,D0/ || u ~ /MOVEQ #1,D0/ ||
        u ~ /MOVEQ\.L #1,D0/) {
        saw_retry_bit0 = 1
    }
    if (u ~ /BSET #\$1/ || u ~ /BSET #1/ ||
        u ~ /MOVEQ\.L #\$2,D0/ || u ~ /MOVEQ #2,D0/ ||
        u ~ /MOVEQ\.L #2,D0/) {
        saw_retry_bit1 = 1
    }
    if (u ~ /OR\.L D0,ESQFUNC_MISSINGASSETRETRYMASK/) {
        saw_retry_or_mask = 1
    }
    if (saw_retry_mask && saw_retry_or_mask && saw_retry_bit0 && saw_retry_bit1) {
        has_missing_retry_bits = 1
    } else if (saw_retry_mask && saw_retry_bit0 && saw_retry_bit1) {
        has_missing_retry_bits = 1
    }

    if (u ~ /ESQIFF_RUNCOPPERDROPTRANSITION/) {
        saw_drop = 1
    }
    if (u ~ /ESQIFF_JMPTBL_MATH_DIVS32/) {
        saw_divs = 1
    }
    if (u ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNER/ ||
        u ~ /ESQIFF_JMPTBL_SCRIPT_BEGINBANNERCHARTRANSITION/) {
        saw_begin_banner = 1
    }
    if (u ~ /SCRIPT_BANNERTRANSITIONACTIVE/) {
        saw_wait_flag = 1
    }
    if (saw_drop && saw_divs && saw_begin_banner && saw_wait_flag) {
        has_transition_sequence = 1
    }

    if (u ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ &&
        (u ~ /#\$1/ || u ~ /#1/ || u ~ /MOVE\.W #1/)) {
        saw_capture_enable = 1
        capture_enable_refs++
    }
    if (u ~ /CLR\.W WDISP_ACCUMULATORFLUSHPENDING/ ||
        u ~ /WDISP_ACCUMULATORFLUSHPENDING/ && u ~ /CLR\.W/) {
        saw_flush_clear = 1
    }
    if (u ~ /WDISP_ACCUMULATORROWTABLE/) {
        saw_row_table = 1
    }
    if (u ~ /_LVOCOPYMEM/) {
        saw_copy_mem = 1
    }
    if (u ~ /CLR\.W WDISP_ACCUMULATORCAPTUREACTIVE/ ||
        u ~ /WDISP_ACCUMULATORCAPTUREACTIVE/ && u ~ /CLR\.W/) {
        saw_capture_disable = 1
        capture_enable_refs++
    }
    if (u ~ /WDISP_ACCUMULATORFLUSHPENDING/ &&
        (u ~ /#\$1/ || u ~ /#1/ || u ~ /MOVE\.W #1/)) {
        saw_flush_set = 1
    }
    if (saw_capture_enable && saw_flush_clear && saw_row_table &&
        saw_copy_mem && saw_capture_disable && saw_flush_set) {
        has_accumulator_copy_setup = 1
    }

    if (u ~ /#\$8004/ || u ~ /#32772/) {
        saw_full_mask_gate = 1
    }
    if (u ~ /BTST #\$7,\$C6/ || u ~ /BTST #7,198\(/ || u ~ /BTST #7,\$C6\(A5\)/) {
        saw_compact_gate = 1
    }
    if (u ~ /BTST #\$2,\$C7/ || u ~ /BTST #2,199\(/ || u ~ /BTST #2,\$C7\(A5\)/) {
        saw_wide_gate = 1
    }
    if (u ~ /PEA 4\.W/ || u ~ /MOVEQ\.L #\$4,D0/ || u ~ /MOVEQ #4,D0/) {
        saw_mode4 = 1
    }
    if (u ~ /PEA 5\.W/ || u ~ /MOVEQ\.L #\$5,D0/ || u ~ /MOVEQ #5,D0/) {
        saw_mode5 = 1
    }
    if (u ~ /PEA 6\.W/ || u ~ /MOVEQ\.L #\$6,D0/ || u ~ /MOVEQ #6,D0/) {
        saw_mode6 = 1
    }
    if (u ~ /PEA 7\.W/ || u ~ /MOVEQ\.L #\$7,D0/ || u ~ /MOVEQ #7,D0/) {
        saw_mode7 = 1
    }
    if (u ~ /MOVEQ\.L #\$14,D[014]/ || u ~ /MOVEQ #20,D[014]/ || u ~ /#20,D4/) {
        saw_dsty20 = 1
    }
    if (u ~ /MOVEQ\.L #\$A,D[014]/ || u ~ /MOVEQ #10,D[014]/ || u ~ /#10,D4/) {
        saw_dsty10 = 1
    }
    if (u ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLA/ ||
        u ~ /ESQIFF_JMPTBL_TLIBA3_BUILDDISPLAYCONTEXTFORVIEWMODE/) {
        saw_build_context = 1
    }
    if (saw_full_mask_gate && saw_compact_gate && saw_wide_gate &&
        saw_mode4 && saw_mode5 && saw_mode6 && saw_mode7 &&
        saw_dsty20 && saw_dsty10 && saw_build_context) {
        has_display_mode_selection = 1
    }

    if (u ~ /_LVOSETRAST/) {
        saw_set_rast = 1
    }
    if (u ~ /_LVOSETAPEN/) {
        saw_set_apen = 1
    }
    if (u ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHS/ ||
        u ~ /ESQIFF_JMPTBL_BRUSH_SELECTBRUSHSLOT/) {
        saw_select_slot = 1
    }
    if (saw_set_rast && saw_set_apen && saw_select_slot) {
        has_draw_sequence = 1
    }

    if (u ~ /\$148\(A5\)/ || u ~ /328\(A0\)/ || u ~ /ESQIFF_BRUSH_PALETTEMODEOFFSET/) {
        saw_palette_mode = 1
    }
    if (u ~ /BRUSH_PLANEMASKFORINDEX/) {
        plane_mask_calls++
    }
    if (u ~ /WDISP_PALETTETRIPLESRBASE/) {
        saw_palette_triples = 1
    }
    if (saw_palette_mode && plane_mask_calls >= 2 && saw_palette_triples) {
        has_palette_refresh = 1
    }

    if (u ~ /ESQIFF_CAPTUREACCUMULATORVALUE/) {
        capture_calls++
    }
    if (u ~ /ACCUMULATOR_ROW[0-3]_CAPTUREVALUE/) {
        capture_value_hits++
    }
    if ((capture_calls >= 4 && capture_value_hits >= 4) ||
        capture_value_hits >= 8) {
        has_capture_sequence = 1
    }

    if (capture_enable_refs >= 2) {
        has_capture_enable_gate = 1
    }

    if (u ~ /ACCUMULATOR_ROW[0-3]_(SUM|SATURATEFLAG)/ &&
        (u ~ /CLR\.W/ || u ~ /MOVE\.W/ || u ~ /CLR.W/)) {
        accumulator_reset_hits++
    }
    if (accumulator_reset_hits >= 8) {
        has_accumulator_resets = 1
    }

    if (u ~ /ESQIFF_RUNCOPPERRISETRANSITION/) {
        has_rise_transition = 1
    }
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_BRUSH_HEAD_SELECT=" has_brush_head_select
    print "HAS_MISSING_RETRY_BITS=" has_missing_retry_bits
    print "HAS_TRANSITION_SEQUENCE=" has_transition_sequence
    print "HAS_ACCUMULATOR_COPY_SETUP=" has_accumulator_copy_setup
    print "HAS_DISPLAY_MODE_SELECTION=" has_display_mode_selection
    print "HAS_DRAW_SEQUENCE=" has_draw_sequence
    print "HAS_PALETTE_REFRESH=" has_palette_refresh
    print "HAS_CAPTURE_SEQUENCE=" has_capture_sequence
    print "HAS_CAPTURE_ENABLE_GATE=" has_capture_enable_gate
    print "HAS_ACCUMULATOR_RESETS=" has_accumulator_resets
    print "HAS_RISE_TRANSITION=" has_rise_transition
}
