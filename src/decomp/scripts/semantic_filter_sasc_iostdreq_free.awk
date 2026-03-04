BEGIN {f8=0; f20=0; f24=0; sz=0; call=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MOVE\.B #\$?FF,[0-9]+\(A[0-7]\)$/ || l~/^MOVE\.B #-1,[0-9]+\(A[0-7]\)$/ || l~/^ST \([0-9]+,A[0-7]\)$/ || l~/^S(CC|T|F|NE|EQ) \$8\(A[0-7]\)$/) f8=1
  if(l~/^MOVE\.L #\$?FFFFFFFF,[0-9A-FX\$]+\(A[0-7]\)$/ || l~/^MOVE\.L #-1,[0-9A-FX\$]+\(A[0-7]\)$/ || l~/^MOVE\.L A0,(20|\$14)\(A[0-7]\)$/) f20=1
  if(l~/^MOVE\.L #\$?FFFFFFFF,(24|\$18)\(A[0-7]\)$/ || l~/^MOVE\.L #-1,(24|\$18)\(A[0-7]\)$/ || l~/^MOVE\.L A0,(24|\$18)\(A[0-7]\)$/) f24=1
  if(l~/^MOVEQ(\.L)? #48,D0$/ || l~/^PEA \(\$30\)\.W$/ || l~/^MOVE\.L #48,D0$/) sz=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREEMEM(\(A[0-7]\))?$/) call=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_FIELD8_FF=" f8
  print "HAS_FIELD20_NEG1=" f20
  print "HAS_FIELD24_NEG1=" f24
  print "HAS_SIZE_48=" sz
  print "HAS_FREEMEM_CALL=" call
  print "HAS_RTS=" rts
}
