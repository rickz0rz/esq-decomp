BEGIN {h_entry=0; h_base=0; h_args=0; h_call=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^EXEC_CALLVECTOR_48:/) h_entry=1
  if(l~/INPUTDEVICE_LIBRARYBASEFROMCONSOLEIO/ || l~/INPUTDEVICE_LIBRARYBASEFROMCONSO/) h_base=1
  if(l~/A0-A1/ || l~/D1\/A2/ || l~/MOVE\.L D[0-7],-\(A7\)$/ || l~/MOVE\.L A[0-7],-\(A7\)$/) h_args=1
  if(l~/^(JSR|BSR(\.W)?) _LVOEXECPRIVATE3(\(A[0-7]\))?$/) h_call=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_INPUTDEVICE_BASE=" h_base
  print "HAS_ARGS=" h_args
  print "HAS_CALL=" h_call
  print "HAS_RTS=" h_rts
}
