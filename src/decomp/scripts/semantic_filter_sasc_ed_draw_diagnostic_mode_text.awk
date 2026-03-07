BEGIN{setapen_calls=0;setdrmd_calls=0;move_calls=0;text_calls=0;display_calls=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_calls++
    if(l~/(JSR|BSR).*_LVOSETDRMD/)setdrmd_calls++
    if(l~/(JSR|BSR).*_LVOMOVE/)move_calls++
    if(l~/(JSR|BSR).*_LVOTEXT/)text_calls++
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_SETAPEN="(setapen_calls>=3?1:0)
    print "HAS_SETDRMD="(setdrmd_calls>=1?1:0)
    print "HAS_MOVE="(move_calls>=11?1:0)
    print "HAS_TEXT="(text_calls>=11?1:0)
    print "HAS_DISPLAY="(display_calls>=2?1:0)
    print "HAS_RTS="h_rts
}
