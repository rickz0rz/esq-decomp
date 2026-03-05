BEGIN {label=0; stream=0; alloc=0; close_call=0; mask=0; neg1=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^UNKNOWN36_FINALIZEREQUEST:/) label=1
  if(l~/STREAM_BUFFEREDPUTCORFLUSH/) stream=1
  if(l~/ALLOC_INSERTFREEBLOCK/) alloc=1
  if(l~/HANDLE_CLOSEBYINDEX/) close_call=1
  if((l~/AND\.L/ || l~/ANDI\.L/) && (l~/#12/ || l~/#\$C/)) mask=1
  if(l~/#-1/ || l~/-1\.W/ || l~/#\$?FF/) neg1=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_LABEL=" label
  print "HAS_STREAM_CALL=" stream
  print "HAS_ALLOC_CALL=" alloc
  print "HAS_CLOSE_CALL=" close_call
  print "HAS_FLAG_MASK_12=" mask
  print "HAS_NEG1_PATH=" neg1
  print "HAS_RTS=" rts
}
