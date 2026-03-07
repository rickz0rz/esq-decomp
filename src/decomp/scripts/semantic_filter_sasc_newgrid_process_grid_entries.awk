BEGIN{h_entry=0;h_state=0;h_header=0;h_halfhour=0;h_wild=0;h_select_pen=0;h_frame=0;h_modeptr=0;h_state_code=0;h_test_state=0;h_prev=0;h_layout=0;h_draw_row=0;h_markers=0;h_draw_cell=0;h_visible=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l ~ /^NEWGRID_PROCESSGRIDENTRIES:/ || l ~ /^NEWGRID_PROCESSGRIDENTRIES[A-Z0-9_]*:/)h_entry=1
    if(l ~ /GRIDENTRIESWORKFLOWSTATE/)h_state=1
    if(l ~ /(JSR|BSR).*DRAWGRIDHEADERROWS/ || l ~ /DRAWGRIDHEADERROWS/)h_header=1
    if(l ~ /(JSR|BSR).*GETHALFHOURSLOTINDEX/ || l ~ /GETHALFHOURSLOTINDEX/ || l ~ /GETHALFHOURS/)h_halfhour=1
    if(l ~ /(JSR|BSR).*FINDFIRSTWILDCARDMATCHINDEX/ || l ~ /FIRSTWILDCARDMATCH/ || l ~ /FINDFIRSTW/)h_wild=1
    if(l ~ /(JSR|BSR).*SELECTENTRYPEN/ || l ~ /SELECTENTRYPEN/)h_select_pen=1
    if(l ~ /(JSR|BSR).*DRAWGRIDFRAME/ || l ~ /DRAWGRIDFRAME/)h_frame=1
    if(l ~ /(JSR|BSR).*GETENTRYPOINTERBYMODE/ || l ~ /GETENTRYAUXPOINTERBYMODE/ || l ~ /GETENTRYPOINTERBYMO/ || l ~ /ESQDISP_GETENTRY/)h_modeptr=1
    if(l ~ /(JSR|BSR).*GETENTRYSTATECODE/ || l ~ /GETENTRYSTATECODE/)h_state_code=1
    if(l ~ /(JSR|BSR).*TESTENTRYSTATE/ || l ~ /TESTENTRYSTATE/)h_test_state=1
    if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)h_prev=1
    if(l ~ /(JSR|BSR).*SETLAYOUTPARAMS/ || l ~ /(JSR|BSR).*COMPUTEMARKERWIDTHS/ || l ~ /SETLAYOUTPARAMS/ || l ~ /COMPUTEMARKERWIDTHS/ || l ~ /SETLAYO/ || l ~ /DISPTEXT_COMPUTE/)h_layout=1
    if(l ~ /(JSR|BSR).*DRAWENTRYROWORPLACEHOLDER/ || l ~ /DRAWENTRYROWORPLACEHOL/)h_draw_row=1
    if(l ~ /(JSR|BSR).*DRAWSELECTIONMARKERS/ || l ~ /DRAWSELECTIONMARKERS/)h_markers=1
    if(l ~ /(JSR|BSR).*DRAWGRIDCELL/ || l ~ /DRAWGRIDCELL/)h_draw_cell=1
    if(l ~ /(JSR|BSR).*COMPUTEVISIBLELINECOUNT/ || l ~ /COMPUTEVISIBLELINECOU/ || l ~ /CURRENTVISIBLELINES/ || l ~ /LSR\.W #1/ || l ~ /LSR\.W #\$1/)h_visible=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_STATE_MACHINE="h_state
    print "HAS_HEADER_DRAW="h_header
    print "HAS_HALFHOUR_GATE="h_halfhour
    print "HAS_WILDCARD_LOOKUP="h_wild
    print "HAS_SELECT_PEN="h_select_pen
    print "HAS_FRAME_DRAW="h_frame
    print "HAS_MODE_POINTER_FETCH="h_modeptr
    print "HAS_STATE_CODE="h_state_code
    print "HAS_TEST_STATE="h_test_state
    print "HAS_PREV_VALID_LOOKUP="h_prev
    print "HAS_LAYOUT_SETUP="h_layout
    print "HAS_ROW_DRAW="h_draw_row
    print "HAS_MARKER_DRAW="h_markers
    print "HAS_GRID_CELL_DRAW="h_draw_cell
    print "HAS_VISIBLE_COUNT="h_visible
    print "HAS_RTS="h_rts
}
