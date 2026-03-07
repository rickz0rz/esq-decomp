BEGIN{e=0;count=0;range=0;a1=0;mulu=0;a2=0;ok=0;r=0}
function t(s,x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
  l=t($0); if(l=="")next
  if(l~/^LOCAVAIL_ALLOCNODEARRAYSFORSTATE:/ || l~/^LOCAVAIL_ALLOCNODEARRAYSFORSTAT[A-Z0-9_]*:/)e=1
  if(l~/^MOVE\.L 2\(A[0-7]\),D[0-7]$/ || l~/^LEA \$?2\(A[0-7]\),A[0-7]$/ || l~/^MOVE\.L \(A[0-7]\),D[0-7]$/)count=1
  if(l~/^BLE\.[SWB] \./ || l~/^MOVEQ(\.L)? #\$?64,D[0-7]$/ || l~/^CMP\.L D[0-7],D[0-7]$/ || l~/^BGE\.[SWB] \./)range=1
  if(l~/(JSR|BSR).*ALLOCATEME(MORY)?/ && a1==0){a1=1; next}
  if(l~/(JSR|BSR).*MULU32/)mulu=1
  if(l~/(JSR|BSR).*ALLOCATEME(MORY)?/ && a1==1)a2=1
  if(l~/^MOVEQ(\.L)? #\$?1,D[0-7]$/ || l~/^MOVE\.L D[0-7],D[0-7]$/)ok=1
  if(l=="RTS")r=1
}
END{
  print "HAS_ENTRY="e
  print "HAS_COUNT_LOAD="count
  print "HAS_RANGE_CHECK="range
  print "HAS_FIRST_ALLOC="a1
  print "HAS_MULU32_CALL="mulu
  print "HAS_SECOND_ALLOC="a2
  print "HAS_SUCCESS_FLAG="ok
  print "HAS_RTS="r
}
