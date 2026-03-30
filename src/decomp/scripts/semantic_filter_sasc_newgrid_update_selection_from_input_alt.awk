BEGIN{
 h_entry=0;h_state=0;h_switch=0;h_clear=0;h_update_preset=0;h_selectable=0;h_row_limit=0
 h_rebuild_49=0;h_prev=0;h_bit=0;h_payload=0;h_process=0;h_timewindow=0;h_mode1_elig=0
 h_elig=0;h_store_ctx=0;h_selected_row=0;h_mark=0;h_null=0;h_rts=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^NEWGRID_UPDATESELECTIONFROMINPUTALT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUTALT[A-Z0-9_]*:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT[A-Z0-9_]*:/)h_entry=1
 if(l ~ /ALTSELECTIONROWCURSOR/ || l ~ /ALTSELECTIONENTRYCURSOR/ || l ~ /STATE_JUMPTABLE/)h_state=1
 if(l ~ /STATE_JUMPTABLE/ || l ~ /__SWITCH_NEWGRID_UPDATESELECTIONFROMINPUT/ || l ~ /DC\.W .*UPDATESELECTIONFROMINPUT__/ || l ~ /JMP .*PC,D0\.W/)h_switch=1
 if(l ~ /(JSR|BSR).*CLEARMARKERSIFSELECTABLE/ || l ~ /CLEARMARKERSIFSELECTABL/)h_clear=1
 if(l ~ /(JSR|BSR).*UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_update_preset=1
 if(l ~ /(JSR|BSR).*TESTENTRYSELECTABLE/ || l ~ /TESTENTRYSELECTABLE/)h_selectable=1
 if(l ~ /CMP\.W 24\(A3\),D0/ || l ~ /MOVE\.W \$18\(A5\),D1/ || l ~ /ROWLIMIT/ || l ~ /BGE\..*UPDATESELECTIONFROMINPUT__40/)h_row_limit=1
 if(l ~ /MOVEQ #49,D1/ || l ~ /MOVEQ\.L #\$31,D1/ || l ~ /CMP\.W D1,D0/ || l ~ /CMP\.L D1,D0/ || l ~ /UPDATEPRESETENTRY.*UPDATEPRESETENTRY/)h_rebuild_49=1
 if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)h_prev=1
 if(l ~ /(JSR|BSR).*TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit=1
 if(l ~ /TST\.L 56\(A0\)/ || l ~ /TST\.L \$38\(A1\)/ || l ~ /PAYLOADTABLE/ || l ~ /BEQ\..*UPDATESELECTIONFROMINPUT__40/)h_payload=1
 if(l ~ /(JSR|BSR).*PROCESSENTRYSELECTIONSTATE/ || l ~ /PROCESSENTRYSELECTION/ || l ~ /COI_PROCESSENTRYSELE/ || l ~ /COI_PROCESSENTRY/ || l ~ /PROCESSENTRY/)h_process=1
 if(l ~ /CONFIG_TIMEWINDOWMINUTES/ || l ~ /PEA 1440\.W/ || l ~ /PEA \(\$5A0\)\.W/ || l ~ /WINDOW/)h_timewindow=1
 if(l ~ /MOVEQ #1,D0/ || l ~ /SUBQ\.L #\$1,D0/ || l ~ /CMP\.L D0,D6/ || l ~ /ESQDISP_TESTENTRYGRIDELIGIBILITY/)h_mode1_elig=1
 if(l ~ /(JSR|BSR).*TESTENTRYGRIDELIGIBILITY/ || l ~ /TESTENTRYGRIDELIGIB/ || l ~ /TESTENTRYGRIDELIG/ || l ~ /TESTENTRYGRID/ || l ~ /ESQDISP_TESTENTR/ || l ~ /TESTENTR/)h_elig=1
 if(l ~ /MOVE\.L -4\(A5\),\(A3\)/ || l ~ /MOVE\.L -8\(A5\),4\(A3\)/ || l ~ /MOVE\.L NEWGRID_ALTSELECTIONROWCURSOR,8\(A3\)/ || l ~ /MOVE\.L \$1C\(A7\),\(A5\)/ || l ~ /MOVE\.L \$18\(A7\),\$4\(A5\)/ || l ~ /MOVE\.L NEWGRID_ALTSELECTIONROWCURSOR\(A4\),\$8\(A5\)/)h_store_ctx=1
 if(l ~ /CMPI\.W #'0',NEWGRID_ALTSELECTIONENTRYCURSOR/ || l ~ /MOVEQ #48,D0/ || l ~ /MOVEQ\.L #\$30,D1/ || l ~ /ADD\.L D0,D1/ || l ~ /MOVE\.W D1,20\(A3\)/ || l ~ /MOVE\.W D1,\$14\(A5\)/ || l ~ /SELECTEDROW/)h_selected_row=1
 if(l ~ /BSET #5/ || l ~ /ORI\.B #\$20/ || l ~ /\|= 0X20/ || l ~ /OR\.B \$7\(A0\),D0/ || l ~ /OR\.B .*#\$20/)h_mark=1
 if(l ~ /SUB\.L A0,A0/ || l ~ /MOVE\.L A0,\(A3\)/ || l ~ /CLR\.L \(A3\)/ || l ~ /CLR\.L/)h_null=1
 if(l=="RTS")h_rts=1
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_STATE_MACHINE="h_state
 print "HAS_SWITCH_TABLE="h_switch
 print "HAS_CLEAR_MARKERS="h_clear
 print "HAS_UPDATE_PRESET="h_update_preset
 print "HAS_TEST_SELECTABLE="h_selectable
 print "HAS_ROW_LIMIT_GUARD="h_row_limit
 print "HAS_REBUILD_INDEX_49="h_rebuild_49
 print "HAS_PREV_VALID_LOOKUP="h_prev
 print "HAS_TEST_BIT="h_bit
 print "HAS_PAYLOAD_CHECK="h_payload
 print "HAS_SELECTION_PROCESS="h_process
 print "HAS_TIMEWINDOW_CALL="h_timewindow
 print "HAS_MODE1_ELIGIBILITY_GATE="h_mode1_elig
 print "HAS_GRID_ELIGIBILITY="h_elig
 print "HAS_CONTEXT_STORE="h_store_ctx
 print "HAS_SELECTED_ROW_OFFSET="h_selected_row
 print "HAS_MARK_USED_BIT="h_mark
 print "HAS_NULL_RESET="h_null
 print "HAS_RTS="h_rts
}
