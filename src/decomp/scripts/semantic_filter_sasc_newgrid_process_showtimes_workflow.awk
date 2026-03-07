BEGIN{h_entry=0;h_switch=0;h_editor=0;h_should=0;h_update=0;h_showtimes=0;h_init=0;h_sel_input=0;h_msg=0;h_validate=0;h_grid=0;h_col=0;h_clear=0;h_state_globals=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_PROCESSSHOWTIMESWORKFLOW:/ || l ~ /^NEWGRID_PROCESSSHOWTIMESWORKFLOW[A-Z0-9_]*:/)h_entry=1
    if(l ~ /STATE_JUMPTABLE/ || l ~ /SHOWTIMESWORKFLOWSTATE/ && l ~ /CMP/)h_switch=1
    if(l ~ /(JSR|BSR).*HANDLEGRIDEDITORSTATE/ || l ~ /HANDLEGRIDEDITORSTATE/)h_editor=1
    if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/ || l ~ /SHOULDOPENEDITOR/)h_should=1
    if(l ~ /(JSR|BSR).*UPDATEGRIDSTATE/ || l ~ /UPDATEGRIDSTATE/)h_update=1
    if(l ~ /(JSR|BSR).*HANDLESHOWTIMESSTATE/ || l ~ /HANDLESHOWTIMESSTATE/)h_showtimes=1
    if(l ~ /(JSR|BSR).*INITSELECTIONWINDOW/ || l ~ /INITSELECTIONWINDOW/)h_init=1
    if(l ~ /(JSR|BSR).*UPDATESELECTIONFROMINPUT/ || l ~ /UPDATESELECTIONFROMINPUT/)h_sel_input=1
    if(l ~ /(JSR|BSR).*DRAWGRIDMESSAGEALT/ || l ~ /DRAWGRIDMESSAGEALT/)h_msg=1
    if(l ~ /(JSR|BSR).*VALIDATESELECTIONCODE/ || l ~ /VALIDATESELECTIONCODE/)h_validate=1
    if(l ~ /(JSR|BSR).*GETGRIDMODEINDEX/ || l ~ /GETGRIDMODEINDEX/)h_grid=1
    if(l ~ /(JSR|BSR).*COMPUTECOLUMNINDEX/ || l ~ /COMPUTECOLUMNINDEX/)h_col=1
    if(l ~ /(JSR|BSR).*CLEARENTRYMARKERBITS/ || l ~ /CLEARENTRYMARKERBITS/)h_clear=1
    if(l ~ /SHOWTIMESWORKFLOWSTATE/ || l ~ /SHOWTIMESSELECTIONCONTEXTPTR/ || l ~ /SHOWTIMESCOLUMNADJUST/)h_state_globals=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_STATE_SWITCH="h_switch
    print "HAS_EDITOR_STATE_PATH="h_editor
    print "HAS_SHOULD_OPEN_EDITOR="h_should
    print "HAS_UPDATE_GRID_STATE="h_update
    print "HAS_SHOWTIMES_STATE="h_showtimes
    print "HAS_INIT_SELECTION="h_init
    print "HAS_UPDATE_SELECTION_INPUT="h_sel_input
    print "HAS_DRAW_MESSAGE="h_msg
    print "HAS_VALIDATE_SELECTION="h_validate
    print "HAS_GRID_MODE_INDEX="h_grid
    print "HAS_COLUMN_INDEX="h_col
    print "HAS_CLEAR_MARKERS="h_clear
    print "HAS_STATE_GLOBALS="h_state_globals
    print "HAS_RTS="h_rts
}
