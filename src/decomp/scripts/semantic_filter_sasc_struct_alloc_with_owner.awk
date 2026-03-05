BEGIN {ownerg=0; alloc=0; nullret=0; w8=0; w9=0; wown=0; wsz=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MOVE\.L A[0-7],D0$/ || l~/^TST\.L A[0-7]$/ || l~/^(BEQ|BNE)(\.|\s)/) ownerg=1
  if(l~/^(JSR|BSR(\.W)?) _LVOALLOCMEM(\(A[0-7]\))?$/) alloc=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) nullret=1
  if(l~/^MOVE\.B #\$?5,(8|\$8)\(A[0-7]\)$/) w8=1
  if(l~/^CLR\.B (9|\$9)\(A[0-7]\)$/ || l~/^MOVE\.B #\$?0,(9|\$9)\(A[0-7]\)$/) w9=1
  if(l~/^MOVE\.L A[0-7],(14|\$E)\(A[0-7]\)$/) wown=1
  if(l~/^MOVE\.W D0,(18|\$12)\(A[0-7]\)$/) wsz=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_OWNER_GUARD=" ownerg
  print "HAS_ALLOCMEM_CALL=" alloc
  print "HAS_NULL_RETURN_PATH=" nullret
  print "HAS_TYPE5_WRITE=" w8
  print "HAS_PRI_CLEAR=" w9
  print "HAS_OWNER_WRITE=" wown
  print "HAS_SIZEWORD_WRITE=" wsz
  print "HAS_RTS=" rts
}
