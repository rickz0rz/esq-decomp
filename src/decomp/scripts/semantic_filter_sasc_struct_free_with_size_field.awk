BEGIN {f8=0; f20=0; f24=0; sz=0; call=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MOVE\.B #\$?FF,[0-9A-F\$]+\(A[0-7]\)$/ || l~/^MOVE\.B #-1,[0-9A-F\$]+\(A[0-7]\)$/ || l~/^S(CC|T|F|NE|EQ) \$8\(A[0-7]\)$/) f8=1
  if(l~/^MOVE\.L #\$?FFFFFFFF,(20|\$14|\$E)\(A[0-7]\)$/ || l~/^MOVE\.L A0,(20|\$14|\$E)\(A[0-7]\)$/) f20=1
  if(l~/^MOVE\.L #\$?FFFFFFFF,(24|\$18)\(A[0-7]\)$/ || l~/^MOVE\.L A0,(24|\$18)\(A[0-7]\)$/ || l~/^LEA \$18\(A[0-7]\),A1$/ || l~/^MOVE\.L A0,\(A1\)$/) f24=1
  if(l~/^MOVE\.W (18|\$12)\(A[0-7]\),D0$/ || l~/^AND\.L #65535,D0$/) sz=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREEMEM(\(A[0-7]\))?$/) call=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_FIELD8_FF=" f8
  print "HAS_FIELD20_NEG1=" f20
  print "HAS_FIELD24_NEG1=" f24
  print "HAS_SIZEWORD_LOAD=" sz
  print "HAS_FREEMEM_CALL=" call
  print "HAS_RTS=" rts
}
