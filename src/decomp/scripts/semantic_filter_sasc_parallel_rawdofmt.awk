BEGIN {e=0; s=0; h=0; b=0; c=0; u=0; r=0}
function t(s0){sub(/;.*/,"",s0);sub(/^[ \t]+/,"",s0);sub(/[ \t]+$/,"",s0);gsub(/[ \t]+/," ",s0);return toupper(s0)}
{
  x=t($0)
  if(x=="") next
  if(x~/^PARALLEL_RAWDOFMT:$/) e=1
  if(x~/^MOVEM\.L A2\/A6,-\(A7\)$/ || x~/^MOVEM\.L A[0-7]\/A[0-7],-\(A7\)$/) s=1
  if(x~/PARALLEL_WRITECHARHW/) h=1
  if(x~/ABSEXECBASE/) b=1
  if(x~/_LVORAWDOFMT/) c=1
  if(x~/^MOVEM\.L \(A7\)\+,A2\/A6$/ || x~/^MOVEM\.L \(A7\)\+,A[0-7]\/A[0-7]$/) u=1
  if(x~/^RTS$/) r=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_SAVE_A2_A6=" s
  print "HAS_HOOK_REF=" h
  print "HAS_EXECBASE=" b
  print "HAS_RAWDOFMT_CALL=" c
  print "HAS_RESTORE_A2_A6=" u
  print "HAS_RTS=" r
}
