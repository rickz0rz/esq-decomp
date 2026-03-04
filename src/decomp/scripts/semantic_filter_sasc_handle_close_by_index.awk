BEGIN {h_entry=0; h_lookup=0; h_null=0; h_flag=0; h_err19=0; h_close=0; h_clear=0; h_ret0=0; h_retneg=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^HANDLE_CLOSEBYINDEX:/) h_entry=1
  if(l~/^(JSR|BSR(\.W)?) HANDLE_GETENTRYBYINDEX(\(PC\))?$/) h_lookup=1
  if(l~/^TST\.L D0$/ || l~/^BEQ\./ || l~/^BNE\./) h_null=1
  if(l~/^BTST #\$?[24],\$?3\(A[0-7]\)$/ || l~/^ANDI\.[BW] #\$?(4|10),D[0-7]$/) h_flag=1
  if(l~/GLOBAL_APPERRORCODE\(A4\)/ && l~/#\$?13/) h_err19=1
  if(l~/^(JSR|BSR(\.W)?) DOS_CLOSEWITHSIGNALCHECK(\(PC\))?$/) h_close=1
  if(l~/^CLR\.L \(A[0-7]\)$/ || l~/^MOVE\.L D[0-7],\(A[0-7]\)$/) h_clear=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_ret0=1
  if(l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/) h_retneg=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_LOOKUP_CALL=" h_lookup
  print "HAS_NULL_GUARD=" h_null
  print "HAS_FLAG_CHECK=" h_flag
  print "HAS_SET_ERR19=" h_err19
  print "HAS_CLOSE_CALL=" h_close
  print "HAS_CLEAR_FLAGS=" h_clear
  print "HAS_RET0=" h_ret0
  print "HAS_RETNEG1=" h_retneg
  print "HAS_RTS=" h_rts
}
