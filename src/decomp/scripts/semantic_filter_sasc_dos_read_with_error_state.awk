BEGIN {h_entry=0; h_sig=0; h_clear=0; h_read=0; h_cmp=0; h_ioerr=0; h_set5=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^DOS_READWITHERRORSTATE:/) h_entry=1
  if((l~/GLOBAL_SIGNALCALLBACKPTR\(A4\)/ && (l~/^TST\.L/ || l~/^CMP\.L/)) || l~/^(JSR|BSR(\.W)?) SIGNAL_POLLANDDISPATCH(\(PC\))?$/) h_sig=1
  if(l~/^CLR\.L GLOBAL_DOSIOERR\(A4\)$/ || (l~/GLOBAL_DOSIOERR\(A4\)/ && l~/^MOVE\.L D[0-7],/)) h_clear=1
  if(l~/^(JSR|BSR(\.W)?) _LVOREAD(\(A[0-7]\))?$/) h_read=1
  if(l~/^CMP\.L D[0-7],D[0-7]$/ || l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/ || l~/^ADDQ\.L #\$?1,D0$/) h_cmp=1
  if(l~/^(JSR|BSR(\.W)?) _LVOIOERR\(A6\)$/ || l~/^(JSR|BSR(\.W)?) _LVOIOERR\(A[0-7]\)$/ || l~/GLOBAL_DOSIOERR\(A4\)/) h_ioerr=1
  if((l~/GLOBAL_APPERRORCODE\(A4\)/ && l~/#\$?5/) || l~/^MOVEQ(\.L)? #\$?5,D0$/) h_set5=1
  if(l~/^MOVE\.L D[0-7],D0$/) h_ret=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SIGNAL_GATE=" h_sig
  print "HAS_CLEAR_DOSIOERR=" h_clear
  print "HAS_READ_CALL=" h_read
  print "HAS_ERROR_COMPARE=" h_cmp
  print "HAS_IOERR_CAPTURE=" h_ioerr
  print "HAS_SET_ERR5=" h_set5
  print "HAS_RETURN_RESULT=" h_ret
  print "HAS_RTS=" h_rts
}
