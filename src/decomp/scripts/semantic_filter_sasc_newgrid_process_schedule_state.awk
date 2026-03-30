BEGIN{
    h_entry=0
    h_switch=0
    h_state_guard=0
    h_nullctx_clear=0
    h_stepped_flag=0
    h_mode_b=0
    h_mode_f=0
    h_mode_l=0
    h_mode_y=0
    h_mode_n=0
    h_seed_36=0
    h_seed_52=0
    h_state5=0
    h_state6=0
    h_state7=0
    h_row_offset=0
    h_selection_cache=0
    editor_calls=0
    should_open_calls=0
    update_calls=0
    detail_calls=0
    find_next_calls=0
    status_calls=0
    validate_calls=0
    grid_mode_calls=0
    column_calls=0
    editor_reenter_checks=0
    alt_selector_writes=0
    editor_gate_writes=0
    saw_nullctx_state_clear=0
    saw_nullctx_selection_clear=0
    h_state_globals=0
    h_digital_seed_sequence=0
    h_digital_column_adjust=0
    h_state0_gate_alt_setup=0
    h_state1_transition=0
    h_state2_gate_flow=0
    h_state7_alt_teardown=0
    digital_stage=0
    column_adjust_stage=0
    state0_setup_stage=0
    state1_stage=0
    state2_clear_seen=0
    state2_store3_seen=0
    state7_stage=0
    h_rts=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_PROCESSSCHEDULESTATE:/ || l ~ /^NEWGRID_PROCESSSCHEDULESTATE[A-Z0-9_]*:/)h_entry=1
    if(l ~ /STATE_JUMPTABLE/ || l ~ /JMP .*\(PC,D0\.W\)/ || l ~ /__SWITCH_NEWGRID_PROCESSSCHEDULESTATE/)h_switch=1
    if(l ~ /CMPI\.L #\$8,D0/ || l ~ /CMPI\.L #\$8,NEWGRID_SCHEDULEWORKFLOWSTATE/ || l ~ /CMPI\.L #8,D0/ || l ~ /CMPI\.L #8,NEWGRID_SCHEDULEWORKFLOWSTATE/)h_state_guard=1
    if(l ~ /#\$42/ || l ~ /#66([^0-9]|$)/)h_mode_b=1
    if(l ~ /#\$46/ || l ~ /#70([^0-9]|$)/)h_mode_f=1
    if(l ~ /#\$4C/ || l ~ /#76([^0-9]|$)/)h_mode_l=1
    if(l ~ /#\$59/ || l ~ /#89([^0-9]|$)/)h_mode_y=1
    if(l ~ /#\$4E/ || l ~ /#78([^0-9]|$)/)h_mode_n=1
    if(l ~ /#\$24/ || l ~ /#36([^0-9]|$)/)h_seed_36=1
    if(l ~ /#\$34/ || l ~ /#52([^0-9]|$)/)h_seed_52=1
    if(l ~ /#\$5/ || l ~ /#5([^0-9]|$)/)h_state5=1
    if(l ~ /#\$6/ || l ~ /#6([^0-9]|$)/)h_state6=1
    if(l ~ /#\$7/ || l ~ /#7([^0-9]|$)/)h_state7=1
    if(l ~ /SCHEDULEROWOFFSET/)h_row_offset=1
    if(l ~ /SCHEDULESELECTIONCODECAC/ || l ~ /SCHEDULESELECTIONCODECACHE/)h_selection_cache=1
    if(l ~ /MOVEQ(\.L)? #\$?1,D5/ || l ~ /MOVEQ(\.L)? #1,D5/)h_stepped_flag=1
    if(l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/)editor_calls++
    if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/)should_open_calls++
    if(l ~ /(JSR|BSR).*UPDATEGRIDSTATE/)update_calls++
    if(l ~ /(JSR|BSR).*HANDLEDETAILGRIDSTATE/)detail_calls++
    if(l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMARKERS/ || l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMAR/)find_next_calls++
    if(l ~ /(JSR|BSR).*DRAWSTATUSMESSAGE/)status_calls++
    if(l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/)validate_calls++
    if(l ~ /(JSR|BSR).*GETGRIDMODEINDEX/)grid_mode_calls++
    if(l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/)column_calls++
    if(l ~ /MOVE\.L D[02],NEWGRID_SCHEDULEEDITORGATEFLAG/) {
        if (state0_setup_stage < 1) state0_setup_stage = 1
    }
    if(state0_setup_stage >= 1 && l ~ /MOVE\.L D[02],NEWGRID_SCHEDULEALTSELECTORFLAG/) {
        state0_setup_stage = 2
    }
    if(state0_setup_stage >= 2 && l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMARKERS/ || state0_setup_stage >= 2 && l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMAR/) {
        state0_setup_stage = 3
    }
    if(state0_setup_stage >= 3 && l ~ /CLR\.W NEWGRID_SCHEDULEROWOFFSET/) {
        state0_setup_stage = 4
        h_state0_gate_alt_setup = 1
    }
    if((l ~ /(JSR|BSR).*DRAWSTATUSMESSAGE/) && state1_stage < 1)state1_stage = 1
    if(state1_stage >= 1 && l ~ /CLR\.L NEWGRID_SCHEDULESELECTIONCODECAC/)state1_stage = 2
    if(state1_stage >= 2 && (l ~ /TST\.L NEWGRID_SCHEDULEEDITORGATEFLAG/ || l ~ /MOVE\.L NEWGRID_SCHEDULEEDITORGATEFLAG,D0/))state1_stage = 3
    if(state1_stage >= 3 && (l ~ /MOVEQ(\.L)? #\$?2,D0/ || l ~ /MOVEQ(\.L)? #2,D0/))state1_stage = 4
    if(state1_stage >= 3 && (l ~ /MOVEQ(\.L)? #\$?3,D0/ || l ~ /MOVEQ(\.L)? #3,D0/))state1_stage = 5
    if(state1_stage >= 4 && l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/)h_state1_transition = 1
    if(l ~ /CLR\.L NEWGRID_SCHEDULEEDITORGATEFLAG/)state2_clear_seen = 1
    if(state2_clear_seen && (l ~ /MOVEQ(\.L)? #\$?3,D0/ || l ~ /MOVEQ(\.L)? #3,D0/))state2_store3_seen = 1
    if(state2_store3_seen && l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/)h_state2_gate_flow = 1
    if(l ~ /TST\.L NEWGRID_SCHEDULEALTSELECTORFLAG/ && state7_stage < 1)state7_stage = 1
    if(state7_stage >= 1 && (l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/))state7_stage = 2
    if(state7_stage >= 1 && (l ~ /CLR\.L NEWGRID_SCHEDULEWORKFLOWSTATE/ || l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/))state7_stage = 5
    if(state7_stage >= 5 && (l ~ /CLR\.L NEWGRID_SCHEDULEALTSELECTORFLAG/ || l ~ /MOVE\.L D0,NEWGRID_SCHEDULEALTSELECTORFLAG/)) {
        state7_stage = 6
        h_state7_alt_teardown = 1
    }
    if(l ~ /MOVE\.B GCOMMAND_DIGITALMPLEXENABLEDFLAG/) {
        if (digital_stage < 1) digital_stage = 1
        if (column_adjust_stage < 1) column_adjust_stage = 1
    }
    if(digital_stage == 1 && (l ~ /MOVEQ(\.L)? #\$59,D1/ || l ~ /MOVEQ(\.L)? #89,D1/))digital_stage = 2
    if(digital_stage == 2 && l ~ /CMP\.B D1,D0/)digital_stage = 3
    if(digital_stage == 3 && l ~ /TST\.L D5/)digital_stage = 4
    if(digital_stage == 4 && l ~ /CMPI\.L #\$?1,NEWGRID_SCHEDULESELECTIONCODECAC/)digital_stage = 5
    if(digital_stage == 5 && l ~ /MOVE\.B GCOMMAND_MPLEXDETAILLAYOUTFLAG/)digital_stage = 6
    if(digital_stage == 6 && (l ~ /MOVEQ(\.L)? #\$4E,D1/ || l ~ /MOVEQ(\.L)? #78,D1/))digital_stage = 7
    if(digital_stage == 7 && l ~ /CMP\.B D1,D0/)digital_stage = 8
    if(digital_stage == 8 && (l ~ /MOVEQ(\.L)? #\$24,D0/ || l ~ /MOVEQ(\.L)? #36,D0/ || l ~ /MOVEQ(\.L)? #\$34,D0/ || l ~ /MOVEQ(\.L)? #52,D0/))digital_stage = 9
    if(digital_stage >= 8 && l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/)digital_stage = 10
    if(digital_stage >= 10 && l ~ /(JSR|BSR).*GETGRIDMODEINDEX/)digital_stage = 11
    if(digital_stage >= 11 && l ~ /MOVE\.L D0,NEWGRID_SCHEDULESELECTIONCODECAC/) {
        digital_stage = 12
        h_digital_seed_sequence = 1
    }
    if(column_adjust_stage >= 1 && l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/)column_adjust_stage = 2
    if(column_adjust_stage >= 2 && l ~ /SUB\.L D0,NEWGRID_SCHEDULESELECTIONCODECAC/) {
        column_adjust_stage = 3
        h_digital_column_adjust = 1
    }
    if(l ~ /MOVE\.L D0,NEWGRID_SCHEDULEWORKFLOWSTATE/)saw_nullctx_state_clear=1
    if(l ~ /MOVE\.L D0,NEWGRID_SELECTEDPRIMARYENTRYIND/)saw_nullctx_selection_clear=1
    if(saw_nullctx_state_clear && saw_nullctx_selection_clear)h_nullctx_clear=1
    if(l ~ /SUBQ\.L #\$?5,D0/ || l ~ /CMPI\.L #\$?5,NEWGRID_SCHEDULEWORKFLOWSTATE/ || (l ~ /MOVEQ(\.L)? #\$?5,D0/ && l ~ /CMP\.L NEWGRID_SCHEDULEWORKFLOWSTATE/))editor_reenter_checks++
    if(l ~ /NEWGRID_SCHEDULEALTSELECTORFLAG/) {
        if(l ~ /CLR\.L NEWGRID_SCHEDULEALTSELECTORFLAG/ || l ~ /MOVE\.L .*NEWGRID_SCHEDULEALTSELECTORFLAG/)alt_selector_writes++
    }
    if(l ~ /NEWGRID_SCHEDULEEDITORGATEFLAG/) {
        if(l ~ /CLR\.L NEWGRID_SCHEDULEEDITORGATEFLAG/ || l ~ /MOVE\.L .*NEWGRID_SCHEDULEEDITORGATEFLAG/)editor_gate_writes++
    }
    if(l ~ /SCHEDULEWORKFLOWSTATE/ || l ~ /SCHEDULEALTSELECTORFLAG/ || l ~ /SCHEDULEEDITORGATEFLAG/ || l ~ /SELECTEDPRIMARYENTRYINDEX/)h_state_globals=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_STATE_SWITCH="h_switch
    print "HAS_STATE_GUARD="h_state_guard
    print "HAS_NULLCTX_CLEAR="h_nullctx_clear
    print "HAS_STEPPED_FLAG="h_stepped_flag
    print "HAS_MODE_B="h_mode_b
    print "HAS_MODE_F="h_mode_f
    print "HAS_MODE_L="h_mode_l
    print "HAS_MODE_Y="h_mode_y
    print "HAS_MODE_N="h_mode_n
    print "HAS_SEED_36="h_seed_36
    print "HAS_SEED_52="h_seed_52
    print "HAS_STATE5="h_state5
    print "HAS_STATE6="h_state6
    print "HAS_STATE7="h_state7
    print "HAS_ROW_OFFSET="h_row_offset
    print "HAS_SELECTION_CACHE="h_selection_cache
    print "EDITOR_CALLS="editor_calls
    print "SHOULD_OPEN_CALLS="should_open_calls
    print "UPDATE_CALLS="update_calls
    print "DETAIL_CALLS="detail_calls
    print "FIND_NEXT_CALLS="find_next_calls
    print "STATUS_CALLS="status_calls
    print "VALIDATE_CALLS="validate_calls
    print "GRID_MODE_CALLS="grid_mode_calls
    print "COLUMN_CALLS="column_calls
    print "HAS_DIGITAL_SEED_SEQUENCE="h_digital_seed_sequence
    print "HAS_DIGITAL_COLUMN_ADJUST="h_digital_column_adjust
    print "EDITOR_REENTER_CHECKS="editor_reenter_checks
    print "ALT_SELECTOR_WRITES="alt_selector_writes
    print "EDITOR_GATE_WRITES="editor_gate_writes
    print "HAS_STATE_GLOBALS="h_state_globals
    print "HAS_STATE0_GATE_ALT_SETUP="h_state0_gate_alt_setup
    print "HAS_STATE1_TRANSITION="h_state1_transition
    print "HAS_STATE2_GATE_FLOW="h_state2_gate_flow
    print "HAS_STATE7_ALT_TEARDOWN="h_state7_alt_teardown
    print "HAS_RTS="h_rts
}
