BEGIN{h_cmp=0;h_commit=0;h_inc=0;h_load=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/ED_MAXADNUMBER/||l~/CMP\.L .*GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/CMP\.L .*GLOBAL_REF_LONG_CURRENT_EDITING_/||l~/BGE/)h_cmp=1;if(l~/(JSR|BSR).*ED_COMMITCURRENTADEDITS/)h_commit=1;if(l~/ADDQ\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/ADDI\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/ADDQ\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_/)h_inc=1;if(l~/(JSR|BSR).*ED_LOADCURRENTADINTOBUFFERS/)h_load=1;if(l=="RTS")h_rts=1}
END{print"HAS_CMP="h_cmp;print"HAS_COMMIT="h_commit;print"HAS_INC="h_inc;print"HAS_LOAD="h_load;print"HAS_RTS="h_rts}
