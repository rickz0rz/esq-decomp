BEGIN {h1=0;h2=0;h3=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{l=t($0); if(l=="") next; if(l~/^LADFUNC2_EMITESCAPEDSTRINGWITHLIMIT_RETURN:/)h1=1; if(l~/^MOVEM\.L \(A7\)\+,D6-D7\/A3$/)h2=1; if(l~/^RTS$/)h3=1}
END{print "HAS_ENTRY="h1;print "HAS_MOVEM="h2;print "HAS_RTS="h3}
