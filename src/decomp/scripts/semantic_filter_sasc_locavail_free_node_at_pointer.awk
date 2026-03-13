BEGIN{e=0;n=0;buf=0;size=0;de=0;fr=0;r=0}
function t(s,x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
  l=t($0); if(l=="")next
  if(l~/^LOCAVAIL_FREENODEATPOINTER:/ || l~/^LOCAVAIL_FREENODEATPOIN[A-Z0-9_]*:/)e=1
  if(l~/^MOVE\.L A[0-7],D[0-7]$/ || l~/^TST\.L A[0-7]$/ || l~/^BEQ\.[SWB] \./)n=1
  if(l~/^TST\.L \$?6\(A[0-7]\)$/ || l~/^LEA \$?6\(A[0-7]\),A[0-7]$/ || l~/^MOVE\.L \$?6\(A[0-7]\),A[0-7]$/ || l~/^MOVE\.L \(A[0-7]\),A[0-7]$/)buf=1
  if(l~/^MOVE\.W \$?4\(A[0-7]\),D[0-7]$/ || l~/^TST\.W D[0-7]$/ || l~/^BLE\.[SWB] \./)size=1
  if(l~/(JSR|BSR).*DEALLOCATE(MEMORY)?/)de=1
  if(l~/(JSR|BSR).*LOCAVAIL_FREENODERECORD/)fr=1
  if(l=="RTS")r=1
}
END{
  print "HAS_ENTRY="e
  print "HAS_NULL_GUARD="n
  print "HAS_BUF_CHECK="buf
  print "HAS_SIZE_CHECK="size
  print "HAS_DEALLOC_CALL="de
  print "HAS_FREE_NODE_RECORD_CALL="fr
  print "HAS_RTS="r
}
