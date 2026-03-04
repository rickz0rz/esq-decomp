BEGIN {h_entry=0; h_load=0; h_ret=0; h_copy=0; h_tst=0; h_pad=0; h_dec=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_COPYPADNUL:/) h_entry=1
  if((l~/^MOVEA?\.L .*A[0-5]$/ || l~/^MOVE\.L \$?[0-9A-F]+\((A7|SP)\),A[0-5]$/) && l~/\(A7\)|\(SP\)/) h_load=1
  if(l~/^MOVE\.L A[0-5],D[0-7]$/) h_ret=1
  if(l~/^MOVE\.B \(A[0-5]\)\+,\(A[0-5]\)\+$/ || l~/^MOVE\.B \(A[0-5]\)\+,\(A[0-5]\)$/ || l~/^MOVE\.B \(A[0-5]\),\(A[0-5]\)$/) h_copy=1
  if(l~/^TST\.(B|L) D[0-7]$/ || l~/^BEQ\./) h_tst=1
  if(l~/^CLR\.B \(A[0-5]\)\+?$/ || l~/^MOVE\.B #\$?0,\(A[0-5]\)$/) h_pad=1
  if(l~/^SUBQ\.L #\$?1,D[0-7]$/ || l~/^BCC\./ || l~/^ADDQ\.L #\$?1,A[0-5]$/) h_dec=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_ARG_LOADS=" h_load
  print "HAS_RET_SAVE=" h_ret
  print "HAS_COPY=" h_copy
  print "HAS_ZERO_TEST=" h_tst
  print "HAS_PAD_LOOP=" h_pad
  print "HAS_LEN_DEC=" h_dec
  print "HAS_RTS=" h_rts
}
