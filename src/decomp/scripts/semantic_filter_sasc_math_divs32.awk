BEGIN {h_entry=0; h_test=0; c_neg=0; h_call=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MATH_DIVS32:/) h_entry=1
  if(l~/^TST\.L /) h_test=1
  if(l~/^NEG\.L /) c_neg++
  if(l~/^(BSR(\.W)?|JSR) MATH_DIVU32(\(PC\))?$/) h_call=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SIGN_TEST=" h_test
  print "HAS_NEGATION=" (c_neg>=1?1:0)
  print "HAS_DIVU32_CALL=" h_call
  print "HAS_RTS=" h_rts
}
