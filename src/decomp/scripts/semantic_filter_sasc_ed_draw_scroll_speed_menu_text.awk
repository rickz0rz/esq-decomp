BEGIN{h_setapen=0;setdrmd_calls=0;h_sprintf=0;display_calls=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)setdrmd_calls++
    if(l~/(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/)h_sprintf=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETDRMD="(setdrmd_calls>=2?1:0)
    print "HAS_SPRINTF="h_sprintf
    print "HAS_DISPLAY="(display_calls>=9?1:0)
    print "HAS_RTS="h_rts
}
