BEGIN {scratch=0; fmtcall=0; rawcall=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/FORMAT_SCRATCHBUFFER/) scratch=1
  if(l~/FORMAT_FORMATTOBUFFER2/) fmtcall=1
  if(l~/PARALLEL_RAWDOFMTSTACKARGS/) rawcall=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_SCRATCHBUFFER_REF=" scratch
  print "HAS_FORMAT_CALL=" fmtcall
  print "HAS_RAWDOFMT_CALL=" rawcall
  print "HAS_RTS=" rts
}
