BEGIN{h_help=0;h_inc=0;h_dec=0;h_bool=0;h_apply=0;h_indicator=0;h_reset=0;h_ring=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_help=1
    if(l~/(JSR|BSR).*ED_INCREMENTADNUMBER/)h_inc=1
    if(l~/(JSR|BSR).*ED_DECREMENTADNUMBER/)h_dec=1
    if(l~/(JSR|BSR).*ESQDISP_TESTWORDISZEROBOOLEANIZE/)h_bool=1
    if(l~/(JSR|BSR).*ED_APPLYACTIVEFLAGTOADDATA/)h_apply=1
    if(l~/(JSR|BSR).*ED_UPDATEACTIVEINACTIVEINDICATOR/)h_indicator=1
    if(l~/MOVE\.L #\$?1,ED_ADDISPLAYRESETFLAG/ || l~/MOVE\.L D[0-7],ED_ADDISPLAYRESETFLAG/)h_reset=1
    if(l~/ED_STATERINGINDEX/ || l~/ED_STATERINGTABLE/)h_ring=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_HELP_PATH="h_help
    print "HAS_INCREMENT_PATH="h_inc
    print "HAS_DECREMENT_PATH="h_dec
    print "HAS_BOOLEANIZE_PATH="h_bool
    print "HAS_APPLY_ACTIVE_FLAG="h_apply
    print "HAS_INDICATOR_UPDATE="h_indicator
    print "HAS_RESET_FLAG="h_reset
    print "HAS_RING_LOOKUP="h_ring
    print "HAS_RTS="h_rts
}
