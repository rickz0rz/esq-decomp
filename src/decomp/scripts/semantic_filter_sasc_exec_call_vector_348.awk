BEGIN {entry=0; args=0; call=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^EXEC_CALLVECTOR_348:/) entry=1
  if(l~/MOVEA?\.L [0-9A-F\$]+\(A7\),A[0-3]/ || l~/MOVE\.L [0-9A-F\$]+\(A7\),D[0-3]/ || l~/MOVE\.L A[0-3],-\(A7\)/ || l~/MOVE\.L D[0-3],-\(A7\)/) args=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREETRAP(\(A[0-7]\))?$/) call=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_ARG_SETUP=" args
  print "HAS_CALL=" call
  print "HAS_RTS=" rts
}
