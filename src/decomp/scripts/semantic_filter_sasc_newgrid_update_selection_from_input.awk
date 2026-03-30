BEGIN{
    h_entry=0
    h_state=0
    h_clear=0
    h_clamp=0
    h_row_limit=0
    h_group_present=0
    h_update_preset=0
    h_null_guard=0
    h_flag_bits=0
    h_prev=0
    h_bit=0
    h_row_used_guard=0
    h_should=0
    h_payload_check=0
    h_process=0
    h_final_row=0
    h_init=0
    h_mark=0
    h_rts=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
 l=t($0); if(l=="")next
 if(l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT:/ || l ~ /^NEWGRID_UPDATESELECTIONFROMINPUT[A-Z0-9_]*:/)h_entry=1
 if(l ~ /SELECTIONSCANENTRYINDEX/ || l ~ /SELECTIONSCANROW/ || l ~ /STATE0_INIT/ || l ~ /STATE4_ADVANCE/)h_state=1
 if(l ~ /(JSR|BSR).*CLEARENTRYMARKERBITS/ || l ~ /CLEARENTRYMARKERBITS/)h_clear=1
 if(l ~ /PRIMARYGROUPENTRYCOUNT/ && (l ~ /CMP/ || l ~ /MOVE\.(W|L)/ || l ~ /\$C\(A5\)/ || l ~ /\$10\(A5\)/))h_clamp=1
 if((l ~ /SELECTIONSCANROW/ || l ~ /ROWLIMIT/ || l ~ /24\(A3\)/ || l ~ /\$16\(A5\)/) && (l ~ /TST\./ || l ~ /CMP\./ || l ~ /BLS/ || l ~ /BLE/ || l ~ /BCC/ || l ~ /BGE/))h_row_limit=1
 if(l ~ /PRIMARYGROUPPRESENTFLAG/ || l ~ /GROUPPRESENT/)h_group_present=1
 if(l ~ /(JSR|BSR).*UPDATEPRESETENTRY/ || l ~ /UPDATEPRESETENTRY/)h_update_preset=1
 if((l ~ /TST\.L/ || l ~ /CMP\./) && (l ~ /\-4\(A5\)/ || l ~ /\-8\(A5\)/ || l ~ /\$1C\(A7\)/ || l ~ /\$20\(A7\)/ || l ~ /ENTRYPTR/ || l ~ /AUXPTR/))h_null_guard=1
 if((l ~ /BTST #4/ || l ~ /BTST #\$4/ || l ~ /BTST #7/ || l ~ /BTST #\$7/) && (l ~ /D[01]/ || l ~ /\$2F\(A0\)/ || l ~ /46\(A0\)/ || l ~ /\$29\(A0\)/ || l ~ /40\(A0\)/ || l ~ /FLAGS46/ || l ~ /FLAGS40/))h_flag_bits=1
 if(l ~ /(JSR|BSR).*FINDPREVIOUSVALIDENTRYINDEX/ || l ~ /FINDPREVIOUSVALIDENTR/ || l ~ /FINDPREV/)h_prev=1
 if(l ~ /(JSR|BSR).*TESTBIT1BASED/ || l ~ /TESTBIT1BASE/)h_bit=1
 if((l ~ /BTST #5/ || l ~ /BTST #\$5/) && (l ~ /7\(A[01]\)/ || l ~ /\$7\(A[01]\)/ || l ~ /ROWFLAGS/ || l ~ /USED_BIT/))h_row_used_guard=1
 if(l ~ /(JSR|BSR).*SHOULDOPENEDITOR/ || l ~ /SHOULDOPENEDITOR/)h_should=1
 if((l ~ /TST\.L/ || l ~ /CMP\./) && (l ~ /\$38\(A[01]\)/ || l ~ /56\(A[01]\)/ || l ~ /PAYLOADTABLE/ || l ~ /PAYLOAD/))h_payload_check=1
 if(l ~ /(JSR|BSR).*PROCESSENTRYSELECTIONSTATE/ || l ~ /PROCESSENTRYSELECTION/ || l ~ /COI_PROCESSENTRYSELE/ || l ~ /PROCESSENTRYS/ || l ~ /COI_PROCESSENTRY/ || l ~ /PROCESSENTRY/)h_process=1
 if((l ~ /CMPI\.W #'0',SELECTIONSCANROW/ || l ~ /CMP\.W .*SELECTIONSCANROW/ || l ~ /MOVEQ\.L #\$30/ || l ~ /MOVEQ #48/ || l ~ /MOVEQ\.L #\$31/ || l ~ /MOVEQ #49/ || l ~ /MOVE\.W D1,20\(A3\)/ || l ~ /MOVE\.W D1,\$14\(A5\)/ || l ~ /MOVE\.W D0,\$14\(A5\)/) && (l ~ /SELECTIONSCANROW/ || l ~ /\$14\(A5\)/ || l ~ /20\(A3\)/))h_final_row=1
 if(l ~ /(JSR|BSR).*INITSELECTIONWINDOW/ || l ~ /INITSELECTIONWINDOW/)h_init=1
 if(l ~ /BSET #5/ || l ~ /ORI\.B #\$20/ || l ~ /\|= 0X20/ || l ~ /OR\.B .*#\$20/ || l ~ /OR\.B \$7\(A0\),D0/)h_mark=1
 if(l=="RTS")h_rts=1
}
END{
 print "HAS_ENTRY="h_entry
 print "HAS_STATE_TRANSITIONS="h_state
 print "HAS_CLEAR_MARKERS="h_clear
 print "HAS_CLAMP_BOUNDS="h_clamp
 print "HAS_SCAN_ROW_LIMIT="h_row_limit
 print "HAS_GROUP_PRESENT_GUARD="h_group_present
 print "HAS_UPDATE_PRESET="h_update_preset
 print "HAS_ENTRY_AUX_NONNULL="h_null_guard
 print "HAS_FLAG_BITS="h_flag_bits
 print "HAS_PREV_VALID_LOOKUP="h_prev
 print "HAS_TEST_BIT="h_bit
 print "HAS_USED_ROWFLAG_GUARD="h_row_used_guard
 print "HAS_SHOULD_OPEN_EDITOR="h_should
 print "HAS_PAYLOAD_CHECK="h_payload_check
 print "HAS_SELECTION_PROCESS="h_process
 print "HAS_FINAL_ROW_STORE="h_final_row
 print "HAS_INIT_SELECTION="h_init
 print "HAS_MARK_USED_BIT="h_mark
 print "HAS_RTS="h_rts
}
