BEGIN {h_entry=0; h_save=0; h_base=0; h_args=0; h_call=0; h_restore=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^DOS_SYSTEMTAGLIST:/) h_entry=1
  if(l~/^MOVEM\.L .*D2.*A6.*,-\(A7\)$/ || l~/^MOVE\.L D2,-\(A7\)$/ || l~/^MOVEM\.L D6\/D7,-\(A7\)$/) h_save=1
  if(l~/GLOBAL_REF_DOS_LIBRARY_2/) h_base=1
  if(l~/^MOVEM\.L .*D1-D2/ || l~/^MOVE\.L .*D1$/ || l~/^MOVE\.L .*D2$/ || l~/^MOVE\.L D[0-7],-\(A7\)$/) h_args=1
  if(l~/^(JSR|BSR(\.W)?) _LVOSYSTEMTAGLIST(\(A[0-7]\))?$/ || (l~/^JSR / && l~/\(A6\)$/)) h_call=1
  if(l~/^MOVEM\.L \(A7\)\+,.*D2.*A6/ || l~/^MOVE\.L \(A7\)\+,D2$/ || l~/^MOVEM\.L \(A7\)\+,D6\/D7$/) h_restore=1
  if(l~/^MOVE\.L D[0-7],D0$/) h_ret=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SAVE=" h_save
  print "HAS_DOS_BASE=" h_base
  print "HAS_ARGS=" h_args
  print "HAS_CALL=" h_call
  print "HAS_RESTORE=" h_restore
  print "HAS_RET=" h_ret
  print "HAS_RTS=" h_rts
}
