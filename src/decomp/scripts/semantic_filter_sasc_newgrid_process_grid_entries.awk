BEGIN{
    h_entry=0;h_state=0;h_header=0;h_halfhour=0;h_wild=0;h_select_pen=0;h_frame=0;h_modeptr=0
    h_state_code=0;h_test_state=0;h_prev=0;h_layout=0;h_draw_row=0;h_markers=0;h_draw_cell=0
    h_visible=0;h_placeholder=0;h_state45=0;h_const3=0;h_pair=0;h_bit7=0;h_first=0;h_rts=0
    h_marker_gate=0;h_restore_selected=0;h_halfheight_store=0;h_halfheight_clear=0;h_visible_mode2=0
    h_marker_flag=0;h_keepmarkers_clear=0;h_second_pair_probe=0;h_entry_guard=0;h_aux_guard=0
    h_gridcell_style0=0;h_gridcell_style1=0;h_null_ctx_state4=0;h_state5_visible_reset=0
    h_force_state4=0;h_second_key_wrap=0;h_state3_remap=0;h_missing_entry_span=0
    prev="";pending_visible_mode2=0;pending_second_pair_probe=0;pending_pair_store=0;pair_const=0
    pending_gridcell_style0=0;pending_gridcell_style1=0;pending_state3_remap=0
    pending_null_ctx_state4=0;pending_state5_visible_reset=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(pending_gridcell_style0 > 0 && l ~ /(JSR|BSR).*DRAWGRIDCELL/){
        h_gridcell_style0=1
        pending_gridcell_style0=0
    } else if(pending_gridcell_style0 > 0){
        pending_gridcell_style0--
    }
    if(pending_gridcell_style1 > 0 && l ~ /(JSR|BSR).*DRAWGRIDCELL/){
        h_gridcell_style1=1
        pending_gridcell_style1=0
    } else if(pending_gridcell_style1 > 0){
        pending_gridcell_style1--
    }
    if(pending_state3_remap > 0 &&
       (l ~ /MOVEQ(\.L)? #(\$)?1,D[0-7]/ ||
        l ~ /MOVEQ(\.L)? #(\$)?2,D[0-7]/ ||
        l ~ /SCC D[0-7],#\$600/ ||
        l ~ /SUB\.B D[0-7],D[0-7]/ ||
        l ~ /MOVE\.L D[0-7],(-30\(A5\)|\$48\(A7\)|-20\(A5\)|\$30\(A7\))/)){
        h_state3_remap=1
    }
    if(pending_state3_remap > 0){
        pending_state3_remap--
    }
    if(pending_null_ctx_state4 > 0 && l ~ /MOVE\.L D[0-7],NEWGRID_GRIDENTRIESWORKFLOWSTATE/){
        h_null_ctx_state4=1
        pending_null_ctx_state4=0
    } else if(pending_null_ctx_state4 > 0){
        pending_null_ctx_state4--
    }
    if(pending_state5_visible_reset > 0 && l ~ /MOVE\.L D[0-7],(32\(A3\)|\$20\(A3\))/){
        h_state5_visible_reset=1
        pending_state5_visible_reset=0
    } else if(pending_state5_visible_reset > 0){
        pending_state5_visible_reset--
    }
    if(pending_visible_mode2 > 0 && l ~ /MOVE\.L D0,(32\(A3\)|\$20\(A3\))/){
        h_visible_mode2=1
        pending_visible_mode2=0
    } else if(pending_visible_mode2 > 0){
        pending_visible_mode2--
    }
    if(pending_second_pair_probe > 0 && l ~ /(JSR|BSR).*TESTENTRYSTATE/){
        h_second_pair_probe=1
        pending_second_pair_probe=0
        pending_pair_store=12
    } else if(pending_second_pair_probe > 0){
        pending_second_pair_probe--
    }
    if(pending_pair_store > 0 && l ~ /MOVEQ(\.L)? #(\$)?2,D[0-7]/){
        pair_const=2
    } else if(pending_pair_store > 0 && l ~ /MOVEQ(\.L)? #(\$)?1,D[0-7]/){
        pair_const=1
    }
    if(pending_pair_store > 0 && pair_const > 0 &&
       (l ~ /MOVE\.L D[0-7],(-38\(A5\)|\$40\(A7\))/ ||
        l ~ /RIGHTSTATE = [12]/)){
        h_pair=1
        pending_pair_store=0
        pair_const=0
    } else if(pending_pair_store > 0){
        pending_pair_store--
        if(pending_pair_store == 0){
            pair_const=0
        }
    }
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
    if(l ~ /CONFIG_NEWGRIDPLACEHOLDERBEVELFLAG/ || l ~ /#\$59/ || l ~ /PLACEHOLDERBEVEL/)h_placeholder=1
    if(l ~ /GRIDENTRIESWORKFLOWSTATE/ && (l ~ /#4([^0-9]|$)/ || l ~ /#5([^0-9]|$)/ || l ~ /MOVE\.L D[0-7],NEWGRID_GRIDENTRIESWORKFLOWSTATE/))h_state45=1
    if(l ~ /#3([^0-9]|$)/ || l ~ /CMP\.L D[0-7],D[0-7]/ || l ~ /ROWSPAN == 3/)h_const3=1
    if(l ~ /BTST #7/ || l ~ /BTST #\$7/ || l ~ /#\$80/ || l ~ /ROWFLAGS\[1\]/)h_bit7=1
    if(l ~ /FIRSTENTRY/ || l ~ /MOVE\.L A0,-8\(A5\)/ || l ~ /MOVE\.L -8\(A5\),-\(A7\)/ || l ~ /MOVE\.L A2,-\(A7\)/)h_first=1
    if(l ~ /TST\.L (-46\(A5\)|\$54\(A7\))/)h_marker_gate=1
    if(l ~ /BTST #2/ || l ~ /BTST #\$2/ || l ~ /ROWFLAGS\[PREVROWIDX\] & 0X04/)h_marker_flag=1
    if(l ~ /CLR\.L (-46\(A5\)|\$54\(A7\))/ || l ~ /KEEPMARKERS = 0/)h_keepmarkers_clear=1
    if(l ~ /TST\.L (-4\(A5\)|\$50\(A7\))/ ||
       l ~ /MOVE\.L \$50\(A7\),D0/ ||
       l ~ /IF \(ENTRY && AUX\)/)h_entry_guard=1
    if(l ~ /TST\.L (-12\(A5\)|\$4C\(A7\))/ || l ~ /IF \(ENTRY && AUX\)/)h_aux_guard=1
    if(l ~ /NEWGRID_SELECTEDGRIDENTRYPTR/ && l ~ /NEWGRID_SELECTIONMARKERPENSTATE/)h_restore_selected=1
    if(l ~ /LSR\.W #1/ || l ~ /LSR\.W #\$1/ || l ~ /MOVE\.W D0,(52\(A3\)|\$34\(A3\))/)h_halfheight_store=1
    if(l ~ /CLR\.W (52\(A3\)|\$34\(A3\))/)h_halfheight_clear=1
    if(prev ~ /MOVE\.L A[35],D0/ && l ~ /BNE\./)pending_null_ctx_state4=3
    if(l ~ /MOVEQ(\.L)? #(-1|\$FF),D[0-7]/)pending_state5_visible_reset=2
    if(l ~ /SUBQ\.L #(\$)?1,D[0-7]/)h_force_state4=1
    if((l ~ /CMP\.L NEWGRID_GRIDENTRIESWORKFLOWSTATE,D[0-7]/ ||
        l ~ /CMP\.L NEWGRID_GRIDENTRIESWORKFLOWSTATE\(A4\),D[0-7]/) &&
       prev ~ /MOVEQ(\.L)? #(\$)?4,D[0-7]/)h_force_state4=1
    if(l ~ /SUB\.L D[0-7],(-24\(A5\)|\$38\(A7\))/ ||
       l ~ /ADDI?\.W #\$30,D[0-7]/ ||
       l ~ /MOVEQ(\.L)? #\$30,D[0-7]/)h_second_key_wrap=1
    if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)pending_state3_remap=12
    if(l ~ /SUB\.W (-18\(A5\)|\$26\(A7\)),D[0-7]/ || l ~ /MOVEM\.W D[0-7],(-22\(A5\)|\$3C\(A7\))/)h_missing_entry_span=1
    if(prev ~ /PEA (\(\$2\)|2)\.W/ && l ~ /(JSR|BSR).*DISPTEXT_COMPUTE/){
        pending_visible_mode2=3
    }
    if(l ~ /ADDQ\.(W|L) #(\$)?1,D[0-7]/){
        pending_second_pair_probe=16
    }
    if(l ~ /CLR\.L -\(A7\)/){
        pending_gridcell_style0=3
    }
    if(l ~ /PEA (\(\$1\)|1)\.W/){
        pending_gridcell_style1=3
    }
    if(l=="RTS")h_rts=1
    prev=l
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
    print "HAS_PLACEHOLDER_FLAG="h_placeholder
    print "HAS_STATE_4_5="h_state45
    print "HAS_CONST_3="h_const3
    print "HAS_TRAILING_PAIR_LOGIC="h_pair
    print "HAS_BIT7_EDGE_CASE="h_bit7
    print "HAS_FIRST_ENTRY_CAPTURE="h_first
    print "HAS_MARKER_GATE="h_marker_gate
    print "HAS_MARKER_FLAG_BIT2="h_marker_flag
    print "HAS_KEEPMARKERS_CLEAR="h_keepmarkers_clear
    print "HAS_SECOND_PAIR_PROBE="h_second_pair_probe
    print "HAS_ENTRY_GUARD="h_entry_guard
    print "HAS_AUX_GUARD="h_aux_guard
    print "HAS_GRIDCELL_STYLE0="h_gridcell_style0
    print "HAS_GRIDCELL_STYLE1="h_gridcell_style1
    print "HAS_NULL_CTX_STATE4="h_null_ctx_state4
    print "HAS_STATE5_VISIBLE_RESET="h_state5_visible_reset
    print "HAS_FORCE_STATE4_PATH="h_force_state4
    print "HAS_SECOND_KEY_WRAP="h_second_key_wrap
    print "HAS_STATE3_REMAP="h_state3_remap
    print "HAS_MISSING_ENTRY_SPAN="h_missing_entry_span
    print "HAS_RESTORE_SELECTED_PEN="h_restore_selected
    print "HAS_HALFHEIGHT_STORE="h_halfheight_store
    print "HAS_HALFHEIGHT_CLEAR="h_halfheight_clear
    print "HAS_VISIBLE_RECOUNT_MODE2="h_visible_mode2
    print "HAS_RTS="h_rts
}
