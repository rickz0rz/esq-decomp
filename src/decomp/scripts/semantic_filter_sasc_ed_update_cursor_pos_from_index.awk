BEGIN{h_div=0;h_col=0;h_row=0;h_loop=0;h_dec=0;h_sub40=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{l=t($0);if(l=="")next;if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_DIVS32/||l~/(JSR|BSR).*_CXD33/)h_div=1;if(l~/ED_CURSORCOLUMNINDEX/)h_col=1;if(l~/ED_VIEWPORTOFFSET/)h_row=1;if(l~/ED_TEXTLIMIT/&&l~/(CMP|BLT|BGE|BLE)/||l~/CLAMP_CURSOR_LOOP/)h_loop=1;if(l~/SUBQ\.[WL] #\$?1,ED_VIEWPORTOFFSET/)h_dec=1;if(l~/SUB\.L D[0-7],ED_EDITCURSOROFFSET/||l~/SUBI\.L #\$?28,ED_EDITCURSOROFFSET/)h_sub40=1;if(l=="RTS")h_rts=1}
END{print"HAS_DIV="h_div;print"HAS_COL="h_col;print"HAS_ROW="h_row;print"HAS_LOOP="h_loop;print"HAS_DEC="h_dec;print"HAS_SUB40="h_sub40;print"HAS_RTS="h_rts}
