BEGIN {zero=0; setbuf=0; call=0; term=0; loadcnt=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/CLR\.L GLOBAL_FORMATBYTECOUNT2/ || l~/MOVE\.L #\$?0,GLOBAL_FORMATBYTECOUNT2/) zero=1
  if(l~/MOVE\.L A[0-7],GLOBAL_FORMATBUFFERPTR2/) setbuf=1
  if(l~/WDISP_FORMATWITHCALLBACK/ || l~/FORMAT_BUFFER2WRITECHAR/) call=1
  if(l~/CLR\.B \(A[0-7]\)/) term=1
  if(l~/MOVE\.L GLOBAL_FORMATBYTECOUNT2,D0/) loadcnt=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_COUNT_ZERO=" zero
  print "HAS_BUFFERPTR_SET=" setbuf
  print "HAS_FORMAT_CALL=" call
  print "HAS_NUL_TERM=" term
  print "HAS_COUNT_RETURN=" loadcnt
  print "HAS_RTS=" rts
}
