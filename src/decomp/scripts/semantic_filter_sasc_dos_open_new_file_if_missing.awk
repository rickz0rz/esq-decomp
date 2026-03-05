BEGIN {sig=0; lock=0; unlock=0; open=0; ioerr=0; doserrw=0; apperrw=0; neg1=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/SIGNAL_POLLANDDISPATCH/) sig=1
  if(l~/^(JSR|BSR(\.W)?) _LVOLOCK(\(A[0-7]\))?$/) lock=1
  if(l~/^(JSR|BSR(\.W)?) _LVOUNLOCK(\(A[0-7]\))?$/) unlock=1
  if(l~/^(JSR|BSR(\.W)?) _LVOOPEN(\(A[0-7]\))?$/) open=1
  if(l~/^(JSR|BSR(\.W)?) _LVOIOERR(\(A[0-7]\))?$/) ioerr=1
  if(l~/GLOBAL_DOSIOERR/) doserrw=1
  if(l~/GLOBAL_APPERRORCODE/) apperrw=1
  if(l~/^MOVEQ(\.L)? #-1,D0$/ || l~/^MOVEQ(\.L)? #\$?FF,D0$/ || l~/^MOVE\.L #-1,D0$/) neg1=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_SIGNAL_CALLBACK_PATH=" sig
  print "HAS_LOCK_CALL=" lock
  print "HAS_UNLOCK_CALL=" unlock
  print "HAS_OPEN_CALL=" open
  print "HAS_IOERR_CALL=" ioerr
  print "HAS_DOSERR_WRITE=" doserrw
  print "HAS_APPERR_WRITE=" apperrw
  print "HAS_NEG1_RETURN=" neg1
  print "HAS_RTS=" rts
}
