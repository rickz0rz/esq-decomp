BEGIN{h_help=0;h_write_dec=0;setapen_calls=0;setdrmd_calls=0;rect_calls=0;display_calls=0;h_pack=0;h_cursor=0;h_state_clear=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWHELPPANELS/)h_help=1
    if(l~/(JSR|BSR).*(GROUP_AL_JMPTBL_ESQ_WRITEDECFIXE|ESQ_WRITEDECFIXEDWIDT)/)h_write_dec=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_calls++
    if(l~/(JSR|BSR).*_LVOSETDRMD/)setdrmd_calls++
    if(l~/(JSR|BSR).*_LVORECTFILL/)rect_calls++
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_PACKNIBB/)h_pack=1
    if(l~/(JSR|BSR).*ED_REDRAWCURSORCHAR/)h_cursor=1
    if(l~/CLR\.B ED_ADNUMBERPROMPTSTATEBLOCK/ || l~/MOVE\.B #\$?0,ED_ADNUMBERPROMPTSTATEBLOCK/)h_state_clear=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_HELP="h_help
    print "HAS_WRITE_DEC="h_write_dec
    print "HAS_SETAPEN="(setapen_calls>=3?1:0)
    print "HAS_SETDRMD="(setdrmd_calls>=3?1:0)
    print "HAS_RECTFILL="(rect_calls>=1?1:0)
    print "HAS_DISPLAY="(display_calls>=6?1:0)
    print "HAS_PACK_NIBBLES="h_pack
    print "HAS_CURSOR_REDRAW="h_cursor
    print "HAS_STATE_CLEAR="h_state_clear
    print "HAS_RTS="h_rts
}
