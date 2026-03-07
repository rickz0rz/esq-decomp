BEGIN{h_low=0;h_high=0;h_setapen=0;h_setbpen=0;h_update_pos=0;h_mulu=0;h_move=0;h_text=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTLOWNIBBLE/ || l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTL/)h_low=1
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTHIGHNIBBLE/ || l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTH/)h_high=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETBPEN/)h_setbpen=1
    if(l~/(JSR|BSR).*ED_UPDATECURSORPOSFROMINDEX/)h_update_pos=1
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_mulu=1
    if(l~/(JSR|BSR).*_LVOMOVE/)h_move=1
    if(l~/(JSR|BSR).*_LVOTEXT/)h_text=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_LOW_NIBBLE="h_low
    print "HAS_HIGH_NIBBLE="h_high
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETBPEN="h_setbpen
    print "HAS_UPDATE_CURSOR_POS="h_update_pos
    print "HAS_MULU32="h_mulu
    print "HAS_MOVE="h_move
    print "HAS_TEXT="h_text
    print "HAS_RTS="h_rts
}
