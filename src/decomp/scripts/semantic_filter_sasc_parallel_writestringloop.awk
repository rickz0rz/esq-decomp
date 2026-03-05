BEGIN {e=0; l=0; z=0; c=0; b=0; r=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  x=t($0)
  if(x=="") next
  if(x~/^PARALLEL_WRITESTRINGLOOP:$/) e=1
  if(x~/^MOVE\.B \(A[0-7]\)\+,D[0-7]$/) l=1
  if(x~/^BEQ(\.[A-Z])? / || x~/^TST\.B D[0-7]$/) z=1
  if(x~/PARALLEL_WRITECHARD0/) c=1
  if(x~/^BRA(\.[A-Z])? /) b=1
  if(x~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_LOAD_CHAR=" l
  print "HAS_ZERO_CHECK=" z
  print "HAS_PUTC_CALL=" c
  print "HAS_LOOP_BRANCH=" b
  print "HAS_RTS=" r
}
