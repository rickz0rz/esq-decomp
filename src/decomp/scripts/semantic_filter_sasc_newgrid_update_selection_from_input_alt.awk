BEGIN{h_entry=0;h_state=0;h_clear=0;h_update_preset=0;h_selectable=0;h_prev=0;h_bit=0;h_process=0;h_elig=0;h_mark=0;h_null=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^NEWGRID_UPDATESELECTIONFROMINPUTALT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUTALT[A-Z0-9_]*:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT[A-Z0-9_]*:/)h_entry=1
 if(l ~ /ALTSELECTIONROWCURSOR/ || l ~ /ALTSELECTIONENTRYCURSOR/ || l ~ /STATE_JUMPTABLE/)h_state=1
 if(l ~ /(JSR|BSR).*CLEARMARKERSIFSELECTABLE/ || l ~ /CLEARMARKERSIFSELECTABL/)h_clear=1
 if(l ~ /(JSR|BSR).*UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_update_preset=1
 if(l ~ /(JSR|BSR).*TESTENTRYSELECTABLE/ || l ~ /TESTENTRYSELECTABLE/)h_selectable=1
 if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)h_prev=1
 if(l ~ /(JSR|BSR).*TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit=1
 if(l ~ /(JSR|BSR).*PROCESSENTRYSELECTIONSTATE/ || l ~ /PROCESSENTRYSELECTION/ || l ~ /COI_PROCESSENTRYSELE/ || l ~ /COI_PROCESSENTRY/ || l ~ /PROCESSENTRY/)h_process=1
 if(l ~ /(JSR|BSR).*TESTENTRYGRIDELIGIBILITY/ || l ~ /TESTENTRYGRIDELIGIB/ || l ~ /TESTENTRYGRIDELIG/ || l ~ /TESTENTRYGRID/ || l ~ /ESQDISP_TESTENTR/ || l ~ /TESTENTR/)h_elig=1
 if(l ~ /BSET #5/ || l ~ /ORI\.B #\$20/ || l ~ /\|= 0X20/ || l ~ /OR\.B \$7\(A0\),D0/ || l ~ /OR\.B .*#\$20/)h_mark=1
 if(l ~ /SUB\.L A0,A0/ || l ~ /MOVE\.L A0,\(A3\)/ || l ~ /CLR\.L \(A3\)/ || l ~ /CLR\.L/)h_null=1
 if(l=="RTS")h_rts=1
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_STATE_MACHINE="h_state
 print "HAS_CLEAR_MARKERS="h_clear
 print "HAS_UPDATE_PRESET="h_update_preset
 print "HAS_TEST_SELECTABLE="h_selectable
 print "HAS_PREV_VALID_LOOKUP="h_prev
 print "HAS_TEST_BIT="h_bit
 print "HAS_SELECTION_PROCESS="h_process
 print "HAS_GRID_ELIGIBILITY="h_elig
 print "HAS_MARK_USED_BIT="h_mark
 print "HAS_NULL_RESET="h_null
 print "HAS_RTS="h_rts
}
