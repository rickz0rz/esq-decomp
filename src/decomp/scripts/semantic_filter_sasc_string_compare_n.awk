BEGIN {h_entry=0; h_len_guard=0; h_byte_load=0; h_sub=0; h_diff_branch=0; h_tail=0; h_neg1=0; h_pos1=0; h_zero=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_COMPAREN:/) h_entry=1
  if(l~/^TST\.L D[67]$/ || l~/^BEQ\./ || l~/^SUBQ\.L #\$?1,D[67]$/) h_len_guard=1
  if(l~/^MOVE\.B \(A[23]\)\+,D[01]$/ || l~/^MOVE\.B \(A[23]\),D[01]$/ || l~/^MOVEQ(\.L)? #\$?0,D[01]$/) h_byte_load=1
  if(l~/^SUB\.L D[01],D[01]$/) h_sub=1
  if(l~/^BNE\./) h_diff_branch=1
  if(l~/^TST\.B \(A[23]\)$/) h_tail=1
  if(l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/) h_neg1=1
  if(l~/^MOVEQ(\.L)? #\$?1,D0$/) h_pos1=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_zero=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_LEN_GUARD=" h_len_guard
  print "HAS_BYTE_LOADS=" h_byte_load
  print "HAS_SUB_DIFF=" h_sub
  print "HAS_DIFF_BRANCH=" h_diff_branch
  print "HAS_TAIL_CHECKS=" h_tail
  print "HAS_NEG1=" h_neg1
  print "HAS_POS1=" h_pos1
  print "HAS_ZERO=" h_zero
  print "HAS_RTS=" h_rts
}
