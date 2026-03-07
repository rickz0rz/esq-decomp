BEGIN{h_mulu=0;h_draw_cursor=0;h_setapen=0;h_setbpen=0;h_loop=0;h_restore=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_mulu=1
    if(l~/(JSR|BSR).*ED_DRAWCURSORCHAR/)h_draw_cursor=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETBPEN/)h_setbpen=1
    if(l~/ADDQ\.L #\$?1,ED_EDITCURSOROFFSET/ || l~/ADDQ\.L #\$?1,D[0-7]/)h_loop=1
    if(l~/MOVE\.L D6,ED_EDITCURSOROFFSET/ || l~/MOVE\.L D7,ED_EDITCURSOROFFSET/ || l~/MOVE\.L .*ED_EDITCURSOROFFSET/)h_restore=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MULU32="h_mulu
    print "HAS_DRAW_CURSOR="h_draw_cursor
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETBPEN="h_setbpen
    print "HAS_LOOP_INCREMENT="h_loop
    print "HAS_RESTORE_CURSOR="h_restore
    print "HAS_RTS="h_rts
}
