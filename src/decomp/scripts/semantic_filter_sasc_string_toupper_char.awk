BEGIN {h_entry=0; h_load=0; h_low=0; h_high=0; h_sub=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_TOUPPERCHAR:/) h_entry=1
  if(l~/^MOVE\.L .*D[067]$/ && l~/\(A7\)/) { h_load=1; if(l~/,D0$/) h_ret=1 }
  if(l~/(CMPI?\.B #'A'|CMPI?\.B #'a'|MOVEQ\.L #\$61,D[0-7])/) h_low=1
  if(l~/(CMPI?\.B #'Z'|CMPI?\.B #'z'|MOVEQ\.L #\$7A,D[0-7])/) h_high=1
  if(l~/^SUBI\.B #\$20,D[0-7]$/) h_sub=1
  if(l~/^MOVE\.B D[0-7],D0$/ || l~/^MOVE\.L D[0-7],D0$/) h_ret=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_ARG_LOAD=" h_load
  print "HAS_LOW_BOUND=" h_low
  print "HAS_HIGH_BOUND=" h_high
  print "HAS_SUB20=" h_sub
  print "HAS_RETURN=" h_ret
  print "HAS_RTS=" h_rts
}
