BEGIN {h_entry=0; c_mulu=0; c_swap=0; h_addw=0; h_addl=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MATH_MULU32:/) h_entry=1
  if(l~/^MULU(\.W)? /) c_mulu++
  if(l~/^SWAP /) c_swap++
  if(l~/^ADD\.W / || l~/^ADDW /) h_addw=1
  if(l~/^ADD\.L / || l~/^ADDL /) h_addl=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_3X_MULU=" (c_mulu>=3?1:0)
  print "HAS_SWAP=" (c_swap>=1?1:0)
  print "HAS_ADDW=" h_addw
  print "HAS_ADDL=" h_addl
  print "HAS_RTS=" h_rts
}
