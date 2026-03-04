BEGIN {h_entry=0; h_load=0; h_low_a=0; h_low_b=0; h_sub20=0; h_subcmp=0; h_tst=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_COMPARENOCASE:/) h_entry=1
  if(l~/^MOVE\.B \(A[0-5]\)\+,D[0-7]$/) h_load=1
  if(l~/(CMPI?\.B #'A'|CMPI?\.B #'a'|MOVEQ\.L #\$61,D[0-7])/) h_low_a=1
  if(l~/(CMPI?\.B #'Z'|CMPI?\.B #'z'|MOVEQ\.L #\$7A,D[0-7])/) h_low_b=1
  if(l~/^SUBI\.B #\$20,D[0-7]$/) h_sub20=1
  if(l~/^SUB(\.B|\.L) D[0-7],D[0-7]$/ || l~/^BNE\./) h_subcmp=1
  if(l~/^TST\.B D[0-7]$/) h_tst=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_BYTE_LOADS=" h_load
  print "HAS_AZ_LOW_BOUND=" h_low_a
  print "HAS_AZ_HIGH_BOUND=" h_low_b
  print "HAS_SUB20=" h_sub20
  print "HAS_DIFF_TEST=" h_subcmp
  print "HAS_ZERO_TEST=" h_tst
  print "HAS_RTS=" h_rts
}
