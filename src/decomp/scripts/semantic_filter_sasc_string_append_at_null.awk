BEGIN {h_entry=0; h_load=0; h_save=0; h_find=0; h_sub_or_alt=0; h_copy=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STRING_APPENDATNULL:/) h_entry=1
  if(l~/^MOVEA?\.L .*A[0135]$/ && l~/\(A7\)/) h_load=1
  if(l~/^MOVE\.L A[025],D0$/ || l~/^MOVE\.L A[035],A2$/) h_save=1
  if(l~/^TST\.B \(A[035]\)\+?$/ || l~/^ADDQ\.L #\$?1,A[035]$/) h_find=1
  if(l~/^SUBQ\.L #\$?1,A[035]$/ || l~/^MOVE\.B \(A[035]\),\(A[035]\)\+$/) h_sub_or_alt=1
  if(l~/^MOVE\.B \(A[0135]\)\+,\(A[035]\)\+$/ || l~/^MOVE\.B \(A[0135]\),\(A[035]\)\+$/) h_copy=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_ARG_LOADS=" h_load
  print "HAS_RET_SAVE=" h_save
  print "HAS_FIND_LOOP=" h_find
  print "HAS_STEPBACK=" h_sub_or_alt
  print "HAS_COPY_LOOP=" h_copy
  print "HAS_RTS=" h_rts
}
