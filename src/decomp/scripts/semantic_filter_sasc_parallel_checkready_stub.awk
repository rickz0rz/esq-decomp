BEGIN {e=0; m1=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^PARALLEL_CHECKREADYSTUB:$/) e=1
  if(l~/^MOVEQ(\.L)? #\-1,D0$/ || l~/^MOVEQ(\.L)? #\$FF,D0$/ || l~/^MOVEQ(\.L)? #\$-1,D0$/) m1=1
  if(l~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_RET_MINUS1=" m1
  print "HAS_RTS=" r
}
