BEGIN {
    has_entry = 0
    has_nullctx_state2_gate = 0
    has_nullctx_state5_gate = 0
    has_nullctx_editor_reset = 0
    has_nullctx_should_open_editor = 0
    has_nullctx_update_grid = 0
    has_nullctx_showtimes = 0
    has_nullctx_reinit = 0
    has_state_switch = 0
    has_state0_init = 0
    has_state0_input = 0
    has_state1_message = 0
    has_state1_column_reset = 0
    has_state2_mode_bf_gate = 0
    has_state2_editor = 0
    has_state2_retry_on5 = 0
    has_state34_input = 0
    has_state5_entry_gate = 0
    has_state5_update_grid = 0
    has_state5_showtimes = 0
    has_state5_ppv_gate = 0
    has_state5_validate53 = 0
    has_state5_mode_index = 0
    has_state5_column_subtract = 0
    has_state5_no_entry_to7 = 0
    has_state7_mode_bl_gate = 0
    has_state7_editor = 0
    has_state7_retry_on5 = 0
    has_clear_ge8 = 0
    has_clear_markers_on_zero = 0
    has_return_state = 0
    prev = ""
    prev2 = ""
    prev3 = ""
    prev4 = ""
    after_switch = 0
    selection_input_calls = 0
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
    l = norm($0)
    if (l == "") {
        next
    }

    if (l ~ /^NEWGRID_PROCESSSHOWTIMESWORKFLOW:/ || l ~ /^NEWGRID_PROCESSSHOWTIMESWORKFLOW[A-Z0-9_]*:/) {
        has_entry = 1
    }

    if (l ~ /SUBQ\.L #\$?2,D0|MOVEQ\.L #\$?2,D1|MOVEQ #2,D1/) {
        seen_nullctx_cmp2 = 1
    }
    if (seen_nullctx_cmp2 && l ~ /NEWGRID_SHOWTIMESWORKFLOWSTATE/ && l ~ /CMP\.L D1,D0|SUBQ\.L #\$?2,D0/) {
        has_nullctx_state2_gate = 1
    }
    if (l ~ /MOVEQ\.L #\$?5,D0|SUBQ\.L #\$?3,D0|SUBQ\.L #\$?5,D0/) {
        seen_nullctx_cmp5 = 1
    }
    if (seen_nullctx_cmp5 &&
        (l ~ /NEWGRID_SHOWTIMESWORKFLOWSTATE/ || l ~ /MOVE\.L D4,D0|MOVE\.L NEWGRID_SHOWTIMESWORKFLOWSTATE\(A4\),D4/)) {
        has_nullctx_state5_gate = 1
    }

    if (l ~ /NEWGRID_HANDLEGRIDEDITORSTATE/ && !has_state_switch) {
        has_nullctx_editor_reset = 1
    }
    if (l ~ /NEWGRID_SHOULDOPENEDITOR/ && !has_state_switch) {
        has_nullctx_should_open_editor = 1
    }
    if (l ~ /NEWGRID_UPDATEGRIDSTATE/ && !has_state_switch) {
        has_nullctx_update_grid = 1
    }
    if (l ~ /NEWGRID_HANDLESHOWTIMESSTATE/ && !has_state_switch) {
        has_nullctx_showtimes = 1
    }
    if (l ~ /NEWGRID_INITSELECTIONWINDOW/ && !has_state_switch) {
        has_nullctx_reinit = 1
    }

    if (l ~ /(MOVE\.W \.STATE_JUMPTABLE\(PC,D0\.W\),D0|MOVE\.W \$6\(PC,D0\.W\),D0)/) {
        has_state_switch = 1
        after_switch = 1
    }

    if (after_switch && l ~ /NEWGRID_INITSELECTIONWINDOW/ &&
        (prev ~ /MOVE\.L D0,-\(A7\)/ || prev2 ~ /MOVE\.W D7,D0/ || prev3 ~ /MOVE\.W D7,D0/ ||
         prev2 ~ /MOVE\.L D7,D0/ || prev3 ~ /MOVE\.L D7,D0/ || prev4 ~ /MOVE\.L D7,D0/)) {
        has_state0_init = 1
    }
    if (after_switch && l ~ /NEWGRID_UPDATESELECTIONFROMINPUT/) {
        selection_input_calls++
        if (selection_input_calls >= 1) has_state0_input = 1
        if (selection_input_calls >= 2) has_state34_input = 1
    }

    if (after_switch && l ~ /NEWGRID_DRAWGRIDMESSAGEALT/) has_state1_message = 1
    if (after_switch && l ~ /CLR\.L NEWGRID_SHOWTIMESCOLUMNADJUST/ && prev ~ /ADDQ\.W #\$?4,A7/) {
        has_state1_column_reset = 1
    }

    if (after_switch && (l ~ /MOVEQ\.L #\$42,D1/ || l ~ /MOVEQ #66,D1/)) {
        seen_state2_b = 1
    }
    if (after_switch && (l ~ /MOVEQ\.L #\$46,D1/ || l ~ /MOVEQ #70,D1/)) {
        seen_state2_f = 1
    }
    if (seen_state2_b && seen_state2_f) has_state2_mode_bf_gate = 1
    if (after_switch && l ~ /NEWGRID_HANDLEGRIDEDITORSTATE/ &&
        (prev ~ /MOVE\.L A[35],-\(A7\)/ || prev2 ~ /GCOMMAND_PPVLISTINGSTEMPLATEPTR/)) {
        editor_state_calls++
        if (editor_state_calls >= 1) has_state2_editor = 1
        if (editor_state_calls >= 2) has_state7_editor = 1
    }
    if (after_switch && l ~ /SUBQ\.L #\$?5,D0/) {
        retry_on5_hits++
        if (retry_on5_hits >= 1) has_state2_retry_on5 = 1
        if (retry_on5_hits >= 2) has_state7_retry_on5 = 1
    }

    if (after_switch && l ~ /TST\.L NEWGRID_SHOWTIMESSELECTIONCONTEX/) has_state5_entry_gate = 1
    if (after_switch && l ~ /NEWGRID_UPDATEGRIDSTATE/ &&
        (prev ~ /MOVE\.L A[35],-\(A7\)/ || prev2 ~ /NEWGRID_SHOWTIMESWORKFLOWARGLONG/)) {
        state5_update_grid_calls++
        if (state5_update_grid_calls >= 1) has_state5_update_grid = 1
    }
    if (after_switch && l ~ /NEWGRID_HANDLESHOWTIMESSTATE/ &&
        prev ~ /MOVE\.L A[35],-\(A7\)/) {
        state5_showtimes_calls++
        if (state5_showtimes_calls >= 1) has_state5_showtimes = 1
    }
    if (after_switch && (l ~ /MOVEQ\.L #\$59,D1/ || l ~ /MOVEQ #89,D1/)) {
        seen_state5_y = 1
    }
    if (after_switch && l ~ /GCOMMAND_DIGITALPPVENABLEDFLAG/) {
        seen_state5_ppv_flag = 1
    }
    if (seen_state5_y && seen_state5_ppv_flag) has_state5_ppv_gate = 1
    if (after_switch && (l ~ /PEA 53\.W/ || l ~ /PEA \(\$35\)\.W/ || l ~ /MOVE\.L #\$35,-\(A7\)/)) {
        seen_validate53_arg = 1
    }
    if (after_switch && l ~ /NEWGRID_VALIDATESELECTIONCODE/ && seen_validate53_arg) {
        has_state5_validate53 = 1
    }
    if (after_switch && l ~ /NEWGRID_GETGRIDMODEINDEX/) has_state5_mode_index = 1
    if (after_switch && l ~ /SUB\.L D0,NEWGRID_SHOWTIMESCOLUMNADJUST/) has_state5_column_subtract = 1
    if (after_switch && (l ~ /MOVEQ\.L #\$?7,D0/ || l ~ /MOVEQ #7,D0/) &&
        prev ~ /BEQ\.B ___NEWGRID_PROCESSSHOWTIMESWORKFLOW__34|BEQ\.W \.CASE5_NO_ENTRY/) {
        has_state5_no_entry_to7 = 1
    }
    if (!has_state5_no_entry_to7 && after_switch &&
        l ~ /MOVE\.L D0,NEWGRID_SHOWTIMESWORKFLOWSTATE/ &&
        prev ~ /MOVEQ(\.L)? #\$?7,D0/) {
        has_state5_no_entry_to7 = 1
    }

    if (after_switch && (l ~ /MOVEQ\.L #\$42,D1/ || l ~ /MOVEQ #66,D1/)) {
        seen_state7_b = 1
    }
    if (after_switch && (l ~ /MOVEQ\.L #\$4C,D1/ || l ~ /MOVEQ #76,D1/)) {
        seen_state7_l = 1
    }
    if (seen_state7_b && seen_state7_l) has_state7_mode_bl_gate = 1

    if (after_switch && l ~ /CLR\.L NEWGRID_SHOWTIMESWORKFLOWSTATE/) has_clear_ge8 = 1

    if (l ~ /TST\.L NEWGRID_SHOWTIMESWORKFLOWSTATE/ || l ~ /MOVE\.L NEWGRID_SHOWTIMESWORKFLOWSTATE,D0/ || l ~ /MOVE\.L NEWGRID_SHOWTIMESWORKFLOWSTATE\(A4\),D0/) {
        seen_return_state_test = 1
    }
    if (seen_return_state_test && l ~ /NEWGRID_CLEARENTRYMARKERBITS/) has_clear_markers_on_zero = 1
    if (l ~ /MOVE\.L NEWGRID_SHOWTIMESWORKFLOWSTATE,D0/ || l ~ /MOVE\.L NEWGRID_SHOWTIMESWORKFLOWSTATE\(A4\),D0/) {
        has_return_state = 1
    }
    if (l == "RTS") {
        has_return_state = 1
    }

    prev4 = prev3
    prev3 = prev2
    prev2 = prev
    prev = l
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULLCTX_STATE2_GATE=" has_nullctx_state2_gate
    print "HAS_NULLCTX_STATE5_GATE=" has_nullctx_state5_gate
    print "HAS_NULLCTX_EDITOR_RESET=" has_nullctx_editor_reset
    print "HAS_NULLCTX_SHOULD_OPEN_EDITOR=" has_nullctx_should_open_editor
    print "HAS_NULLCTX_UPDATE_GRID=" has_nullctx_update_grid
    print "HAS_NULLCTX_SHOWTIMES=" has_nullctx_showtimes
    print "HAS_NULLCTX_REINIT=" has_nullctx_reinit
    print "HAS_STATE_SWITCH=" has_state_switch
    print "HAS_STATE0_INIT=" has_state0_init
    print "HAS_STATE0_INPUT=" has_state0_input
    print "HAS_STATE1_MESSAGE=" has_state1_message
    print "HAS_STATE1_COLUMN_RESET=" has_state1_column_reset
    print "HAS_STATE2_MODE_BF_GATE=" has_state2_mode_bf_gate
    print "HAS_STATE2_EDITOR=" has_state2_editor
    print "HAS_STATE2_RETRY_ON5=" has_state2_retry_on5
    print "HAS_STATE34_INPUT=" has_state34_input
    print "HAS_STATE5_ENTRY_GATE=" has_state5_entry_gate
    print "HAS_STATE5_UPDATE_GRID=" has_state5_update_grid
    print "HAS_STATE5_SHOWTIMES=" has_state5_showtimes
    print "HAS_STATE5_PPV_GATE=" has_state5_ppv_gate
    print "HAS_STATE5_VALIDATE53=" has_state5_validate53
    print "HAS_STATE5_MODE_INDEX=" has_state5_mode_index
    print "HAS_STATE5_COLUMN_SUBTRACT=" has_state5_column_subtract
    print "HAS_STATE5_NO_ENTRY_TO7=" has_state5_no_entry_to7
    print "HAS_STATE7_MODE_BL_GATE=" has_state7_mode_bl_gate
    print "HAS_STATE7_EDITOR=" has_state7_editor
    print "HAS_STATE7_RETRY_ON5=" has_state7_retry_on5
    print "HAS_CLEAR_GE8=" has_clear_ge8
    print "HAS_CLEAR_MARKERS_ON_ZERO=" has_clear_markers_on_zero
    print "HAS_RETURN_STATE=" has_return_state
}
