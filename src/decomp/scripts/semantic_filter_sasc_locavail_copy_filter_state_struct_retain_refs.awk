BEGIN{e=0;c0=0;c2=0;c6=0;c16=0;c20=0;inc=0;r=0}
function t(s,x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
  l=t($0); if(l=="")next
  if(l~/^LOCAVAIL_COPYFILTERSTATESTRUCTRETAINREFS:/ || l~/^LOCAVAIL_COPYFILTERSTATESTRUCTRE[A-Z0-9_]*:/)e=1
  if(l~/MOVE\.B \(A[0-7]\),\(A[0-7]\)/)c0=1
  if(l~/MOVE\.L 2\(A[0-7]\),2\(A[0-7]\)/ || l~/LEA \$?2\(A[0-7]\),A[0-7]/ || l~/MOVE\.L \(A[0-7]\),\(A[0-7]\)/)c2=1
  if(l~/MOVE\.B \$?6\(A[0-7]\),\$?6\(A[0-7]\)/)c6=1
  if(l~/MOVEA?\.L 16\(A[0-7]\),A[0-7]/ || l~/MOVE\.L A[0-7],16\(A[0-7]\)/ || l~/LEA \$?10\(A[0-7]\),A[0-7]/ || l~/MOVE\.L A[0-7],\(A[0-7]\)/)c16=1
  if(l~/MOVE\.L 20\(A[0-7]\),20\(A[0-7]\)/ || l~/LEA \$?14\(A[0-7]\),A[0-7]/ || l~/MOVE\.L \(A[0-7]\),\(A[0-7]\)/)c20=1
  if(l~/^ADDQ\.L #\$?1,\(A[0-7]\)$/ || l~/^ADDQ\.L #1,\(A[0-7]\)$/)inc=1
  if(l=="RTS")r=1
}
END{
  print "HAS_ENTRY="e
  print "HAS_COPY_BYTE0="c0
  print "HAS_COPY_LONG2="c2
  print "HAS_COPY_BYTE6="c6
  print "HAS_COPY_PTR16="c16
  print "HAS_COPY_PTR20="c20
  print "HAS_REFCOUNT_INC="inc
  print "HAS_RTS="r
}
