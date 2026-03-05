BEGIN {e=0; s=0; h=0; c=0; u=0; r=0}
function t(s0){sub(/;.*/,"",s0);sub(/^[ \t]+/,"",s0);sub(/[ \t]+$/,"",s0);gsub(/[ \t]+/," ",s0);return toupper(s0)}
{
  x=t($0)
  if(x=="") next
  if(x~/^PARALLEL_RAWDOFMTCOMMON:$/) e=1
  if(x~/^MOVEM\.L A2,-\(A7\)$/ || x~/^MOVE\.L A2,-\(A7\)$/ || x~/^MOVEM\.L A3\/A5,-\(A7\)$/ || x~/^MOVEM\.L A2\/A3,-\(A7\)$/) s=1
  if(x~/PARALLEL_WRITECHARD0/) h=1
  if(x~/PARALLEL_RAWDOFMT/) c=1
  if(x~/^MOVEM\.L \(A7\)\+,A2$/ || x~/^MOVE\.L \(A7\)\+,A2$/ || x~/^MOVEM\.L \(A7\)\+,A3\/A5$/ || x~/^MOVEM\.L \(A7\)\+,A2\/A3$/) u=1
  if(x~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_SAVE_A2=" s
  print "HAS_HOOK_REF=" h
  print "HAS_RAWDOFMT_CALL=" c
  print "HAS_RESTORE_A2=" u
  print "HAS_RTS=" r
}
