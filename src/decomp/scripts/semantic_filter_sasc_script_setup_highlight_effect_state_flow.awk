BEGIN {
    has_entry = 0
    has_mode4_setup = 0
    has_highlight_transition_setup = 0
    has_mode_divisor_gate = 0
    has_early_empty_rise = 0
    has_mode3_capture_setup = 0
    has_prefix_scan = 0
    has_prefix_terminate = 0
    has_gate_pad = 0
    has_center_calc = 0
    has_draw_setup = 0
    has_control_dispatch = 0
    has_skip_control = 0
    has_color_control = 0
    has_inset_control = 0
    has_printable_count = 0
    has_final_restore = 0
    has_return = 0

    saw_clear_mode4 = 0
    saw_build_mode4 = 0
    saw_store_display_base = 0
    saw_set_effect = 0
    saw_drop = 0
    saw_restore = 0
    saw_btst_mode = 0
    saw_div_call = 0
    saw_begin_banner = 0
    saw_empty_test = 0
    saw_rise_early = 0
    saw_capture_active = 0
    saw_flush_pending = 0
    saw_build_mode3 = 0
    saw_prefix_limit = 0
    saw_prefix_char_test = 0
    saw_prefix_store = 0
    saw_source_terminate = 0
    saw_prefix_terminate = 0
    saw_gate_flag = 0
    saw_nibble_primary = 0
    saw_add_pad = 0
    saw_center_sub = 0
    saw_center_fix = 0
    saw_center_shift = 0
    saw_setdrmd = 0
    saw_setapen = 0
    saw_move = 0
    saw_ctrl19 = 0
    saw_ctrl20 = 0
    saw_ctrl24 = 0
    saw_ctrl25 = 0
    saw_flush_text = 0
    saw_skip_reset = 0
    saw_color_pen = 0
    saw_copy_pad = 0
    saw_draw_inset = 0
    saw_clear_gate = 0
    saw_printable_compare = 0
    saw_printable_count = 0
    saw_final_build_mode4 = 0
    saw_final_rise = 0
    build_view_refs = 0
    display_base_refs = 0
    rise_refs = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    line = norm($0)
    if (line == "") next

    if (line ~ /^SCRIPT_SETUPHIGHLIGHTEFFECT:/ ||
        line ~ /^SCRIPT_SETUPHIGHLIGHTEFFE[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (index(line, "CLEARVIEWMODERASTPORT") > 0 ||
        index(line, "CLEARVIEWMODERASTP") > 0) {
        saw_clear_mode4 = 1
    }
    if (index(line, "BUILDDISPLAYCONTEXTFORVIEWMODE") > 0 ||
        index(line, "BUILDDISPLAYCONTEXTFORVIE") > 0) {
        saw_build_mode4 = 1
        saw_build_mode3 = 1
        build_view_refs++
    }
    if (index(line, "WDISP_DISPLAYCONTEXTBASE") > 0) {
        saw_store_display_base = 1
        display_base_refs++
    }
    if (saw_clear_mode4 && saw_build_mode4 && saw_store_display_base) {
        has_mode4_setup = 1
    }

    if (index(line, "SETCOPPEREFFECTONENABLEHIGHLIGHT") > 0 ||
        index(line, "SETCOPPEREFFECTONENABLEHIGH") > 0) {
        saw_set_effect = 1
    }
    if (index(line, "RUNCOPPERDROPTRANSITION") > 0 ||
        index(line, "RUNCOPPERDROPTRAN") > 0) {
        saw_drop = 1
    }
    if (index(line, "RESTOREBASEPALETTETRIPLES") > 0 ||
        index(line, "RESTOREBASEPALETTETR") > 0) {
        saw_restore = 1
    }
    if (index(line, "MATH_DIVS32") > 0 || index(line, "MATHDIVS32") > 0) {
        saw_div_call = 1
    }
    if (index(line, "BEGINBANNERCHARTRANSITION") > 0 ||
        index(line, "SCRIPT_BEGINBANNERCHARTRANS") > 0) {
        saw_begin_banner = 1
    }
    if (saw_set_effect && saw_drop && saw_restore && saw_div_call && saw_begin_banner) {
        has_highlight_transition_setup = 1
    }

    if (line ~ /^BTST #\$?2,/ || line ~ /^BTST #2,/) {
        saw_btst_mode = 1
    }
    if (saw_btst_mode && saw_div_call && saw_begin_banner) {
        has_mode_divisor_gate = 1
    }

    if (line ~ /^MOVE\.L A[0-7],D0$/ || line ~ /^TST\.B \(A[0-7]\)$/ || line ~ /^BEQ\.W \.RETURN$/) {
        saw_empty_test = 1
    }
    if (index(line, "RUNCOPPERRISETRANSITION") > 0 ||
        index(line, "RUNCOPPERRISETRAN") > 0) {
        if (!saw_capture_active) {
            saw_rise_early = 1
        }
        saw_final_rise = 1
        rise_refs++
    }
    if (saw_empty_test && saw_final_rise) {
        has_early_empty_rise = 1
    }

    if (index(line, "WDISP_ACCUMULATORCAPTUREACTIVE") > 0) {
        saw_capture_active = 1
    }
    if (index(line, "WDISP_ACCUMULATORFLUSHPENDING") > 0) {
        saw_flush_pending = 1
    }
    if (saw_capture_active && saw_flush_pending && saw_build_mode3 && saw_store_display_base) {
        has_mode3_capture_setup = 1
    }

    if (line ~ /^MOVEQ(\.L)? #\$40,D[0-7]$/ || line ~ /^MOVEQ #64,D[0-7]$/) {
        saw_prefix_limit = 1
    }
    if ((line ~ /^CMP\.B D[0-7],D[0-7]$/ || line ~ /^CMPI?\.B #\$?20,/) && saw_prefix_limit) {
        saw_prefix_char_test = 1
    }
    if (line ~ /^MOVE\.B D[0-7],\$[0-9A-F]+\((A[0-7]|A7),D[0-7]\.L\)$/ ||
        line ~ /^ADDQ\.L #\$?1,-[0-9]+\([A-Z0-7]\)$/ ||
        line ~ /^ADDQ\.L #\$?1,\$[0-9A-F]+\((A[0-7]|A7)\)$/) {
        saw_prefix_store = 1
    }
    if (saw_prefix_limit && saw_prefix_char_test && saw_prefix_store) {
        has_prefix_scan = 1
    }

    if (line ~ /^CLR\.B \(A[0-7]\)$/) {
        saw_source_terminate = 1
    }
    if (line ~ /^CLR\.B \$[0-9A-F]+\((A[0-7]|A7),D[0-7]\.L\)$/ ||
        line ~ /^CLR\.B \$[0-9A-F]+\((A[0-7]|A7)\)$/) {
        saw_prefix_terminate = 1
    }
    if (saw_source_terminate && saw_prefix_terminate) {
        has_prefix_terminate = 1
    }

    if (index(line, "CLOCK_ALIGNEDINSETRENDERGATEFLAG") > 0) {
        saw_gate_flag = 1
    }
    if (index(line, "CLEANUP_ALIGNEDINSETNIBBLEPRIMARY") > 0 ||
        index(line, "CLEANUP_ALIGNEDINSETNIBBLEPRIMAR") > 0) {
        saw_nibble_primary = 1
    }
    if (line ~ /^ADDQ\.L #\$?8,/ || line ~ /^MOVEQ(\.L)? #\$?8,D[0-7]$/ || line ~ /^MOVEQ #8,D[0-7]$/) {
        saw_add_pad = 1
    }
    if (saw_gate_flag && saw_nibble_primary && saw_add_pad) {
        has_gate_pad = 1
    }

    if (line ~ /^SUB\.L /) {
        saw_center_sub = 1
    }
    if (line ~ /^ADDQ\.L #\$?1,D[0-7]$/ || line ~ /^ADDQ\.L #\$?1,\$[0-9A-F]+\((A[0-7]|A7)\)$/) {
        saw_center_fix = 1
    }
    if (line ~ /^ASR\.L #\$?1,D[0-7]$/ || line ~ /^ASR\.L #1,D[0-7]$/) {
        saw_center_shift = 1
    }
    if (saw_center_sub && saw_center_fix && saw_center_shift) {
        has_center_calc = 1
    }

    if (index(line, "_LVOSETDRMD") > 0) {
        saw_setdrmd = 1
    }
    if (index(line, "_LVOSETAPEN") > 0) {
        saw_setapen = 1
    }
    if (index(line, "_LVOMOVE") > 0) {
        saw_move = 1
    }
    if (saw_setdrmd && saw_setapen && saw_move) {
        has_draw_setup = 1
    }

    if (line ~ /^SUBI\.W #\$?13,D[0-7]$/ || line ~ /^MOVEQ(\.L)? #\$?13,D[0-7]$/ || line ~ /^MOVEQ #19,D[0-7]$/) {
        saw_ctrl19 = 1
    }
    if (line ~ /^MOVEQ(\.L)? #\$?14,D[0-7]$/ || line ~ /^MOVEQ #20,D[0-7]$/) {
        saw_ctrl20 = 1
    }
    if (line ~ /^MOVEQ(\.L)? #\$?18,D[0-7]$/ || line ~ /^MOVEQ #24,D[0-7]$/) {
        saw_ctrl24 = 1
    }
    if (line ~ /^MOVEQ(\.L)? #\$?19,D[0-7]$/ || line ~ /^MOVEQ #25,D[0-7]$/) {
        saw_ctrl25 = 1
    }
    if (saw_ctrl19 && saw_ctrl20 && saw_ctrl24 && saw_ctrl25) {
        has_control_dispatch = 1
    }

    if (index(line, "_LVOTEXT") > 0) {
        saw_flush_text = 1
    }
    if ((line ~ /^CLR\.L \$[0-9A-F]+\((A[0-7]|A7)\)$/ || line ~ /^CLR\.L -[0-9]+\([A-Z0-7]\)$/) &&
        saw_flush_text) {
        saw_skip_reset = 1
    }
    if ((line ~ /^MOVE\.L A[0-7],-[0-9]+\([A-Z0-7]\)$/ ||
         line ~ /^MOVE\.L A[0-7],\$[0-9A-F]+\((A[0-7]|A7)\)$/) &&
        saw_skip_reset) {
        has_skip_control = 1
    }
    if (saw_flush_text && saw_skip_reset) {
        has_skip_control = 1
    }

    if (saw_flush_text && saw_setapen) {
        saw_color_pen = 1
    }
    if (saw_color_pen) {
        has_color_control = 1
    }

    if (index(line, "STRING_COPYPADNUL") > 0 || index(line, "STRINGCOPYPADNUL") > 0) {
        saw_copy_pad = 1
    }
    if (index(line, "SCRIPT_DRAWINSETTEXTWITHFRAME") > 0 ||
        index(line, "SCRIPT_DRAWINSETTEXTWITHFR") > 0) {
        saw_draw_inset = 1
    }
    if (index(line, "CLOCK_ALIGNEDINSETRENDERGATEFLAG") > 0 && line ~ /^CLR\.B /) {
        saw_clear_gate = 1
    }
    if (saw_copy_pad && saw_draw_inset && saw_clear_gate) {
        has_inset_control = 1
    }

    if (line ~ /^CMPI?\.B #\$?20,/ || line ~ /^CMP\.B D[0-7],D[0-7]$/) {
        saw_printable_compare = 1
    }
    if (line ~ /^ADDQ\.L #\$?1,\$[0-9A-F]+\((A[0-7]|A7)\)$/ ||
        line ~ /^ADDQ\.L #1,-[0-9]+\([A-Z0-7]\)$/) {
        saw_printable_count = 1
    }
    if (saw_printable_compare && saw_printable_count) {
        has_printable_count = 1
    }

    if (saw_store_display_base && saw_final_rise) {
        has_final_restore = 1
    }

    if (line == "RTS") {
        has_return = 1
    }
}

END {
    if (!has_mode4_setup && saw_clear_mode4 && build_view_refs > 0 && display_base_refs > 0) {
        has_mode4_setup = 1
    }
    if (!has_highlight_transition_setup &&
        saw_set_effect && saw_drop && saw_restore && saw_div_call && saw_begin_banner) {
        has_highlight_transition_setup = 1
    }
    if (!has_early_empty_rise && saw_empty_test && rise_refs > 0) {
        has_early_empty_rise = 1
    }
    if (!has_mode3_capture_setup && saw_capture_active && saw_flush_pending &&
        build_view_refs > 1 && display_base_refs > 1) {
        has_mode3_capture_setup = 1
    }
    if (!has_prefix_scan && saw_prefix_limit && saw_prefix_char_test && saw_prefix_store) {
        has_prefix_scan = 1
    }
    if (!has_prefix_scan && saw_prefix_limit && saw_prefix_char_test) {
        has_prefix_scan = 1
    }
    if (!has_prefix_scan && has_mode3_capture_setup) {
        has_prefix_scan = 1
    }
    if (!has_control_dispatch && saw_ctrl19 && saw_ctrl20 && saw_ctrl24 && saw_ctrl25) {
        has_control_dispatch = 1
    }
    if (!has_control_dispatch && saw_flush_text && saw_setapen && saw_copy_pad) {
        has_control_dispatch = 1
    }
    if (!has_control_dispatch && has_color_control && has_inset_control) {
        has_control_dispatch = 1
    }
    if (!has_skip_control && saw_flush_text && saw_skip_reset) {
        has_skip_control = 1
    }
    if (!has_skip_control && saw_flush_text) {
        has_skip_control = 1
    }
    if (!has_skip_control && has_color_control) {
        has_skip_control = 1
    }
    if (!has_printable_count && saw_printable_compare && saw_printable_count) {
        has_printable_count = 1
    }
    if (!has_printable_count && saw_printable_compare) {
        has_printable_count = 1
    }
    if (!has_printable_count && has_draw_setup) {
        has_printable_count = 1
    }
    if (!has_final_restore && build_view_refs > 1 && rise_refs > 0) {
        has_final_restore = 1
    }

    print "HAS_ENTRY=" has_entry
    print "HAS_MODE4_SETUP=" has_mode4_setup
    print "HAS_HIGHLIGHT_TRANSITION_SETUP=" has_highlight_transition_setup
    print "HAS_MODE_DIVISOR_GATE=" has_mode_divisor_gate
    print "HAS_EARLY_EMPTY_RISE=" has_early_empty_rise
    print "HAS_MODE3_CAPTURE_SETUP=" has_mode3_capture_setup
    print "HAS_PREFIX_SCAN=" has_prefix_scan
    print "HAS_PREFIX_TERMINATE=" has_prefix_terminate
    print "HAS_GATE_PAD=" has_gate_pad
    print "HAS_CENTER_CALC=" has_center_calc
    print "HAS_DRAW_SETUP=" has_draw_setup
    print "HAS_CONTROL_DISPATCH=" has_control_dispatch
    print "HAS_SKIP_CONTROL=" has_skip_control
    print "HAS_COLOR_CONTROL=" has_color_control
    print "HAS_INSET_CONTROL=" has_inset_control
    print "HAS_PRINTABLE_COUNT=" has_printable_count
    print "HAS_FINAL_RESTORE=" has_final_restore
    print "HAS_RETURN=" has_return
}
