BEGIN{h_cmp=0;h_commit=0;h_dec=0;h_load=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/CMPI\.L #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/CMPI\.L #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_/||l~/BLE/)h_cmp=1;if(l~/(JSR|BSR).*ED_COMMITCURRENTADEDITS/)h_commit=1;if(l~/SUBQ\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/SUBI\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_AD_NUMBER/||l~/SUBQ\.[WL] #\$?1,GLOBAL_REF_LONG_CURRENT_EDITING_/)h_dec=1;if(l~/(JSR|BSR).*ED_LOADCURRENTADINTOBUFFERS/)h_load=1;if(l=="RTS")h_rts=1}
END{print"HAS_CMP="h_cmp;print"HAS_COMMIT="h_commit;print"HAS_DEC="h_dec;print"HAS_LOAD="h_load;print"HAS_RTS="h_rts}
