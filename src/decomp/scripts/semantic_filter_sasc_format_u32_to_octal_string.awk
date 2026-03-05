BEGIN {mask=0; ascii=0; shift=0; emit=0; nul=0; len=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/ANDI?\.(W|L) #\$?7/ || l~/AND\.L #\$?7/ || l~/MOVEQ\.L #\$?7,D[0-7]/ || l~/AND\.L D[0-7],D[0-7]/) mask=1
  if((l~/#\$?30/ || l~/#48/) && l~/(ADDI?\.(W|L)|MOVEQ\.L #\$?30|ADD\.L D[0-7],D0)/) ascii=1
  if(l~/LSR\.L #\$?3,D0/ || l~/LSR\.L #\$?3,D[0-7]/) shift=1
  if(l~/MOVE\.B .*\(A[0-7]\)\+/ || l~/MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+/) emit=1
  if(l~/CLR\.B \(A[0-7]\)/ || l~/MOVE\.B #\$?0,\(A[0-7]\)/) nul=1
  if(l~/SUB\.L .*D0/ || l~/MOVE\.L .*D0/) len=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_MASK7=" mask
  print "HAS_ASCII_ADJUST=" ascii
  print "HAS_SHIFT3_LOOP=" shift
  print "HAS_EMIT_LOOP=" emit
  print "HAS_NUL_TERM=" nul
  print "HAS_LENGTH_RETURN=" len
  print "HAS_RTS=" rts
}
