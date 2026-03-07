BEGIN{h_hi=0;h_lo=0;h_sprintf=0;h_display=0;setapen_calls=0;setbpen_calls=0;rect_calls=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTH/)h_hi=1
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_EXTRACTL/)h_lo=1
    if(l~/(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/)h_sprintf=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_calls++
    if(l~/(JSR|BSR).*_LVOSETBPEN/)setbpen_calls++
    if(l~/(JSR|BSR).*_LVORECTFILL/)rect_calls++
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_HIGH_NIBBLE="h_hi
    print "HAS_LOW_NIBBLE="h_lo
    print "HAS_SPRINTF="h_sprintf
    print "HAS_DISPLAY="h_display
    print "HAS_SETAPEN="(setapen_calls>=3?1:0)
    print "HAS_SETBPEN="(setbpen_calls>=2?1:0)
    print "HAS_RECTFILL="(rect_calls>=1?1:0)
    print "HAS_RTS="h_rts
}
