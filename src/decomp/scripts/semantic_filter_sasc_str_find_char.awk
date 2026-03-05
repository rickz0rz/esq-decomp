BEGIN {entry=0; cmp=0; nul=0; retptr=0; ret0=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STR_FINDCHAR:/) entry=1
  if(l~/CMP\.(B|L)/) cmp=1
  if(l~/TST\.B/ || l~/BEQ/) nul=1
  if(l~/MOVE\.L A[0-7],D0/) retptr=1
  if(l~/MOVEQ(\.L)? #\$?0,D0$/ || l~/CLR\.L D0$/) ret0=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_CHAR_COMPARE=" cmp
  print "HAS_NUL_CHECK=" nul
  print "HAS_PTR_RETURN_PATH=" retptr
  print "HAS_ZERO_RETURN_PATH=" ret0
  print "HAS_RTS=" rts
}
