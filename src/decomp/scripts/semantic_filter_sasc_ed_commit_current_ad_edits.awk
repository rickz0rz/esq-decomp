BEGIN{h_sub=0;h_call=0;h_live=0;h_scratch=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/GLOBAL_REF_LONG_CURRENT_EDITING_/)h_sub=1;if(l~/SUBQ\.[WL] #\$?1,D[0-7]/||l~/SUBI\.[WL] #\$?1,D[0-7]/)h_sub=1;if(l~/ED_EDITBUFFERLIVE/)h_live=1;if(l~/ED_EDITBUFFERSCRATCH/)h_scratch=1;if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_UPDATEEN/||l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_UPDATEENTRYBUFFERSFORADINDEX/)h_call=1;if(l=="RTS")h_rts=1}
END{print"HAS_SUB="h_sub;print"HAS_CALL="h_call;print"HAS_LIVE="h_live;print"HAS_SCRATCH="h_scratch;print"HAS_RTS="h_rts}
