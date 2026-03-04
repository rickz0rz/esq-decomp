BEGIN {h_entry=0; h_len_guard=0; h_nonnull=0; h_upcall=0; h_diff=0; h_tail=0; h_neg1=0; h_pos1=0; h_zero=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_COMPARENOCASEN:/) h_entry=1
  if(l~/^TST\.L D[67]$/ || l~/^SUBQ\.L #\$?1,D[67]$/ || l~/^BEQ\./) h_len_guard=1
  if(l~/^TST\.B \(A[23]\)$/) h_nonnull=1
  if(l~/^(JSR|BSR(\.W)?) STRING_TOUPPERCHAR(\(PC\))?$/) h_upcall=1
  if(l~/^SUB\.L D[0-7],D[0-7]$/ || l~/^BNE\./ || l~/^BEQ\./) h_diff=1
  if(l~/^TST\.B \(A[23]\)$/) h_tail=1
  if(l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/) h_neg1=1
  if(l~/^MOVEQ(\.L)? #\$?1,D0$/) h_pos1=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_zero=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_LEN_GUARD=" h_len_guard
  print "HAS_NONNULL_TESTS=" h_nonnull
  print "HAS_TOUPPER_CALL=" h_upcall
  print "HAS_DIFF_TEST=" h_diff
  print "HAS_TAIL_TESTS=" h_tail
  print "HAS_NEG1=" h_neg1
  print "HAS_POS1=" h_pos1
  print "HAS_ZERO=" h_zero
  print "HAS_RTS=" h_rts
}
