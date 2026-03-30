BEGIN {
    has_label = 0

    has_scan_marker_gate = 0
    has_scan_record_count = 0
    has_early_return_on_zero_records = 0

    saw_ctrl6_branch = 0
    saw_ctrl24_branch = 0
    saw_ctrl25_branch = 0
    saw_pen1_write = 0
    saw_pen3_write = 0
    saw_use_prevue_write = 0
    saw_extra_spacing_write = 0
    saw_segment_terminator = 0
    saw_line_divisor_bump = 0
    parse_space_rewrite = 0
    parse_finish_seen = 0
    has_parse_flow = 0

    has_alloc_mul10 = 0
    has_alloc_call = 0
    has_alloc_fail_return = 0

    render_pen_override_gate = 0
    render_font_switch_count = 0
    render_text_length_loop = 0
    render_inset_guard = 0
    render_width_clamp = 0
    render_spacing_adjust = 0
    render_baseline_add = 0
    render_center_round_fix = 0
    render_draw_call = 0
    has_render_flow = 0

    cleanup_pen_restore = 0
    cleanup_font_restore = 0
    cleanup_dealloc = 0
    has_cleanup_restore = 0
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
    n = u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOCK:/ || u ~ /^TLIBA1_DRAWFORMATTEDTEXTBLOC[A-Z0-9_]*:/) {
        has_label = 1
    }

    if (u ~ /TST\.W -40\(A5\)/ || u ~ /TST\.W \$36\(A7\)/) {
        has_scan_marker_gate = 1
    }
    if ((u ~ /ADDQ\.W #1,-18\(A5\)/ || u ~ /ADDQ\.W #\$1,\$44\(A7\)/) && has_scan_marker_gate) {
        has_scan_record_count = 1
    }
    if (u ~ /BEQ\.W \.RETURN_17A7/ || u ~ /BEQ\.W ___TLIBA1_DRAWFORMATTEDTEXTBLOCK__64/ || u ~ /BEQ\.L ___TLIBA1_DRAWFORMATTEDTEXTBLOCK__64/) {
        has_early_return_on_zero_records = 1
    }

    if (u ~ /MOVEQ #10,D1/ || u ~ /PEA \(\$A\)\.W/) {
        has_alloc_mul10 = 1
    }
    if (n ~ /MEMORYALLOCATEMEMORY/) {
        has_alloc_call = 1
    }
    if ((u ~ /TST\.L -4\(A5\)/ || u ~ /MOVE\.L D0,\$6C\(A7\)/ || u ~ /BEQ\.W ___TLIBA1_DRAWFORMATTEDTEXTBLOCK__64/) &&
        has_alloc_call) {
        has_alloc_fail_return = 1
    }

    if (u ~ /#24/ || u ~ /#\$18/) {
        saw_ctrl24_branch = 1
    }
    if (u ~ /#25/ || u ~ /#\$19/) {
        saw_ctrl25_branch = 1
    }
    if (u ~ /#6([^0-9]|$)/ || u ~ /#\$06/ || u ~ /#\$6([^0-9A-F]|$)/) {
        saw_ctrl6_branch = 1
    }
    if (u ~ /MOVE\.W #1,0\(A0,D1\.L\)/ || u ~ /MOVE\.W #\$1,\(A6\)/ || u ~ /MOVE\.W #\$1,\(A0,D[0-7]\.L\)/ || u ~ /MOVE\.W D[0-7],\(A6\)/) {
        saw_pen1_write = 1
    }
    if (u ~ /MOVE\.W #3,0\(A0,D1\.L\)/ || u ~ /MOVE\.W #\$3,\(A0,D[0-7]\.L\)/ || u ~ /MOVE\.W #3,\(A0,D[0-7]\.L\)/ || u ~ /MOVE\.W #\$3,\(A1\)/ || u ~ /MOVE\.W #3,\(A1\)/) {
        saw_pen3_write = 1
    }
    if (u ~ /4\(A0,D[0-7]\.L\)/ || u ~ /\$4\(A6\)/ || u ~ /\$4\(A1\)/) {
        saw_use_prevue_write = 1
    }
    if (u ~ /8\(A0,D[0-7]\.L\)/ || u ~ /\$8\(A6\)/ || u ~ /\$8\(A1\)/) {
        saw_extra_spacing_write = 1
    }
    if (u ~ /CLR\.B \(A0\)/) {
        saw_segment_terminator = 1
    }
    if (u ~ /ADDQ\.W #1,-32\(A5\)/ || u ~ /ADDQ\.W #\$1,\$40\(A7\)/) {
        saw_line_divisor_bump = 1
    }
    if (u ~ /MOVE\.B #\$20,\(A0\)/ || u ~ /MOVE\.B #32,\(A0\)/) {
        parse_space_rewrite = 1
    }
    if ((u ~ /ADDQ\.W #1,-32\(A5\)/ || u ~ /ADDQ\.W #\$1,\$40\(A7\)/) &&
        (u ~ /MOVE\.W D0,-10\(A5\)/ || u ~ /MOVE\.W D0,\$32\(A7\)/ || u ~ /MOVE\.W #1,\$32\(A7\)/)) {
        parse_finish_seen = 1
    }
    if (saw_ctrl6_branch && saw_ctrl24_branch && saw_ctrl25_branch &&
        saw_segment_terminator && parse_space_rewrite) {
        has_parse_flow = 1
    }

    if (u ~ /TEXTDISP_LINEPENOVERRIDEENABLEDFLAG/) {
        render_pen_override_gate = 1
    }
    if (n ~ /LVOSETFONT/) {
        render_font_switch_count++
    }
    if ((u ~ /TST\.B \(A1\)\+/ || u ~ /TST\.B \(A0\)\+/) &&
        (u ~ /BNE\.S \.IF_NE_17A0/ || u ~ /BNE\.B ___TLIBA1_DRAWFORMATTEDTEXTBLOCK__/)) {
        render_text_length_loop = 1
    }
    if (u ~ /CLOCK_ALIGNEDINSETRENDERGATEFLAG/ || u ~ /CLEANUP_ALIGNEDINSETNIBBLEPRIMARY/) {
        render_inset_guard = 1
    }
    if (u ~ /CMP\.W D1,D0/ || u ~ /CMP\.W D0,D1/ || u ~ /CMP\.W \$60\(A7\),D0/ || u ~ /CMP\.W \$46\(A7\),D0/) {
        render_width_clamp = 1
    }
    if ((u ~ /TST\.W 8\(A0,D2\.L\)/ || u ~ /TST\.W 8\(A0,D0\.L\)/ || u ~ /TST\.W \$8\(A0\)/ || u ~ /TST\.W \$8\(A0,D[0-7]\.L\)/) &&
        (u ~ /ADDQ\.W #1,D2/ || u ~ /ADDQ\.W #\$1,D1/ || u ~ /ADDQ\.W #\$1,\$3C\(A7\)/ || u ~ /ADD\.W D2,-30\(A5\)/ || u ~ /ADD\.W D1,\$3C\(A7\)/)) {
        render_spacing_adjust = 1
    }
    if (u ~ /MOVE\.W 58\(A3\),D2/ || u ~ /MOVE\.W \$3E\(A2\),D2/ || u ~ /TXBASELINE/) {
        render_baseline_add = 1
    }
    if (u ~ /ADDQ\.L #1,D1/ || u ~ /ADDQ\.L #\$1,\$50\(A7\)/ || u ~ /ASR\.L #1,D1/ || u ~ /ASR\.L #\$1,D0/) {
        render_center_round_fix = 1
    }
    if (n ~ /TLIBA1DRAWINLINESTYLEDTEXT/) {
        render_draw_call = 1
    }
    if (render_inset_guard && render_draw_call) {
        has_render_flow = 1
    }

    if (u ~ /MOVE\.B -21\(A5\),D0/ || u ~ /MOVE\.B \$5C\(A7\),D0/) {
        cleanup_pen_restore = 1
    }
    if (u ~ /MOVEA?\.L -26\(A5\),A0/ || u ~ /MOVE\.L \$78\(A7\),\(A7\)/ || u ~ /MOVE\.L \$70\(A7\),A0/) {
        cleanup_font_restore = 1
    }
    if (n ~ /MEMORYDEALLOCATEMEMORY/ && (u ~ /2385/ || u ~ /#\$951/ || u ~ /\$951/)) {
        cleanup_dealloc = 1
    }
    if (cleanup_pen_restore && cleanup_dealloc) {
        has_cleanup_restore = 1
    }
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SCAN_MARKER_GATE=" has_scan_marker_gate
    print "HAS_SCAN_RECORD_COUNT=" has_scan_record_count
    print "HAS_EARLY_RETURN_ON_ZERO_RECORDS=" has_early_return_on_zero_records
    print "HAS_ALLOC_MUL10=" has_alloc_mul10
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_FAIL_RETURN=" has_alloc_fail_return
    print "HAS_PARSE_FLOW=" has_parse_flow
    print "HAS_RENDER_FLOW=" has_render_flow
    print "HAS_CLEANUP_RESTORE=" has_cleanup_restore
}
