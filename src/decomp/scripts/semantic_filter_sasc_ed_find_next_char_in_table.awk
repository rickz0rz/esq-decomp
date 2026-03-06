BEGIN{h_find=0;h_nullchk=0;h_inc=0;h_tst=0;h_ret=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/(JSR|BSR).*GROUP_AI_JMPTBL_STR_FINDCHARPTR/)h_find=1;if(l~/TST\.L D0/||l~/BEQ/)h_nullchk=1;if(l~/ADDQ\.[WL] #\$?1,-?[0-9]*\(A5\)/||l~/ADDQ\.[WL] #\$?1,D0/||l~/ADDQ\.[WL] #\$?1,A[0-7]/)h_inc=1;if(l~/TST\.B \(A[0-7]\)/||l~/MOVE\.B \(A[0-7]\),D0/)h_tst=1;if(l~/MOVE\.B \(A[0-7]\),D0/)h_ret=1;if(l=="RTS")h_rts=1}
END{print"HAS_FIND="h_find;print"HAS_NULLCHK="h_nullchk;print"HAS_INC="h_inc;print"HAS_TST="h_tst;print"HAS_RET="h_ret;print"HAS_RTS="h_rts}
