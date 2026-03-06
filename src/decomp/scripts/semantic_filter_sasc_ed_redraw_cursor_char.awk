BEGIN{h_drmd=0;h_draw=0;h_mode5=0;h_mode1=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/(JSR|BSR).*_LVOSETDRMD/)h_drmd=1;if(l~/(JSR|BSR).*ED_DRAWCURSORCHAR/)h_draw=1;if(l~/MOVEQ(\.L)? #\$?5,D[0-7]/||l~/PEA \(\$5\)\.W/)h_mode5=1;if(l~/MOVEQ(\.L)? #\$?1,D[0-7]/||l~/PEA \(\$1\)\.W/)h_mode1=1;if(l=="RTS")h_rts=1}
END{print"HAS_DRMD="h_drmd;print"HAS_DRAW="h_draw;print"HAS_MODE5="h_mode5;print"HAS_MODE1="h_mode1;print"HAS_RTS="h_rts}
