BEGIN {h_entry=0; h_findsrc=0; h_finddst=0; h_min=0; h_copy=0; h_nul=0; h_ret=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_APPENDN:/) h_entry=1
  if(l~/^TST\.B \(A[0-5]\)\+$/ || l~/^TST\.B \$?0\(A[0-5],D[0-7]\.L\)$/) h_findsrc=1
  if(l~/^TST\.B \(A[0-5]\)\+$/ || l~/^TST\.B \$?0\(A[0-5],D[0-7]\.L\)$/) h_finddst=1
  if(l~/^CMP\.L D[067],D[067]$/ || l~/^BLS\./ || l~/^BHI\./) h_min=1
  if(l~/^MOVE\.B \(A[0-5]\)\+,\(A[0-5]\)\+$/) h_copy=1
  if(l~/^CLR\.B .*\(A[0-5].*\)$/ || l~/^MOVE\.B #\$?0,\(A[0-5]\)$/) h_nul=1
  if(l~/^MOVE\.L A[0-5],D0$/ || l~/^MOVE\.L D[0-7],D0$/) h_ret=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_FIND_SRC=" h_findsrc
  print "HAS_FIND_DST=" h_finddst
  print "HAS_MIN_SELECT=" h_min
  print "HAS_COPY_LOOP=" h_copy
  print "HAS_NUL_TERM=" h_nul
  print "HAS_RET=" h_ret
  print "HAS_RTS=" h_rts
}
