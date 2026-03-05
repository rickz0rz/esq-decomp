BEGIN {entry=0; outer=0; inner=0; cmp=0; retptr=0; ret0=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STR_FINDANYCHARINSET:/) entry=1
  if((l~/TST\.B \(A[0-7]\)/ && l~/BEQ/) || l~/ADDQ\.L #\$?1,A[0-7]/) outer=1
  if(l~/MOVE\.L A[0-7],A[0-7]/ || (l~/TST\.B \(A[0-7]\)/ && l~/BEQ/) || l~/ADDQ\.L #\$?1,A[0-7]/) inner=1
  if(l~/CMP\.B/) cmp=1
  if(l~/MOVE\.L A[0-7],D0/) retptr=1
  if(l~/MOVEQ(\.L)? #\$?0,D0/ || l~/CLR\.L D0/) ret0=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_OUTER_SCAN=" outer
  print "HAS_INNER_SCAN=" inner
  print "HAS_COMPARE=" cmp
  print "HAS_PTR_RETURN=" retptr
  print "HAS_ZERO_RETURN=" ret0
  print "HAS_RTS=" rts
}
