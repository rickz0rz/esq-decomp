BEGIN {setsig=0; mask=0; cbcheck=0; cbcall=0; clear=0; closec=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/_LVOSETSIGNAL/) setsig=1
  if(l~/#\$3000/ || l~/#12288/ || l~/ANDI\.L #\$3000/) mask=1
  if((l~/GLOBAL_SIGNALCALLBACKPTR/ && (l~/TST\.L/ || l~/MOVE\.L .*D0/)) || l~/BEQ\.B .*SIGNAL_POLLANDDISPATCH/) cbcheck=1
  if(l~/JSR \(A[0-7]\)/ || l~/MOVEA\.L GLOBAL_SIGNALCALLBACKPTR/ || l~/MOVE\.L D0,A0/) cbcall=1
  if(l~/CLR\.L GLOBAL_SIGNALCALLBACKPTR/) clear=1
  if(l~/HANDLE_CLOSEALLANDRETURNWITHCODE/) closec=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_SETSIGNAL_CALL=" setsig
  print "HAS_MASK_3000=" mask
  print "HAS_CALLBACK_CHECK=" cbcheck
  print "HAS_CALLBACK_CALL=" cbcall
  print "HAS_CALLBACK_CLEAR=" clear
  print "HAS_CLOSEALL_CALL=" closec
  print "HAS_RTS=" rts
}
