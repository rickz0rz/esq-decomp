BEGIN{h_sprintf=0;h_display=0;h_active_check=0;h_reset_flag=0;h_clear_viewport=0;h_latch_reset=0;h_indicator=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/)h_sprintf=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/TST\.W D1/ || l~/CMP\.W #\$?0,D1/ || l~/BLE/)h_active_check=1
    if(l~/MOVE\.L #\$?1,ED_ADDISPLAYRESETFLAG/ || l~/MOVE\.L D[0-7],ED_ADDISPLAYRESETFLAG/)h_reset_flag=1
    if(l~/MOVE\.L #\$?0,ED_VIEWPORTOFFSET/ || l~/CLR\.L ED_VIEWPORTOFFSET/ || l~/MOVE\.L D[0-7],ED_VIEWPORTOFFSET/)h_clear_viewport=1
    if(l~/MOVE\.L .*ED_ADDISPLAYSTATELATCHBLOCKB/ || l~/MOVE\.L .*ED_ACTIVEINDICATORCACHEDSTATE/ || l~/MOVE\.L .*ED_ADDISPLAYSTATELATCHA/)h_latch_reset=1
    if(l~/(JSR|BSR).*ED_UPDATEACTIVEINACTIVEINDICATOR/)h_indicator=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_SPRINTF="h_sprintf
    print "HAS_DISPLAY="h_display
    print "HAS_ACTIVE_CHECK="h_active_check
    print "HAS_RESET_FLAG="h_reset_flag
    print "HAS_CLEAR_VIEWPORT="h_clear_viewport
    print "HAS_LATCH_RESET="h_latch_reset
    print "HAS_INDICATOR_UPDATE="h_indicator
    print "HAS_RTS="h_rts
}
