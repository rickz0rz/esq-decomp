BEGIN {base=0; args=0; call=0; rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  l=t($0)
  if(l=="") next
  if(l~/GLOBAL_GRAPHICSLIBRARYBASE_A4/) base=1
  if(l~/MOVEA?\.L [0-9A-F\$]+\(A7\),A[01]/ || l~/MOVEM\.L [0-9A-F\$]+\(A7\),D[0-6]/ || l~/MOVE\.L D[0-6],-\(A7\)/) args=1
  if(l~/^(JSR|BSR(\.W)?) _LVOBLTBITMAPRASTPORT(\(A[0-7]\))?$/) call=1
  if(l~/^RTS$/) rts=1
}
END {
  print "HAS_GFX_BASE=" base
  print "HAS_ARG_SETUP=" args
  print "HAS_BLIT_CALL=" call
  print "HAS_RTS=" rts
}
