BEGIN {entry=0; push=0; call=0; cleanup=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STR_FINDCHARPTR:/) entry=1
  if(l~/MOVE\.L .*,-\(A7\)/) push=1
  if(l~/STR_FINDCHAR/ || l~/^(BSR|JSR)(\.W)? .*STR_FINDCHAR/) call=1
  if(l~/ADDQ\.W #\$?8,A7/ || l~/LEA \$8\(A7\),A7/) cleanup=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_ARG_PUSH=" push
  print "HAS_FINDCHAR_CALL=" call
  print "HAS_STACK_CLEANUP=" cleanup
  print "HAS_RTS=" rts
}
