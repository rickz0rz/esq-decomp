BEGIN {count=0; loop=0; flags=0; closec=0; retc=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/GLOBAL_HANDLETABLECOUNT/) count=1
  if(l~/^(BRA|BNE|BEQ|BMI)(\.|\s)/) loop=1
  if(l~/GLOBAL_HANDLETABLEBASE/ || l~/BTST #4/) flags=1
  if(l~/DOS_CLOSEWITHSIGNALCHECK/) closec=1
  if(l~/UNKNOWN32_JMPTBL_ESQ_RETURNWITHSTACKCODE/ || l~/ESQ_RETURNWITHSTACKCODE/) retc=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_COUNT_LOAD=" count
  print "HAS_LOOP_FLOW=" loop
  print "HAS_FLAGS_CHECK=" flags
  print "HAS_CLOSE_CALL=" closec
  print "HAS_RETURN_CODE_CALL=" retc
  print "HAS_RTS=" rts
}
