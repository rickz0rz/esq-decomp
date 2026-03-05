BEGIN {head=0; loop=0; freesz=0; call=0; clear=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/GLOBAL_MEMLISTHEAD/) head=1
  if(l~/^(BEQ|BNE|BRA)(\.|\s)/) loop=1
  if(l~/8\(A[0-7]\),D0/ || l~/\$8\(A[0-7]\),D0/ || l~/\$8\(A[0-7]\),-\(A7\)/) freesz=1
  if(l~/^(JSR|BSR(\.W)?) _LVOFREEMEM(\(A[0-7]\))?$/) call=1
  if(l~/GLOBAL_MEMLISTTAIL/ || l~/GLOBAL_MEMLISTHEAD/) clear=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_HEAD_LOAD=" head
  print "HAS_LOOP_FLOW=" loop
  print "HAS_NODE_SIZE_LOAD=" freesz
  print "HAS_FREEMEM_CALL=" call
  print "HAS_HEAD_TAIL_CLEAR=" clear
  print "HAS_RTS=" rts
}
