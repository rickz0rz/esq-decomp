BEGIN {rts=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{ l=t($0); if(l~/^RTS$/) rts=1 }
END { print "HAS_RTS=" rts }
