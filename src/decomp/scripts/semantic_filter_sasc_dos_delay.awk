BEGIN {h_entry=0; h_save=0; h_base=0; h_arg=0; h_call=0; h_restore=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^DOS_DELAY:/) h_entry=1
  if(l~/^MOVE\.L A6,-\(A7\)$/ || l~/^MOVEM\.L .*A6.*,-\(A7\)$/ || l~/^MOVE\.L D7,-\(A7\)$/) h_save=1
  if(l~/GLOBAL_REF_DOS_LIBRARY_2/) h_base=1
  if((l~/^MOVE\.L .*D1$/ && l~/\(A7\)/) || l~/^MOVE\.L D7,-\(A7\)$/) h_arg=1
  if(l~/^(JSR|BSR(\.W)?) _LVODELAY(\(A[0-7]\))?$/) h_call=1
  if(l~/^MOVEA?\.L \(A7\)\+,A6$/ || l~/^MOVEM\.L \(A7\)\+,.*A6/ || l~/^MOVE\.L \(A7\)\+,D7$/) h_restore=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SAVE_A6=" h_save
  print "HAS_DOS_BASE=" h_base
  print "HAS_ARG_D1=" h_arg
  print "HAS_DELAY_CALL=" h_call
  print "HAS_RESTORE_A6=" h_restore
  print "HAS_RTS=" h_rts
}
