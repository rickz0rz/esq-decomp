BEGIN {h_entry=0; h_lookup=0; h_null_guard=0; h_seek=0; h_ioerr=0; h_retneg=0; h_rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^DOS_SEEKBYINDEX:/) h_entry=1
  if(l~/^(JSR|BSR(\.W)?) HANDLE_GETENTRYBYINDEX(\(PC\))?$/) h_lookup=1
  if(l~/^MOVEQ(\.L)? #(-1|\$FF),D0$/) h_retneg=1
  if(l~/^(JSR|BSR(\.W)?) DOS_SEEKWITHERRORSTATE(\(PC\))?$/) h_seek=1
  if(l~/GLOBAL_DOSIOERR(\(A4\))?/) h_ioerr=1
  if(l~/^BEQ\./ || l~/^BNE\./) h_null_guard=1
  if(l~/^RTS$/) h_rts=1
}
END {
  print "HAS_ENTRY=" h_entry
  print "HAS_LOOKUP_CALL=" h_lookup
  print "HAS_NULL_GUARD_BRANCH=" h_null_guard
  print "HAS_SEEK_CALL=" h_seek
  print "HAS_IOERR_CHECK=" h_ioerr
  print "HAS_NEG1_PATH=" h_retneg
  print "HAS_RTS=" h_rts
}
