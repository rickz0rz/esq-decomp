BEGIN{h_entry=0;h_switch=0;h_editor=0;h_should_open=0;h_update=0;h_detail=0;h_find_next=0;h_status=0;h_validate=0;h_grid_mode=0;h_column=0;h_state_globals=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_PROCESSSCHEDULESTATE:/ || l ~ /^NEWGRID_PROCESSSCHEDULESTATE[A-Z0-9_]*:/)h_entry=1
    if(l ~ /STATE_JUMPTABLE/ || l ~ /JMP .*\(PC,D0\.W\)/ || l ~ /SCHEDULEWORKFLOWSTATE/ && l ~ /CMP/)h_switch=1
    if(l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/ || l ~ /HANDLEGRIDEDITORSTATE/)h_editor=1
    if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/ || l ~ /SHOULDOPENEDITOR/)h_should_open=1
    if(l ~ /(JSR|BSR).*UPDATEGRIDSTATE/ || l ~ /UPDATEGRIDSTATE/)h_update=1
    if(l ~ /(JSR|BSR).*HANDLEDETAILGRIDSTATE/ || l ~ /HANDLEDETAILGRIDSTATE/)h_detail=1
    if(l ~ /(JSR|BSR).*FINDNEXTENTRYWITHALTMARKERS/ || l ~ /FINDNEXTENTRYWITHALTMAR/)h_find_next=1
    if(l ~ /(JSR|BSR).*DRAWSTATUSMESSAGE/ || l ~ /DRAWSTATUSMESSAGE/)h_status=1
    if(l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/ || l ~ /VALIDATESELECTIONCODE/)h_validate=1
    if(l ~ /(JSR|BSR).*GETGRIDMODEINDEX/ || l ~ /GETGRIDMODEINDEX/)h_grid_mode=1
    if(l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/ || l ~ /COMPUTECOLUMNINDEX/)h_column=1
    if(l ~ /SCHEDULEWORKFLOWSTATE/ || l ~ /SCHEDULEALTSELECTORFLAG/ || l ~ /SCHEDULEEDITORGATEFLAG/ || l ~ /SELECTEDPRIMARYENTRYINDEX/)h_state_globals=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_STATE_SWITCH="h_switch
    print "HAS_EDITOR_STATE_PATH="h_editor
    print "HAS_SHOULD_OPEN_EDITOR="h_should_open
    print "HAS_UPDATE_GRID_STATE="h_update
    print "HAS_DETAIL_STATE="h_detail
    print "HAS_FIND_NEXT_ALT="h_find_next
    print "HAS_STATUS_DRAW="h_status
    print "HAS_VALIDATE_SELECTION="h_validate
    print "HAS_GRID_MODE_INDEX="h_grid_mode
    print "HAS_COLUMN_INDEX="h_column
    print "HAS_STATE_GLOBALS="h_state_globals
    print "HAS_RTS="h_rts
}
