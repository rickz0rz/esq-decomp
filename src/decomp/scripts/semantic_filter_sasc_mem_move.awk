BEGIN {h_entry=0; h_len=0; h_cmp=0; h_fwd=0; h_bwd=0; h_dec=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^MEM_MOVE:/) h_entry=1
  if(l~/^MOVE\.L .*D[07]$/ || l~/^TST\.L D[07]$/ || l~/^B(LE|GT)\./) h_len=1
  if(l~/^CMPA?\.L A[035],A[0135]$/ || l~/^CMP\.L .*A[035].*A[0135]/ || l~/^BCC\./ || l~/^BCS\./) h_cmp=1
  if(l~/^MOVE\.B \(A[035]\)\+,\(A[0135]\)\+$/) h_fwd=1
  if(l~/^MOVE\.B -\(A[035]\),-\(A[0135]\)$/ || l~/^MOVE\.B \(A[035]\),\(A[0135]\)$/) h_bwd=1
  if(l~/^SUBQ\.L #\$?1,D[07]$/) h_dec=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_LEN_GUARD=" h_len
  print "HAS_OVERLAP_BRANCH=" h_cmp
  print "HAS_FWD_COPY=" h_fwd
  print "HAS_BWD_COPY=" h_bwd
  print "HAS_DEC_LOOP=" h_dec
  print "HAS_RTS=" h_rts
}
