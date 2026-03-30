BEGIN {
    has_entry=0
    has_nullctx_state_gate=0
    has_nullctx_editor_reset=0
    has_nullctx_editor_gate=0
    has_nullctx_update_grid=0
    has_nullctx_grid_entries=0
    has_nullctx_clear_state=0
    has_dispatch_switch=0
    has_state0_scan=0
    has_state0_miss_return=0
    has_state0_to_state2=0
    has_state2_editor_mode_check=0
    has_state2_editor_call=0
    has_state2_to_state3=0
    has_state3_scan=0
    has_state5_no_entry=0
    has_state5_should_open=0
    has_state5_update_grid=0
    has_state5_process_entries=0
    has_state5_hint49_gate=0
    has_state5_hint33_gate=0
    has_state5_column_adjust=0
    has_state7_editor_mode_check=0
    has_state7_editor_call=0
    has_state7_restore_state7=0
    has_state7_clear_state=0
    has_return_state=0
    has_const_minus1=0
    has_const33=0
    has_const49=0
    has_const66=0
    has_const70=0
    has_const76=0
    has_const89=0
    has_rts=0
    saw_zero_d0=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    u=trim($0)
    if (u=="") next
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /MOVEQ(\.L)? #[\$]?0,D0/) {
        saw_zero_d0=1
    } else if (u !~ /^MOVE\.L D0,NEWGRID_SECONDARYWORKFLOWSTATE/ && u !~ /^MOVE\.L D0,NEWGRID_SECONDARYWORKFLOWSTATE\(A4\)/) {
        saw_zero_d0=0
    }

    if (u ~ /^NEWGRID_PROCESSSECONDARYSTATE:/ || u ~ /^NEWGRID_PROCESSSECONDARYSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /SECONDARYWORKFLOWSTATE/ && ((u ~ /SUBQ\.L #2,D0/ && u ~ /BEQ/) || u ~ /SUBQ\.L #\$7,D0/ || u ~ /SUBQ\.L #7,D0/)) has_nullctx_state_gate=1
    if (n ~ /HANDLEGRIDEDITORSTATE/ && n ~ /MOVELD0A7/ && n !~ /DIGITALNICHELISTINGSTEM/) has_nullctx_editor_reset=1
    if (n ~ /SECONDARYSELECTEDENTRYIN/ && n ~ /TEXTDISPPRIMARYENTRYPTRTABLE/) has_nullctx_editor_gate=1
    if (n ~ /UPDATEGRIDSTATE/ && n !~ /SECONDARYSELECTEDENTRYIN/) has_nullctx_update_grid=1
    if (n ~ /PROCESSGRIDENTRIES/ && n !~ /SECONDARYSELECTEDENTRYIN/) has_nullctx_grid_entries=1
    if (n ~ /SECONDARYWORKFLOWSTATE/ && n ~ /SECONDARYSELECTEDENTRYIN/ && u ~ /MOVEQ/ && u ~ /#0/) has_nullctx_clear_state=1
    if ((n ~ /SECONDARYWORKFLOWSTATE/ && u ~ /CMPI\.L #\$8,D0/) || u ~ /^__SWITCH_NEWGRID_PROCESSSECONDARYSTATE_/ || u ~ /^\.STATE_JUMPTABLE:/) has_dispatch_switch=1
    if (n ~ /SECONDARYSELECTIONHINTCO/ || (n ~ /FINDNEXTENTRYWITHFLAGS/ && n ~ /SECONDARYWORKFLOWSTATE/)) has_state0_scan=1
    if (u ~ /ADDQ\.L #\$1,D0/ || u ~ /ADDQ\.L #1,D0/) has_state0_miss_return=1
    if (n ~ /SECONDARYWORKFLOWSTATE/ && (u ~ /MOVEQ #2,D0/ || u ~ /MOVEQ\.L #\$2,D0/)) has_state0_to_state2=1
    if (n ~ /GCOMMANDNICHEWORKFLOWMODE/ && ((u ~ /#66/ || u ~ /#\$42/) || (u ~ /#70/ || u ~ /#\$46/))) has_state2_editor_mode_check=1
    if (n ~ /GCOMMANDDIGITALNICHELISTINGSTEM/ || n ~ /GCOMMANDDIGITALNICHELISTINGSTEMPLATEPTR/) has_state2_editor_call=1
    if (n ~ /SECONDARYWORKFLOWSTATE/ && (u ~ /MOVEQ #3,D0/ || u ~ /MOVEQ\.L #\$3,D0/)) has_state2_to_state3=1
    if (n ~ /FINDNEXTENTRYWITHFLAGS/ || (n ~ /SECONDARYSELECTEDENTRYIN/ && (u ~ /MOVEQ #1,D6/ || u ~ /MOVEQ\.L #\$1,D6/))) has_state3_scan=1
    if ((n ~ /SECONDARYSELECTEDENTRYIN/ && n ~ /MOVEQFFD1/) || (n ~ /SECONDARYWORKFLOWSTATE/ && (u ~ /MOVEQ #7,D1/ || u ~ /MOVEQ\.L #\$7,D1/))) has_state5_no_entry=1
    if (n ~ /SHOULDOPENEDITOR/ && n ~ /TEXTDISPPRIMARYENTRYPTRTABLE/) has_state5_should_open=1
    if (n ~ /UPDATEGRIDSTATE/ && n ~ /SECONDARYSELECTEDENTRYIN/) has_state5_update_grid=1
    if (n ~ /PROCESSGRIDENTRIES/ && n ~ /SECONDARYSELECTEDENTRYIN/) has_state5_process_entries=1
    if ((n ~ /CONFIGNEWGRIDSELECTIONCODE4849/ || n ~ /CONFIGNEWGRIDSELECTIONCODE4849ENABLEDFLAG/) || u ~ /PEA \(\$31\)\.W/ || u ~ /PEA 49\.W/) has_state5_hint49_gate=1
    if (n ~ /GCOMMANDDIGITALNICHEENABLEDFLAG/ || u ~ /PEA \(\$21\)\.W/ || u ~ /PEA 33\.W/) has_state5_hint33_gate=1
    if (n ~ /SECONDARYSELECTIONHINTCO/ && n ~ /COMPUTECOLUMNINDEX/) has_state5_column_adjust=1
    if (n ~ /GCOMMANDNICHEWORKFLOWMODE/ && ((u ~ /#66/ || u ~ /#\$42/) || (u ~ /#76/ || u ~ /#\$4C/))) has_state7_editor_mode_check=1
    if (n ~ /HANDLEGRIDEDITORSTATE/ && (n ~ /DIGITALNICHELISTINGSTEM/ || n ~ /DIGITALNICHELISTINGSTEMPLATEPTR/)) has_state7_editor_call=1
    if (n ~ /SECONDARYWORKFLOWSTATE/ && (u ~ /MOVEQ #7,D0/ || u ~ /MOVEQ\.L #\$7,D0/)) has_state7_restore_state7=1
    if (n ~ /CLRLNEWGRIDSECONDARYWORKFLOWSTATE/ || (saw_zero_d0 && n ~ /MOVELD0NEWGRIDSECONDARYWORKFLOWSTATE/)) has_state7_clear_state=1
    if (n ~ /MOVENEWGRIDSECONDARYWORKFLOWSTATED0/) has_return_state=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ #-1,D1/ || u ~ /MOVEQ\.L #\$FFFFFFFF,D1/) has_const_minus1=1
    if (u ~ /#33([^0-9]|$)/ || u ~ /#\$21/ || u ~ /33\.W/ || u ~ /\(\$21\)\.W/) has_const33=1
    if (u ~ /#49([^0-9]|$)/ || u ~ /#\$31/ || u ~ /49\.W/ || u ~ /\(\$31\)\.W/) has_const49=1
    if (u ~ /#66([^0-9]|$)/ || u ~ /#\$42/) has_const66=1
    if (u ~ /#70([^0-9]|$)/ || u ~ /#\$46/) has_const70=1
    if (u ~ /#76([^0-9]|$)/ || u ~ /#\$4C/) has_const76=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/) has_const89=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_NULLCTX_STATE_GATE="has_nullctx_state_gate
    print "HAS_NULLCTX_EDITOR_RESET="has_nullctx_editor_reset
    print "HAS_NULLCTX_EDITOR_GATE="has_nullctx_editor_gate
    print "HAS_NULLCTX_UPDATE_GRID="has_nullctx_update_grid
    print "HAS_NULLCTX_GRID_ENTRIES="has_nullctx_grid_entries
    print "HAS_NULLCTX_CLEAR_STATE="has_nullctx_clear_state
    print "HAS_DISPATCH_SWITCH="has_dispatch_switch
    print "HAS_STATE0_SCAN="has_state0_scan
    print "HAS_STATE0_MISS_RETURN="has_state0_miss_return
    print "HAS_STATE0_TO_STATE2="has_state0_to_state2
    print "HAS_STATE2_EDITOR_MODE_CHECK="has_state2_editor_mode_check
    print "HAS_STATE2_EDITOR_CALL="has_state2_editor_call
    print "HAS_STATE2_TO_STATE3="has_state2_to_state3
    print "HAS_STATE3_SCAN="has_state3_scan
    print "HAS_STATE5_NO_ENTRY="has_state5_no_entry
    print "HAS_STATE5_SHOULD_OPEN="has_state5_should_open
    print "HAS_STATE5_UPDATE_GRID="has_state5_update_grid
    print "HAS_STATE5_PROCESS_ENTRIES="has_state5_process_entries
    print "HAS_STATE5_HINT49_GATE="has_state5_hint49_gate
    print "HAS_STATE5_HINT33_GATE="has_state5_hint33_gate
    print "HAS_STATE5_COLUMN_ADJUST="has_state5_column_adjust
    print "HAS_STATE7_EDITOR_MODE_CHECK="has_state7_editor_mode_check
    print "HAS_STATE7_EDITOR_CALL="has_state7_editor_call
    print "HAS_STATE7_RESTORE_STATE7="has_state7_restore_state7
    print "HAS_STATE7_CLEAR_STATE="has_state7_clear_state
    print "HAS_RETURN_STATE="has_return_state
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_CONST_33="has_const33
    print "HAS_CONST_49="has_const49
    print "HAS_CONST_66="has_const66
    print "HAS_CONST_70="has_const70
    print "HAS_CONST_76="has_const76
    print "HAS_CONST_89="has_const89
    print "HAS_RTS="has_rts
}
