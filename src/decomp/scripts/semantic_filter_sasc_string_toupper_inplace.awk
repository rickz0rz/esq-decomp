BEGIN {h_entry=0; h_load=0; h_loop=0; h_table=0; h_btst=0; h_sub32=0; h_store=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_TOUPPERINPLACE:/) h_entry=1
  if(l~/^MOVEA?\.L .*\(A7\),A[235]$/) h_load=1
  if(l~/^TST\.B \(A[23]\)$/ || l~/^ADDQ\.L #\$?1,A[23]$/) h_loop=1
  if(l~/GLOBAL_CHARCLASSTABLE(\(A4\))?/) h_table=1
  if(l~/^BTST #\$?1,\$?0\(A0,D[0-7]\.L\)$/ || l~/^ANDI\.[BW] #\$?2,D[0-7]$/) h_btst=1
  if(l~/^SUB\.L D[0-7],D[0-7]$/ || l~/^SUBI\.B #\$?20,D[0-7]$/ || l~/^MOVEQ\.L? #\$?20,D[0-7]$/) h_sub32=1
  if(l~/^MOVE\.B D[0-7],\(A[23]\)$/) h_store=1
  if(l~/^MOVE\.L A[235],D0$/) h_ret=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_ARG_LOAD=" h_load
  print "HAS_LOOP=" h_loop
  print "HAS_TABLE_REF=" h_table
  print "HAS_CLASS_TEST=" h_btst
  print "HAS_SUB32_PATH=" h_sub32
  print "HAS_STORE=" h_store
  print "HAS_RETURN_PTR=" h_ret
  print "HAS_RTS=" h_rts
}
