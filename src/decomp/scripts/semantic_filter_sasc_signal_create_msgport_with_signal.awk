BEGIN {h_entry=0; h_allocsig=0; h_allocmem=0; h_freesig=0; h_findtask=0; h_addport=0; h_type=0; h_sigbit=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^SIGNAL_CREATEMSGPORTWITHSIGNAL:/) h_entry=1
  if(l~/_LVOALLOCSIGNAL/) h_allocsig=1
  if(l~/_LVOALLOCMEM/) h_allocmem=1
  if(l~/_LVOFREESIGNAL/) h_freesig=1
  if(l~/_LVOFINDTASK/) h_findtask=1
  if(l~/_LVOADDPORT/) h_addport=1
  if(l~/#4/ || l~/#\$4/ || l~/NT_MSGPORT/) h_type=1
  if(l~/MP_SIGBIT/ || l~/\(A2\)/ || l~/MOVE\.B D[0-7],/) h_sigbit=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_ALLOCSIGNAL_CALL=" h_allocsig
  print "HAS_ALLOCMEM_CALL=" h_allocmem
  print "HAS_FREESIGNAL_CALL=" h_freesig
  print "HAS_FINDTASK_CALL=" h_findtask
  print "HAS_ADDPORT_CALL=" h_addport
  print "HAS_MSGPORT_TYPE_WRITE=" h_type
  print "HAS_SIGBIT_WRITE=" h_sigbit
  print "HAS_RTS=" h_rts
}
