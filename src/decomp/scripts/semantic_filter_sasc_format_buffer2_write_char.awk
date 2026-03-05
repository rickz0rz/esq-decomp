BEGIN {inc=0; buf=0; store=0; upd=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/GLOBAL_FORMATBYTECOUNT2/ && (l~/ADDQ\.L #1/ || l~/ADDQ\.L #\$1/ || l~/ADD\.L/)) inc=1
  if(l~/GLOBAL_FORMATBUFFERPTR2/) buf=1
  if(l~/^MOVE\.B D[0-7],\(A[0-7]\)\+$/ || l~/^MOVE\.B D[0-7],\(A[0-7]\)$/) store=1
  if((l~/GLOBAL_FORMATBUFFERPTR2/ && l~/MOVE\.L A[0-7],/) || (l~/GLOBAL_FORMATBUFFERPTR2/ && l~/ADDQ\.L #\$?1,/)) upd=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_COUNT_INCREMENT=" inc
  print "HAS_BUFFERPTR_REF=" buf
  print "HAS_BYTE_STORE=" store
  print "HAS_BUFFERPTR_UPDATE=" upd
  print "HAS_RTS=" rts
}
