BEGIN{h_math_mul=0;setapen_calls=0;rect_calls=0;h_cursor_check=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_math_mul=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_calls++
    if(l~/(JSR|BSR).*_LVORECTFILL/)rect_calls++
    if(l~/CMPI\.L #\$?FFFFFFFF,ED_EDITCURSOROFFSET/ || l~/TST\.L ED_EDITCURSOROFFSET/ || l~/CMP\.L .*ED_EDITCURSOROFFSET/)h_cursor_check=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MULU32="h_math_mul
    print "HAS_SETAPEN="(setapen_calls>=1?1:0)
    print "HAS_RECTFILL="(rect_calls>=1?1:0)
    print "HAS_CURSOR_CHECK="h_cursor_check
    print "HAS_RTS="h_rts
}
