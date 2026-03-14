BEGIN {h_entry=0; h_a_load=0; h_set0=0; h_add4=0; h_clr4=0; h_set8=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^LIST_INITHEADER:/) h_entry=1
  if(l~/^MOVEA?\.L .*A[035]$/) h_a_load=1
  if(l~/^MOVE\.L (A[035]|D0),\(A[035]\)$/) h_set0=1
  if(l~/^ADDQ\.L #\$?4,\(A[035]\)$/ || l~/^LEA \$?4\(A[035]\),(A[0-6]|D0)$/) h_add4=1
  if(l~/^CLR\.L (\$?4|4)\(A[035]\)$/) h_clr4=1
  if(l~/^MOVE\.L A[035],(\$?8|8)\(A[035]\)$/) h_set8=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_A0_LOAD=" h_a_load
  print "HAS_SET_HEAD=" h_set0
  print "HAS_ADD4=" h_add4
  print "HAS_CLR_TAIL=" h_clr4
  print "HAS_SET_TAILPRED=" h_set8
  print "HAS_RTS=" h_rts
}
