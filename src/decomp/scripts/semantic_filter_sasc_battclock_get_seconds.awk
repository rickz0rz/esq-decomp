BEGIN {h_entry=0; h_base=0; h_call=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^BATTCLOCK_GETSECONDSFROMBATTERYBACKEDCLOCK:/ || l~/^BATTCLOCK_GETSECONDSFROMBATTERYB:/) h_entry=1
  if(l~/GLOBAL_REF_BATTCLOCK_RESOURCE/) h_base=1
  if(l~/^(JSR|BSR(\.W)?) _LVOREADBATTCLOCK(\(A[0-7]\))?$/) h_call=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_BATTCLOCK_BASE=" h_base
  print "HAS_READ_CALL=" h_call
  print "HAS_RTS=" h_rts
}
