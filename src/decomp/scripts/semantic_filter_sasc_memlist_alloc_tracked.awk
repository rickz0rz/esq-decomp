BEGIN {sizeb=0; alloc=0; nullret=0; wsize=0; link=0; first=0; retptr=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/#12/ || l~/\$C/ || l~/ADD\.L D0,D[67]/) sizeb=1
  if(l~/^(JSR|BSR(\.W)?) _LVOALLOCMEM(\(A[0-7]\))?$/) alloc=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/ || l~/^CLR\.L D0$/) nullret=1
  if(l~/8\(A[0-7]\)/ || l~/\$8\(A[0-7]\)/) wsize=1
  if(l~/GLOBAL_MEMLISTHEAD/ || l~/GLOBAL_MEMLISTTAIL/) link=1
  if(l~/GLOBAL_MEMLISTFIRSTALLOCNODE/) first=1
  if(l~/LEA (12|\$C)\(A[0-7]\),A0/ || l~/MOVE\.L A0,D0/) retptr=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_SIZE_BUMP_12=" sizeb
  print "HAS_ALLOCMEM_CALL=" alloc
  print "HAS_NULL_RETURN_PATH=" nullret
  print "HAS_NODE_SIZE_WRITE=" wsize
  print "HAS_LIST_LINK_WRITES=" link
  print "HAS_FIRST_NODE_WRITE=" first
  print "HAS_RETURN_DATA_PTR=" retptr
  print "HAS_RTS=" rts
}
