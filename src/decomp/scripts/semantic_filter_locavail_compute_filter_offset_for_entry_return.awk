BEGIN {h1=0;h2=0;h3=0;h4=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^LOCAVAIL_COMPUTEFILTEROFFSETFORENTRY_RETURN:/)h1=1; if(l~/^MOVEM\.L \(A7\)\+,D4-D7\/A2-A3$/)h2=1; if(l~/^UNLK A5$/)h3=1; if(l~/^RTS$/)h4=1}
END{print "HAS_ENTRY="h1;print "HAS_MOVEM="h2;print "HAS_UNLK="h3;print "HAS_RTS="h4}
