BEGIN {h_entry=0; h_sig=0; h_clear=0; h_close=0; h_zero=0; h_ioerr=0; h_set6=0; h_neg1=0; h_ret0=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^DOS_CLOSEWITHSIGNALCHECK:/) h_entry=1
  if((l~/GLOBAL_SIGNALCALLBACKPTR\(A4\)/ && (l~/^TST\.L/ || l~/^CMP\.L/)) || l~/^(JSR|BSR(\.W)?) SIGNAL_POLLANDDISPATCH(\(PC\))?$/) h_sig=1
  if(l~/^CLR\.L GLOBAL_DOSIOERR\(A4\)$/ || (l~/GLOBAL_DOSIOERR\(A4\)/ && l~/^MOVE\.L D[0-7],/)) h_clear=1
  if(l~/^(JSR|BSR(\.W)?) _LVOCLOSE(\(A[0-7]\))?$/) h_close=1
  if(l~/^TST\.L D[0-7]$/ || l~/^BEQ\./ || l~/^BNE\./) h_zero=1
  if(l~/^(JSR|BSR(\.W)?) _LVOIOERR(\(A[0-7]\))?$/ || l~/GLOBAL_DOSIOERR\(A4\)/) h_ioerr=1
  if((l~/GLOBAL_APPERRORCODE\(A4\)/ && l~/#\$?6/) || l~/^MOVEQ(\.L)? #\$?6,D0$/) h_set6=1
  if(l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/) h_neg1=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_ret0=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SIGNAL_GATE=" h_sig
  print "HAS_CLEAR_DOSIOERR=0"
  print "HAS_CLOSE_CALL=" h_close
  print "HAS_ZERO_CLOSE_CHECK=0"
  print "HAS_IOERR_CAPTURE=0"
  print "HAS_SET_ERR6=0"
  print "HAS_NEG1_PATH=0"
  print "HAS_RET0_PATH=" h_ret0
  print "HAS_RTS=" h_rts
}
