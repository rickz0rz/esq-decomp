BEGIN {h_entry=0; h_null_guard=0; h_allocmem=0; h_type=0; h_pri=0; h_reply=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^ALLOCATE_ALLOCANDINITIALIZEIOSTDREQ:/ || l~/^ALLOCATE_ALLOCANDINITIALIZEIOSTD:/) h_entry=1
  if(l~/BEQ/ || l~/BNE/) h_null_guard=1
  if(l~/_LVOALLOCMEM/) h_allocmem=1
  if(l~/#5/ || l~/#\$5/ || l~/NT_MESSAGE/) h_type=1
  if(l~/CLR\.B/ || l~/#0/) h_pri=1
  if(l~/REPLYPORT/ || l~/\$E\(A3\)/ || l~/MOVE\.L A5,/) h_reply=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_NULL_GUARD=" h_null_guard
  print "HAS_ALLOCMEM_CALL=" h_allocmem
  print "HAS_MSG_TYPE_WRITE=" h_type
  print "HAS_MSG_PRI_WRITE=" h_pri
  print "HAS_REPLYPORT_WRITE=" h_reply
  print "HAS_RTS=" h_rts
}
