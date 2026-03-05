BEGIN {e=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  x=t($0)
  if(x=="") next
  if(x~/^ESQ_MAINENTRYNOOPHOOK:$/ || x~/^ESQ_MAINEXITNOOPHOOK:$/) e=1
  if(x~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_RTS=" r
}
