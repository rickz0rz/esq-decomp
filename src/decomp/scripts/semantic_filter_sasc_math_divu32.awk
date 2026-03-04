BEGIN {h_entry=0; h_divu=0; h_mulu=0; h_swap=0; h_shift=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MATH_DIVU32:/) h_entry=1
  if(l~/^DIVU(\.W)? / || l~/^BSR(\.W)? _CXD[0-9A-Z]+$/) h_divu=1
  if(l~/^MULU(\.W)? /) h_mulu=1
  if(l~/^SWAP /) h_swap=1
  if(l~/^(LSR|ROL)\.L /) h_shift=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_DIVU=" h_divu
  print "HAS_MULU=" h_mulu
  print "HAS_SWAP=" h_swap
  print "HAS_SHIFT_CORE=" h_shift
  print "HAS_RTS=" h_rts
}
