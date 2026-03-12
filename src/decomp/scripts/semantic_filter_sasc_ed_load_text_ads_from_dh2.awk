BEGIN{h_confirm=0;h_display=0;h_load=0;h_help=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/(JSR|BSR).*ED_ISCONFIRMKEY/)h_confirm=1;if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1;if(l~/(JSR|BSR).*(GROUP_AM_JMPTBL_LADFUNC_LOADTEXTADSFROMFILE|GROUP_AM_JMPTBL_LADFUNC_LOADTEXT|LADFUNC_LOADTEXTADSFROMFILE)/)h_load=1;if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_help=1;if(l=="RTS")h_rts=1}
END{print"HAS_CONFIRM="h_confirm;print"HAS_DISPLAY="h_display;print"HAS_LOAD="h_load;print"HAS_HELP="h_help;print"HAS_RTS="h_rts}
