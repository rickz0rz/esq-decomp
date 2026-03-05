BEGIN {entry=0; table=0; btst=0; loop=0; ret=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/^STR_SKIPCLASS3CHARS:/) entry=1
  if(l~/GLOBAL_CHARCLASSTABLE/) table=1
  if(l~/BTST #\$?3/) btst=1
  if(l~/ADDQ\.L #\$?1,A[35]/ || l~/BRA\.[BS] .*STR_SKIPCLASS3CHARS__2/ || l~/BNE/) loop=1
  if(l~/MOVE\.L A[35],D0/) ret=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_ENTRY=" entry
  print "HAS_CLASS_TABLE_REF=" table
  print "HAS_BIT3_TEST=" btst
  print "HAS_SKIP_LOOP=" loop
  print "HAS_PTR_RETURN=" ret
  print "HAS_RTS=" rts
}
