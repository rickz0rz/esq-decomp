BEGIN {scan=0; alloc=0; link=0; clr=0; open=0; ret=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/GLOBAL_PREALLOCHANDLENODE0/ || l~/STRUCT_PREALLOCHANDLENODE__OPENFLAGS/ || l~/TST\.L \$18\(A0\)/) scan=1
  if(l~/ALLOC_ALLOCFROMFREELIST/) alloc=1
  if(l~/STRUCT_PREALLOCHANDLENODE__NEXT/ || l~/MOVE\.L A[0-7],\(A[0-7]\)/ || l~/MOVE\.L \$[0-9A-F]+\(A7\),\(A0\)/) link=1
  if(l~/DBF / || l~/MOVE\.B D[0-7],\(A[0-7]\)\+/ || l~/CLR\.B/) clr=1
  if(l~/HANDLE_OPENFROMMODESTRING/) open=1
  if(l~/MOVE\.L A[0-7],D0/ || l~/MOVEQ(\.L)? #\$?0,D0/ || l~/MOVE\.L \$10\(A7\),D0/) ret=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_SCAN_FREE_NODE=" scan
  print "HAS_ALLOC_CALL=" alloc
  print "HAS_LINK_NEW_NODE=" link
  print "HAS_CLEAR_34_BYTES=" clr
  print "HAS_OPEN_FROM_MODE_CALL=" open
  print "HAS_RETURN_PATH=" ret
  print "HAS_RTS=" rts
}
