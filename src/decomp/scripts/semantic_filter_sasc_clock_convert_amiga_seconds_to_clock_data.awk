BEGIN {entry=0; base=0; args=0; call=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^CLOCK_CONVERTAMIGASECONDSTOCLOCKDATA:/ || l~/^CLOCK_CONVERTAMIGASECONDSTOCLOCKDA:/ || l~/^CLOCK_CONVERTAMIGASECONDSTOCLOCK:/) entry=1
  if(l~/GLOBAL_REF_UTILITY_LIBRARY/) base=1
  if(l~/MOVEM\.L .*D0\/A0/ || l~/MOVE\.L .*D0/ || l~/MOVEA?\.L .*A0/ || l~/MOVE\.L D[0-7],-\(A7\)/) args=1
  if(l~/^(JSR|BSR(\.W)?) _LVOAMIGA2DATE(\(A[0-7]\))?$/) call=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_UTILITY_BASE=" base
  print "HAS_ARG_SETUP=" args
  print "HAS_AMIGA2DATE_CALL=" call
  print "HAS_RTS=" rts
}
