BEGIN{h_cmp=0;h_rect=0;h_text=0;h_setdr=0;h_setapen=0;h_cache=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/ED_ADACTIVEFLAG/&&l~/ED_ACTIVEINDICATORCACHEDSTATE/||l~/CMP\.L .*ED_ACTIVEINDICATORCACHEDSTATE/)h_cmp=1;if(l~/(JSR|BSR).*_LVORECTFILL/)h_rect=1;if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/&&l~/GLOBAL_STR_ACTIVE_INACTIVE/)h_text=1;if(l~/(JSR|BSR).*_LVOSETDRMD/)h_setdr=1;if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1;if(l~/ED_ACTIVEINDICATORCACHEDSTATE/&&l~/MOVE\.L/)h_cache=1;if(l=="RTS")h_rts=1}
END{print"HAS_CMP="h_cmp;print"HAS_RECT="h_rect;print"HAS_TEXT="h_text;print"HAS_SETDR="h_setdr;print"HAS_SETAPEN="h_setapen;print"HAS_CACHE="h_cache;print"HAS_RTS="h_rts}
