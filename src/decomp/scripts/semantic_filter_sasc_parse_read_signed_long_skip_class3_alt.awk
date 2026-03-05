BEGIN {entry=0; nullg=0; skip=0; parse=0; loadout=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^PARSE_READSIGNEDLONGSKIPCLASS3_ALT:/ || l~/^PARSE_READSIGNEDLONGSKIPCLASS3_A:/) entry=1
  if(l~/^MOVEQ(\.L)? #0,D0$/ || l~/^(BEQ|BNE|BRA)(\.|\s)/) nullg=1
  if(l~/STR_SKIPCLASS3CHARS/) skip=1
  if(l~/PARSE_READSIGNEDLONG_NOBRANCH/) parse=1
  if(l~/^MOVE\.L -4\(A5\),D0$/ || l~/^MOVE\.L \$[0-9A-F]+\(A7\),D0$/) loadout=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_NULL_GUARD=" nullg
  print "HAS_SKIP_CALL=" skip
  print "HAS_PARSE_NOBRANCH_CALL=" parse
  print "HAS_OUTVALUE_LOAD=" loadout
  print "HAS_RTS=" rts
}
