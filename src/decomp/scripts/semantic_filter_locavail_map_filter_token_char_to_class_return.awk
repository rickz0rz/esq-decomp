BEGIN {h1=0;h2=0;h3=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^LOCAVAIL_MAPFILTERTOKENCHARTOCLASS_RETURN:/)h1=1; if(l~/^MOVE\.L D6,D0$/)h2=1; if(l~/^MOVEM\.L \(A7\)\+,D6-D7$/ || l~/^RTS$/)h3=1}
END{print "HAS_ENTRY="h1;print "HAS_MOVE="h2;print "HAS_TAIL="h3}
