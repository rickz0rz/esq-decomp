BEGIN {h1=0;h2=0;h3=0;h4=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^GCOMMAND_UPDATEPRESETENTRYCACHE_RETURN:/)h1=1; if(l~/^MOVEM\.L \(A7\)\+,D6-D7\/A3$/)h2=1; if("UNLK A5"!="" && l~/^UNLK A5$/)h3=1; if("RTS"!="" && l~/^RTS$/)h4=1}
END{print "HAS_ENTRY="h1;print "HAS_LINE2="h2; if("UNLK A5"!="") print "HAS_LINE3="h3; if("RTS"!="") print "HAS_LINE4="h4}
