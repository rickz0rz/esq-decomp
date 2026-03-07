BEGIN{h_help=0;setdrmd_calls=0;h_setapen1=0;h_display=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWHELPPANELS/)h_help=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)setdrmd_calls++
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen1=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_HELP="h_help
    print "HAS_SETDRMD0="(setdrmd_calls>=1?1:0)
    print "HAS_SETAPEN="h_setapen1
    print "HAS_DISPLAY="h_display
    print "HAS_SETDRMD1="(setdrmd_calls>=2?1:0)
    print "HAS_RTS="h_rts
}
