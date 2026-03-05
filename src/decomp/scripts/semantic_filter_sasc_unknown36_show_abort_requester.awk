BEGIN {l=0; find=0; write=0; open=0; call348=0; msg=0; out=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  u=t($0)
  if(u=="") next
  if(u~/^UNKNOWN36_SHOWABORTREQUESTER:/) l=1
  if(u~/_LVOFINDTASK/ || u~/ABSEXECBASE/) find=1
  if(u~/_LVOWRITE/ || u~/BREAKPREFIX/ || u~/UNKNOWN36_STR_BREAKPREFIX/) write=1
  if(u~/_LVOOPENLIBRARY/ || u~/INTUITIONLIB/ || u~/UNKNOWN36_STR_INTUITIONLIBRARY/) open=1
  if(u~/EXEC_CALLVECTOR_348/) call348=1
  if(u~/GLOBAL_UNKNOWN36_MESSAGEPTR/) msg=1
  if(u~/GLOBAL_UNKNOWN36_REQUESTEROUTPTR/) out=1
  if(u~/^RTS$/) rts=1
}
END {
  print "HAS_LABEL=" l
  print "HAS_FINDTASK_PATH=" find
  print "HAS_WRITE_PATH=" write
  print "HAS_OPENLIB_PATH=" open
  print "HAS_EXEC348_CALL=" call348
  print "HAS_MESSAGE_PTR=" msg
  print "HAS_REQUESTER_OUT_PTR=" out
  print "HAS_RTS=" rts
}
