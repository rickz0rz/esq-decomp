BEGIN {h_entry=0; h_setup=0; h_cmpm=0; h_advance=0; h_notfound=0; h_found=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_FINDSUBSTRING:/) h_entry=1
  if(l~/^MOVEA?\.L .*A[0-3]$/ && l~/\(A7\)/) h_setup=1
  if(l~/^CMPM\.B \(A[0-3]\)\+,\(A[0-3]\)\+$/ || (l~/^MOVE\.B \(A[0-3]\)\+,D[01]$/) || l~/^CMP\.B D[01],D[01]$/) h_cmpm=1
  if(l~/^ADDQ\.L #\$?1,A[05]$/ || l~/^(CMPI\.B #\$?0,\(A[0-3]\)|TST\.B \(A[05]\))$/) h_advance=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_notfound=1
  if(l~/^MOVE\.L A[05],D0$/) h_found=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_SETUP=" h_setup
  print "HAS_CMPM_LOOP=" h_cmpm
  print "HAS_ADVANCE_PATH=" h_advance
  print "HAS_NOTFOUND_ZERO=" h_notfound
  print "HAS_FOUND_RETURN=" h_found
  print "HAS_RTS=" h_rts
}
