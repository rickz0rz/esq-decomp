BEGIN {e=0; c=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^PARALLEL_WRITECHARD0:$/) e=1
  if(l~/PARALLEL_WRITECHARHW/) c=1
  if(l~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_HW_CALL=" c
  print "HAS_RTS=" r
}
