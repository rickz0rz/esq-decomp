BEGIN{
    h_entry=0
    h_switch=0
    h_state_guard=0
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
    h_state_globals=0
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
    if(l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/)editor_calls++
    if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/)should_open_calls++
    if(l ~ /(JSR|BSR).*UPDATEGRIDSTATE/)update_calls++
    if(l ~ /(JSR|BSR).*HANDLEDETAILGRIDSTATE/)detail_calls++
    if(l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMARKERS/ || l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMAR/)find_next_calls++
    if(l ~ /(JSR|BSR).*DRAWSTATUSMESSAGE/)status_calls++
    if(l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/)validate_calls++
    if(l ~ /(JSR|BSR).*GETGRIDMODEINDEX/)grid_mode_calls++
    if(l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/)column_calls++
    if(l ~ /SCHEDULEWORKFLOWSTATE/ || l ~ /SCHEDULEALTSELECTORFLAG/ || l ~ /SCHEDULEEDITORGATEFLAG/ || l ~ /SELECTEDPRIMARYENTRYINDEX/)h_state_globals=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_STATE_SWITCH="h_switch
    print "HAS_STATE_GUARD="h_state_guard
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
    print "HAS_STATE_GLOBALS="h_state_globals
    print "HAS_RTS="h_rts
}
