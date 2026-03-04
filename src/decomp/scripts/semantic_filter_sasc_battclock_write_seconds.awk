BEGIN {h_entry=0; h_base=0; h_arg=0; h_call=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^BATTCLOCK_WRITESECONDSFROMBATTERYBACKEDCLOCK:/ || l~/^BATTCLOCK_WRITESECONDSTOBATTERYBACKEDCLOCK:/ || l~/^BATTCLOCK_WRITESECONDSTOBATTERYB:/) h_entry=1
  if(l~/GLOBAL_REF_BATTCLOCK_RESOURCE/) h_base=1
  if(l~/^MOVE\.L .*D0$/ || l~/^MOVE\.L D[0-7],-\(A7\)$/) h_arg=1
  if(l~/^(JSR|BSR(\.W)?) _LVOWRITEBATTCLOCK(\(A[0-7]\))?$/) h_call=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_BATTCLOCK_BASE=" h_base
  print "HAS_ARG_D0=" h_arg
  print "HAS_WRITE_CALL=" h_call
  print "HAS_RTS=" h_rts
}
