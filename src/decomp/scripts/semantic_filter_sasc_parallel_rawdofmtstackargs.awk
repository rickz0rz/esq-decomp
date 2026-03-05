BEGIN {e=0; f=0; a=0; c=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{
  x=t($0)
  if(x=="") next
  if(x~/^PARALLEL_RAWDOFMTSTACKARGS:$/) e=1
  if(x~/^MOVEA?\.L [0-9]+\((A7|A5)\),A0$/ || x~/^MOVEA?\.L \$[0-9A-F]+\((A7|A5)\),A0$/ || x~/^MOVE\.L \$[0-9A-F]+\((A7|A5)\),-\(A7\)$/ || x~/^MOVE\.L [0-9]+\((A7|A5)\),-\(A7\)$/) f=1
  if(x~/^LEA [0-9]+\((A7|A5)\),A1$/ || x~/^LEA \$[0-9A-F]+\((A7|A5)\),A1$/ || x~/^PEA [0-9]+\((A7|A5)\)$/ || x~/^PEA \$[0-9A-F]+\((A7|A5)\)$/) a=1
  if(x~/PARALLEL_RAWDOFMTCOMMON/) c=1
}
END{
  print "HAS_ENTRY=" e
  print "HAS_FMT_LOAD=" f
  print "HAS_ARGS_LEA=" a
  print "HAS_COMMON_CALL=" c
}
