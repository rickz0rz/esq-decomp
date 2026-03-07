BEGIN{h_bottom=0;setapen_calls=0;setdrmd_calls=0;rect_calls=0;display_calls=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/)h_bottom=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_calls++
    if(l~/(JSR|BSR).*_LVOSETDRMD/)setdrmd_calls++
    if(l~/(JSR|BSR).*_LVORECTFILL/)rect_calls++
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_BOTTOM_HELP_BG="h_bottom
    print "HAS_SETAPEN="(setapen_calls>=3?1:0)
    print "HAS_SETDRMD="(setdrmd_calls>=2?1:0)
    print "HAS_RECTFILL="(rect_calls>=2?1:0)
    print "HAS_DISPLAY="(display_calls>=10?1:0)
    print "HAS_RTS="h_rts
}
