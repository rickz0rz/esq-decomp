BEGIN{h_entry=0;h_state=0;h_clear=0;h_clamp=0;h_update_preset=0;h_prev=0;h_bit=0;h_should=0;h_process=0;h_init=0;h_mark=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT[A-Z0-9_]*:/)h_entry=1
 if(l ~ /SELECTIONSCANENTRYINDEX/ || l ~ /SELECTIONSCANROW/ || l ~ /STATE0_INIT/ || l ~ /STATE4_ADVANCE/)h_state=1
 if(l ~ /(JSR|BSR).*CLEARENTRYMARKERBITS/ || l ~ /CLEARENTRYMARKERBITS/)h_clear=1
 if(l ~ /PRIMARYGROUPENTRYCOUNT/ && l ~ /CMP/)h_clamp=1
 if(l ~ /(JSR|BSR).*UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_update_preset=1
 if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)h_prev=1
 if(l ~ /(JSR|BSR).*TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit=1
 if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/ || l ~ /SHOULDOPENEDITOR/)h_should=1
 if(l ~ /(JSR|BSR).*PROCESSENTRYSELECTIONSTATE/ || l ~ /PROCESSENTRYSELECTION/ || l ~ /COI_PROCESSENTRYSELE/ || l ~ /PROCESSENTRYS/ || l ~ /COI_PROCESSENTRY/ || l ~ /PROCESSENTRY/)h_process=1
 if(l ~ /(JSR|BSR).*INITSELECTIONWINDOW/ || l ~ /INITSELECTIONWINDOW/)h_init=1
 if(l ~ /BSET #5/ || l ~ /ORI\.B #\$20/ || l ~ /\|= 0X20/ || l ~ /OR\.B .*#\$20/ || l ~ /OR\.B \$7\(A0\),D0/)h_mark=1
 if(l=="RTS")h_rts=1
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_STATE_TRANSITIONS="h_state
 print "HAS_CLEAR_MARKERS="h_clear
 print "HAS_CLAMP_BOUNDS="h_clamp
 print "HAS_UPDATE_PRESET="h_update_preset
 print "HAS_PREV_VALID_LOOKUP="h_prev
 print "HAS_TEST_BIT="h_bit
 print "HAS_SHOULD_OPEN_EDITOR="h_should
 print "HAS_SELECTION_PROCESS="h_process
 print "HAS_INIT_SELECTION="h_init
 print "HAS_MARK_USED_BIT="h_mark
 print "HAS_RTS="h_rts
}
