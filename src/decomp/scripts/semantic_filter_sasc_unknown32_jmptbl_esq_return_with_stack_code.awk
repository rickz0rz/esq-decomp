BEGIN {jmp=0}
function t(s){sub(/;.*/,"",s);sub(/^[ \t]+/,"",s);sub(/[ \t]+$/,"",s);gsub(/[ \t]+/," ",s);return toupper(s)}
{ l=t($0); if(l~/ESQ_RETURNWITHSTACKCODE/ || l~/JMP / || l~/BSR\.W ESQ_RETURNWITHSTACKCODE/ || l~/JSR ESQ_RETURNWITHSTACKCODE/) jmp=1 }
END { print "HAS_RETURN_WITH_STACK_CODE_TRANSFER=" jmp }
