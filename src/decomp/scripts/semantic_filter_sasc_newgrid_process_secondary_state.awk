BEGIN {
    has_entry=0
    has_workflow=0
    has_selected=0
    has_hint=0
    has_find_next=0
    has_editor_state=0
    has_update_grid=0
    has_process_entries=0
    has_should_open=0
    has_validate=0
    has_mode_index=0
    has_column_index=0
    has_niche_mode=0
    has_niche_enabled=0
    has_flag48=0
    has_const8=0
    has_const7=0
    has_const5=0
    has_const49=0
    has_const33=0
    has_const89=0
    has_const_minus1=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^NEWGRID_PROCESSSECONDARYSTATE:/ || u ~ /^NEWGRID_PROCESSSECONDARYSTAT[A-Z0-9_]*:/) has_entry=1
    if (n ~ /NEWGRIDSECONDARYWORKFLOWSTATE/) has_workflow=1
    if (n ~ /NEWGRIDSECONDARYSELECTEDENTRYINDEX/ || n ~ /NEWGRIDSECONDARYSELECTEDENTRYIN/) has_selected=1
    if (n ~ /NEWGRIDSECONDARYSELECTIONHINTCOUNTER/ || n ~ /NEWGRIDSECONDARYSELECTIONHINTCO/) has_hint=1
    if (n ~ /NEWGRIDFINDNEXTENTRYWITHFLAGS/) has_find_next=1
    if (n ~ /NEWGRIDHANDLEGRIDEDITORSTATE/) has_editor_state=1
    if (n ~ /NEWGRIDUPDATEGRIDSTATE/) has_update_grid=1
    if (n ~ /NEWGRIDPROCESSGRIDENTRIES/) has_process_entries=1
    if (n ~ /NEWGRIDSHOULDOPENEDITOR/) has_should_open=1
    if (n ~ /NEWGRIDVALIDATESELECTIONCODE/) has_validate=1
    if (n ~ /NEWGRIDGETGRIDMODEINDEX/) has_mode_index=1
    if (n ~ /NEWGRIDCOMPUTECOLUMNINDEX/) has_column_index=1
    if (n ~ /GCOMMANDNICHEWORKFLOWMODE/) has_niche_mode=1
    if (n ~ /GCOMMANDDIGITALNICHEENABLEDFLAG/) has_niche_enabled=1
    if (n ~ /CONFIGNEWGRIDSELECTIONCODE4849ENABLEDFLAG/ || n ~ /CONFIGNEWGRIDSELECTIONCODE4849/) has_flag48=1
    if (u ~ /#8([^0-9]|$)/ || u ~ /#\$08/ || u ~ /#\$8([^0-9A-F]|$)/ || u ~ /8\.[Ww]/ || u ~ /\(\$8\)/) has_const8=1
    if (u ~ /#7([^0-9]|$)/ || u ~ /#\$07/ || u ~ /#\$7([^0-9A-F]|$)/ || u ~ /7\.[Ww]/ || u ~ /\(\$7\)/) has_const7=1
    if (u ~ /#5([^0-9]|$)/ || u ~ /#\$05/ || u ~ /#\$5([^0-9A-F]|$)/ || u ~ /5\.[Ww]/ || u ~ /\(\$5\)/) has_const5=1
    if (u ~ /#49([^0-9]|$)/ || u ~ /#\$31/ || u ~ /49\.[Ww]/ || u ~ /\(\$31\)/) has_const49=1
    if (u ~ /#33([^0-9]|$)/ || u ~ /#\$21/ || u ~ /33\.[Ww]/ || u ~ /\(\$21\)/) has_const33=1
    if (u ~ /#89([^0-9]|$)/ || u ~ /#\$59/ || u ~ /89\.[Ww]/ || u ~ /\(\$59\)/) has_const89=1
    if (u ~ /#-1([^0-9]|$)/ || u ~ /#\$FF/ || u ~ /#\$FFFFFFFF/ || u ~ /MOVEQ\.L #\$FF,D[0-7]/) has_const_minus1=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_WORKFLOW_GLOBAL="has_workflow
    print "HAS_SELECTED_GLOBAL="has_selected
    print "HAS_HINT_COUNTER_GLOBAL="has_hint
    print "HAS_FIND_NEXT_CALL="has_find_next
    print "HAS_EDITOR_STATE_CALL="has_editor_state
    print "HAS_UPDATE_GRID_CALL="has_update_grid
    print "HAS_PROCESS_ENTRIES_CALL="has_process_entries
    print "HAS_SHOULD_OPEN_CALL="has_should_open
    print "HAS_VALIDATE_CALL="has_validate
    print "HAS_MODE_INDEX_CALL="has_mode_index
    print "HAS_COLUMN_INDEX_CALL="has_column_index
    print "HAS_NICHE_MODE_GLOBAL="has_niche_mode
    print "HAS_NICHE_ENABLED_GLOBAL="has_niche_enabled
    print "HAS_FLAG48_49_GLOBAL="has_flag48
    print "HAS_CONST_8="has_const8
    print "HAS_CONST_7="has_const7
    print "HAS_CONST_5="has_const5
    print "HAS_CONST_49="has_const49
    print "HAS_CONST_33="has_const33
    print "HAS_CONST_89="has_const89
    print "HAS_CONST_MINUS1="has_const_minus1
    print "HAS_RTS="has_rts
}
