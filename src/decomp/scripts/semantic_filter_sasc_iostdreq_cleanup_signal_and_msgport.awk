BEGIN {ptest=0; rem=0; f8=0; f20=0; sig=0; fsig=0; sz=0; fmem=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^TST\.L [0-9A-F\$]+\(A[0-7]\)$/ || l~/^CMP\.L #0,[0-9A-F\$]+\(A[0-7]\)$/) ptest=1
  if(l~/^(JSR|BSR(\.W)?) _LVOREMPORT(\(A[0-7]\))?$/) rem=1
  if(l~/^MOVE\.B #\$?FF,[0-9A-F\$]+\(A[0-7]\)$/ || l~/^MOVE\.B #-1,[0-9A-F\$]+\(A[0-7]\)$/ || l~/^S(CC|T|F|NE|EQ) \$8\(A[0-7]\)$/) f8=1
  if(l~/^MOVE\.L #\$?FFFFFFFF,(20|\$14)\(A[0-7]\)$/ || l~/^MOVE\.L #-1,(20|\$14)\(A[0-7]\)$/ || l~/^MOVE\.L D[0-7],(20|\$14)\(A[0-7]\)$/) f20=1
  if(l~/^MOVE\.B [0-9A-F\$]+\(A[0-7]\),D0$/ || l~/^MOVE\.B [0-9A-F\$]+\(A[0-7]\),D1$/ || l~/^AND\.L #255,D0$/) sig=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREESIGNAL(\(A[0-7]\))?$/) fsig=1
  if(l~/^MOVEQ(\.L)? #34,D0$/ || l~/^PEA \(\$22\)\.W$/ || l~/^MOVE\.L #34,D0$/) sz=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREEMEM(\(A[0-7]\))?$/) fmem=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_PORT_LINK_TEST=" ptest
  print "HAS_REMPORT_CALL=" rem
  print "HAS_FIELD8_FF=" f8
  print "HAS_FIELD20_NEG1=" f20
  print "HAS_SIGNALNUM_LOAD=" sig
  print "HAS_FREESIGNAL_CALL=" fsig
  print "HAS_SIZE_34=" sz
  print "HAS_FREEMEM_CALL=" fmem
  print "HAS_RTS=" rts
}
