BEGIN {entry=0; loop=0; pct=0; parse=0; cb=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^WDISP_FORMATWITHCALLBACK:/) entry=1
  if(l~/^(BRA|BNE|BEQ)(\.|\s)/) loop=1
  if(l~/#\$?25/ || l~/#\'%\'/ || l~/CMP\.B .*D7/ || l~/CMP\.B .*\(A2\)/) pct=1
  if(l~/FORMAT_PARSEFORMATSPEC/) parse=1
  if(l~/^JSR \(A[0-7]\)$/ || l~/MOVE\.L D0,-\(A7\)/) cb=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_LOOP_FLOW=" loop
  print "HAS_PERCENT_PATH=" pct
  print "HAS_PARSE_CALL=" parse
  print "HAS_CALLBACK_DISPATCH=" cb
  print "HAS_RTS=" rts
}
