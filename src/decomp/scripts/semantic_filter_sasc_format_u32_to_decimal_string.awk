BEGIN {div=0; digit=0; emit=0; nul=0; len=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/MATH_DIVU32/) div=1
  if((l~/#\$?30/ || l~/#48/) && (l~/ADDI?\.(L|W)/ || l~/MOVEQ\.L #\$?30/)) digit=1
  if(l~/MOVE\.B .*\(A[0-7]\)\+/ || l~/MOVE\.B \(A[0-7]\),\(A[0-7]\)\+/ || l~/MOVE\.B -\(A[0-7]\),\(A[0-7]\)\+/) emit=1
  if(l~/CLR\.B \(A[0-7]\)/ || l~/MOVE\.B #\$?0,\(A[0-7]\)/) nul=1
  if(l~/SUB\.L .*D0/ || l~/MOVE\.L .*D0/) len=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_DIV_CALL=" div
  print "HAS_ASCII_DIGIT_ADJUST=" digit
  print "HAS_EMIT_LOOP=" emit
  print "HAS_NUL_TERM=" nul
  print "HAS_LENGTH_RETURN=" len
  print "HAS_RTS=" rts
}
