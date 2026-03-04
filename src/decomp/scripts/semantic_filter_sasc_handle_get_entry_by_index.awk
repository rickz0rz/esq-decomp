BEGIN {h_entry=0; h_clear_ioerr=0; h_neg_guard=0; h_bounds=0; h_scale=0; h_flagcheck=0; h_set_err9=0; h_return_ptr=0; h_return_zero=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^HANDLE_GETENTRYBYINDEX:/) h_entry=1
  if((l~/GLOBAL_DOSIOERR\(A4\)/ && l~/^MOVE\.L D[0-7],/) || l~/^CLR\.L GLOBAL_DOSIOERR\(A4\)$/) h_clear_ioerr=1
  if(l~/^BMI\./ || l~/^TST\.L D[0-7]$/) h_neg_guard=1
  if(l~/GLOBAL_HANDLETABLECOUNT\(A4\)/ && (l~/^CMP\.L/ || l~/^BGE\./)) h_bounds=1
  if(l~/^ASL\.L #\$?3,D[0-7]$/) h_scale=1
  if(l~/STRUCT_HANDLEENTRY__FLAGS\(A0,D[0-7]\.L\)/ || l~/^TST\.L .*\(A0,D[0-7]\.L\)$/) h_flagcheck=1
  if(l~/GLOBAL_APPERRORCODE\(A4\)/ && l~/#\$?9/) h_set_err9=1
  if(l~/^MOVE\.L A0,D0$/) h_return_ptr=1
  if(l~/^MOVEQ(\.L)? #\$?0,D0$/) h_return_zero=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_CLEAR_DOSIOERR=" h_clear_ioerr
  print "HAS_NEGATIVE_GUARD=" h_neg_guard
  print "HAS_BOUNDS_GUARD=" h_bounds
  print "HAS_INDEX_SCALE8=" h_scale
  print "HAS_FLAGS_CHECK=" h_flagcheck
  print "HAS_SET_ERROR9=" h_set_err9
  print "HAS_RETURN_PTR=" h_return_ptr
  print "HAS_RETURN_ZERO=" h_return_zero
  print "HAS_RTS=" h_rts
}
