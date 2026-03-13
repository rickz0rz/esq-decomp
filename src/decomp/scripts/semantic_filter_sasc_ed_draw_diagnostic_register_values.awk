BEGIN{h_setdrmd=0;h_setapen=0;h_write_dec=0;display_calls=0;h_index_math=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*_LVOSETDRMD/)h_setdrmd=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*(GROUP_AL_JMPTBL_ESQ_WRITEDECFIXE|ESQ_WRITEDECFIXEDWIDT)/)h_write_dec=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l~/LSL\.L #\$?2,D0/ || l~/SUB\.L ED_TEMPCOPYOFFSET,D0/ || l~/ADD\.L D0,D0/ || l~/(JSR|BSR).*ED_DIAGPALETTEINDEX3/)h_index_math=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_SETDRMD="h_setdrmd
    print "HAS_SETAPEN="h_setapen
    print "HAS_WRITE_DEC="h_write_dec
    print "HAS_DISPLAY="(display_calls>=8?1:0)
    print "HAS_INDEX_MATH="h_index_math
    print "HAS_RTS="h_rts
}
