BEGIN {e=0; c=0; t0=0; loop=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^PARALLEL_WAITREADY:$/) e=1
  if(l~/PARALLEL_CHECKREADY/) c=1
  if(l~/^TST\.L D0$/ || l~/^TST\.L D[0-7]$/) t0=1
  if(l~/^BMI(\.[A-Z])? / || l~/^BLT(\.[A-Z])? / || l~/^BPL(\.[A-Z])? / || l~/^BRA(\.[A-Z])? /) loop=1
  if(l~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_CHECK_CALL=" c
  print "HAS_TST=" t0
  print "HAS_LOOP_BRANCH=" loop
  print "HAS_RTS=" r
}
