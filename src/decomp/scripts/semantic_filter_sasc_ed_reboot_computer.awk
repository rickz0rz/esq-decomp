BEGIN{h_confirm=0;h_display=0;h_delay=0;h_reboot=0;h_help=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/(JSR|BSR).*ED_ISCONFIRMKEY/)h_confirm=1;if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1;if(l~/AAE60/||l~/ADDQ\.[WL] #\$?1,D[67]/||l~/ADDQ\.[WL] #\$?2,D[67]/||l~/BGE/)h_delay=1;if(l~/(JSR|BSR).*ED1_JMPTBL_ESQ_COLDREBOOT/)h_reboot=1;if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_help=1;if(l=="RTS")h_rts=1}
END{print"HAS_CONFIRM="h_confirm;print"HAS_DISPLAY="h_display;print"HAS_DELAY="h_delay;print"HAS_REBOOT="h_reboot;print"HAS_HELP="h_help;print"HAS_RTS="h_rts}
