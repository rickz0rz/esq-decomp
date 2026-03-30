BEGIN {
    h_entry = 0
    h_nullctx_editor_reset = 0
    h_nullctx_state5_route = 0
    h_nullctx_final_clear = 0
    h_state0_gate_alt_seed = 0
    h_state0_search_loop = 0
    h_state1_draw_and_select = 0
    h_state2_editor_reenter = 0
    h_state2_gate_clear_to3 = 0
    h_state34_to_state5 = 0
    h_state5_digital_adjust = 0
    h_state5_no_entry_to6 = 0
    h_state6_loop = 0
    h_state6_store = 0
    h_state7_editor_reenter = 0
    h_state7_teardown = 0
    h_state7_clear_only = 0
    h_return = 0

    state0_stage = 0
    state1_stage = 0
    state2_reenter_stage = 0
    state2_clear_stage = 0
    state34_stage = 0
    state5_digital_stage = 0
    state5_no_entry_stage = 0
    state6_loop_stage = 0
    state6_store_stage = 0
    state7_reenter_stage = 0
    state7_teardown_stage = 0
    state7_clear_stage = 0
    nullctx_state5_stage = 0

    saw_should_open = 0
    saw_update = 0
    saw_detail = 0
    saw_find_next = 0
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

    if (l ~ /^NEWGRID_PROCESSSCHEDULESTATE:/ || l ~ /^NEWGRID_PROCESSSCHEDULESTATE[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /(JSR|BSR).*SHOULDOPENEDITOR/) {
        saw_should_open = 1
    }
    if (l ~ /(JSR|BSR).*UPDATEGRIDSTATE/) {
        saw_update = 1
    }
    if (l ~ /(JSR|BSR).*HANDLEDETAILGRIDSTATE/) {
        saw_detail = 1
    }
    if (l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMARKERS/ || l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMAR/) {
        saw_find_next = 1
    }

    if (l ~ /SUBQ\.L #\$?2,D0/ || l ~ /MOVEQ(\.L)? #\$?2,D1/ || l ~ /MOVEQ(\.L)? #\$?2,D0/) {
        nullctx_state5_stage = 1
    }
    if (nullctx_state5_stage >= 1 && (l ~ /SUBQ\.L #\$?3,D0/ || l ~ /MOVEQ(\.L)? #\$?5,D0/)) {
        nullctx_state5_stage = 2
    }
    if (nullctx_state5_stage >= 2 && saw_should_open && (saw_update || saw_detail)) {
        h_nullctx_state5_route = 1
    }
    if (l ~ /CLR\.L -\(A7\)/ && saw_update == 0 && saw_detail == 0) {
        h_nullctx_editor_reset = 1
    }
    if (l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/ && l !~ /SCHEDULEWORKFLOWSTATE\(A4\).*,-\(A7\)/) {
        state7_clear_stage = 0
    }
    if (l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/ || l ~ /CLR\.L NEWGRID_SCHEDULEWORKFLOWSTATE/) {
        if (nullctx_state5_stage >= 1) {
            nullctx_state5_stage = 3
        }
    }
    if (nullctx_state5_stage >= 3 &&
        (l ~ /MOVE\.L D0,NEWGRID_SELECTEDPRIMARYENTRYIND/ || l ~ /CLR\.L NEWGRID_SELECTEDPRIMARYENTRYIND/)) {
        h_nullctx_final_clear = 1
    }

    if (state0_stage < 1 && l ~ /NEWGRID_SCHEDULEEDITORGATEFLAG/) {
        state0_stage = 1
    }
    if (state0_stage >= 1 && l ~ /NEWGRID_SCHEDULEALTSELECTORFLAG/) {
        state0_stage = 2
    }
    if (state0_stage >= 2 && saw_find_next) {
        state0_stage = 3
    }
    if (state0_stage >= 3 && l ~ /CLR\.W NEWGRID_SCHEDULEROWOFFSET/) {
        h_state0_gate_alt_seed = 1
    }
    if (h_state0_gate_alt_seed &&
        l ~ /NEWGRID_SCHEDULEROWOFFSET/ &&
        saw_find_next &&
        (l ~ /ADDQ\.W #\$?1,NEWGRID_SCHEDULEROWOFFSET/ || l ~ /MOVE\.W D2,NEWGRID_SCHEDULEROWOFFSET/)) {
        h_state0_search_loop = 1
    }

    if (state1_stage < 1 && l ~ /(JSR|BSR).*DRAWSTATUSMESSAGE/) {
        state1_stage = 1
    }
    if (state1_stage >= 1 && l ~ /CLR\.L NEWGRID_SCHEDULESELECTIONCODECAC/) {
        state1_stage = 2
    }
    if (state1_stage >= 2 && l ~ /NEWGRID_SCHEDULEEDITORGATEFLAG/) {
        state1_stage = 3
    }
    if (state1_stage >= 3 &&
        (l ~ /MOVEQ(\.L)? #\$?2,D0/ || l ~ /MOVEQ(\.L)? #\$?3,D0/ ||
         l ~ /MOVEQ(\.L)? #\$?2,D1/ || l ~ /SUB\.B D0,D1/)) {
        h_state1_draw_and_select = 1
    }

    if (state2_reenter_stage < 1 && l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/) {
        state2_reenter_stage = 1
    }
    if (state2_reenter_stage >= 1 && l ~ /SUBQ\.L #\$?5,D0/) {
        state2_reenter_stage = 2
    }
    if (state2_reenter_stage >= 2 && (l ~ /MOVEQ(\.L)? #\$?2,D0/ || l ~ /MOVEQ(\.L)? #\$?2,D1/)) {
        h_state2_editor_reenter = 1
    }
    if (state2_clear_stage < 1 && l ~ /CLR\.L NEWGRID_SCHEDULEEDITORGATEFLAG/) {
        state2_clear_stage = 1
    }
    if (state2_clear_stage >= 1 && l ~ /MOVEQ(\.L)? #\$?3,D0/) {
        state2_clear_stage = 2
    }
    if (state2_clear_stage >= 2 && l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/) {
        h_state2_gate_clear_to3 = 1
    }

    if (state34_stage < 1 && saw_find_next) {
        state34_stage = 1
    }
    if (state34_stage >= 1 && (l ~ /MOVEQ(\.L)? #\$?1,D5/ || l ~ /MOVEQ(\.L)? #\$?1,D[0-7]/ || l ~ /MOVEQ(\.L)? #\$?1,D5/)) {
        state34_stage = 2
    }
    if (state34_stage >= 2 && saw_should_open) {
        h_state34_to_state5 = 1
    }

    if (state5_digital_stage < 1 && l ~ /GCOMMAND_DIGITALMPLEXENABLEDFLAG/) {
        state5_digital_stage = 1
    }
    if (state5_digital_stage >= 1 && l ~ /#\$59|#89([^0-9]|$)/) {
        state5_digital_stage = 2
    }
    if (state5_digital_stage >= 2 && l ~ /GCOMMAND_MPLEXDETAILLAYOUTFLAG/) {
        state5_digital_stage = 3
    }
    if (state5_digital_stage >= 3 && (l ~ /#\$24/ || l ~ /#36([^0-9]|$)|#\$34|#52([^0-9]|$)/)) {
        state5_digital_stage = 4
    }
    if (state5_digital_stage >= 4 && l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/) {
        state5_digital_stage = 5
    }
    if (state5_digital_stage >= 5 && l ~ /(JSR|BSR).*GETGRIDMODEINDEX/) {
        state5_digital_stage = 6
    }
    if (state5_digital_stage >= 6 && l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/) {
        state5_digital_stage = 7
    }
    if (state5_digital_stage >= 7 && l ~ /SUB\.L D0,NEWGRID_SCHEDULESELECTIONCODECAC/) {
        h_state5_digital_adjust = 1
    }

    if (state5_no_entry_stage < 1 && l ~ /MOVEQ(\.L)? #\$?6,D0/) {
        state5_no_entry_stage = 1
    }
    if (state5_no_entry_stage >= 1 && l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/) {
        h_state5_no_entry_to6 = 1
    }

    if (state6_loop_stage < 1 && l ~ /NEWGRID_SELECTEDPRIMARYENTRYIND/) {
        state6_loop_stage = 1
    }
    if (state6_loop_stage >= 1 && l ~ /NEWGRID_SCHEDULEROWOFFSET/) {
        state6_loop_stage = 2
    }
    if (state6_loop_stage >= 2 && (l ~ /ADDQ\.W #\$?1,NEWGRID_SCHEDULEROWOFFSET/ || l ~ /MOVE\.W D2,NEWGRID_SCHEDULEROWOFFSET/)) {
        state6_loop_stage = 3
    }
    if (state6_loop_stage >= 3 && saw_find_next) {
        h_state6_loop = 1
    }
    if (state6_store_stage < 1 && l ~ /MOVEQ(\.L)? #\$?7,D0/) {
        state6_store_stage = 1
    }
    if (state6_store_stage >= 1 && l ~ /MOVEQ(\.L)? #\$?1,D0/) {
        state6_store_stage = 2
    }
    if (state6_store_stage >= 2 && l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/) {
        h_state6_store = 1
    }

    if (state7_reenter_stage < 1 && l ~ /TST\.L NEWGRID_SCHEDULEALTSELECTORFLAG/) {
        state7_reenter_stage = 1
    }
    if (state7_reenter_stage >= 1 && l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/) {
        state7_reenter_stage = 2
    }
    if (state7_reenter_stage >= 2 && l ~ /SUBQ\.L #\$?5,D0/) {
        state7_reenter_stage = 3
    }
    if (state7_reenter_stage >= 3 && l ~ /MOVEQ(\.L)? #\$?7,D0/) {
        h_state7_editor_reenter = 1
    }

    if (state7_teardown_stage < 1 &&
        (l ~ /CLR\.L NEWGRID_SCHEDULEWORKFLOWSTATE/ || l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/)) {
        state7_teardown_stage = 1
    }
    if (state7_teardown_stage >= 1 &&
        (l ~ /CLR\.L NEWGRID_SCHEDULEALTSELECTORFLAG/ || l ~ /MOVE\.L D0,NEWGRID_SCHEDULEALTSELECTORFLAG/)) {
        h_state7_teardown = 1
    }

    if (state7_clear_stage < 1 && l ~ /TST\.L NEWGRID_SCHEDULEALTSELECTORFLAG/) {
        state7_clear_stage = 1
    }
    if (state7_clear_stage >= 1 &&
        (l ~ /CLR\.L NEWGRID_SCHEDULEWORKFLOWSTATE/ || l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/)) {
        h_state7_clear_only = 1
    }

    if ((l ~ /MOVE\.L NEWGRID_SCHEDULEWORKFLOWSTATE,D0/ ||
         l ~ /MOVE\.L NEWGRID_SCHEDULEWORKFLOWSTATE\(A4\),D0/ ||
         l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/) &&
        h_state6_store && h_state7_teardown) {
        h_return = 1
    }
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_NULLCTX_EDITOR_RESET=" h_nullctx_editor_reset
    print "HAS_NULLCTX_STATE5_ROUTE=" h_nullctx_state5_route
    print "HAS_NULLCTX_FINAL_CLEAR=" h_nullctx_final_clear
    print "HAS_STATE0_GATE_ALT_SEED=" h_state0_gate_alt_seed
    print "HAS_STATE0_SEARCH_LOOP=" h_state0_search_loop
    print "HAS_STATE1_DRAW_AND_SELECT=" h_state1_draw_and_select
    print "HAS_STATE2_EDITOR_REENTER=" h_state2_editor_reenter
    print "HAS_STATE2_GATE_CLEAR_TO3=" h_state2_gate_clear_to3
    print "HAS_STATE34_TO_STATE5=" h_state34_to_state5
    print "HAS_STATE5_DIGITAL_ADJUST=" h_state5_digital_adjust
    print "HAS_STATE5_NO_ENTRY_TO6=" h_state5_no_entry_to6
    print "HAS_STATE6_LOOP=" h_state6_loop
    print "HAS_STATE6_STORE=" h_state6_store
    print "HAS_STATE7_EDITOR_REENTER=" h_state7_editor_reenter
    print "HAS_STATE7_TEARDOWN=" h_state7_teardown
    print "HAS_STATE7_CLEAR_ONLY=" h_state7_clear_only
    print "HAS_RETURN=" h_return
}
