BEGIN{e=0;b0=0;w2=0;w4=0;l6=0;r=0}
function t(s,x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
  l=t($0); if(l=="")next
  if(l~/^LOCAVAIL_FREENODERECORD:/ || l~/^LOCAVAIL_FREENODERECO[A-Z0-9_]*:/)e=1
  if(l~/^CLR\.B \(A[0-7]\)$/ || l~/^MOVE\.B #\$?0,\(A[0-7]\)$/)b0=1
  if(l~/^MOVE\.W D[0-7],\$?2\(A[0-7]\)$/ || l~/^CLR\.W \$?2\(A[0-7]\)$/ || l~/^LEA \$?2\(A[0-7]\),A[0-7]$/ || l~/^CLR\.W \(A[0-7]\)$/)w2=1
  if(l~/^MOVE\.W D[0-7],\$?4\(A[0-7]\)$/ || l~/^CLR\.W \$?4\(A[0-7]\)$/ || l~/^LEA \$?4\(A[0-7]\),A[0-7]$/ || l~/^CLR\.W \(A[0-7]\)$/)w4=1
  if(l~/^CLR\.L \$?6\(A[0-7]\)$/ || l~/^MOVE\.L #\$?0,\$?6\(A[0-7]\)$/ || l~/^LEA \$?6\(A[0-7]\),A[0-7]$/ || l~/^CLR\.L \(A[0-7]\)$/)l6=1
  if(l=="RTS")r=1
}
END{
  print "HAS_ENTRY="e
  print "HAS_CLR_BYTE0="b0
  print "HAS_CLR_WORD2="w2
  print "HAS_CLR_WORD4="w4
  print "HAS_CLR_LONG6="l6
  print "HAS_RTS="r
}
