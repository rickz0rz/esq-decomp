BEGIN {h1=0;h2=0;h3=0;h4=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^GCOMMAND_VALIDATEPRESETTABLE_RETURN:/)h1=1; if(l~/^MOVEM\.L \(A7\)\+,D5-D7\/A3$/)h2=1; if("RTS"!="" && l~/^RTS$/)h3=1; if(""!="" && l~/^$/)h4=1}
END{print "HAS_ENTRY="h1;print "HAS_LINE2="h2; if("RTS"!="") print "HAS_LINE3="h3; if(""!="") print "HAS_LINE4="h4}
