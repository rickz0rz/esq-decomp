BEGIN{
    h_entry=0
    h_flush=0
    h_save_ads=0
    h_save_pair=0
    h_save_locavail=0
    h_write_promo=0
    h_cleanup=0
    h_rts=0
}
function t(s, x){
    x=s
    sub(/;.*/,"",x)
    sub(/^[ \t]+/,"",x)
    sub(/[ \t]+$/,"",x)
    gsub(/[ \t]+/," ",x)
    return toupper(x)
}
{
    l=t($0)
    if(l=="")next
    if(l~/^ESQPARS_PERSISTSTATEDATAAFTERCOMMAND:/ || l~/^ESQPARS_PERSISTSTATEDATAAFTERCOM[A-Z0-9_]*:/)h_entry=1
    if(l~/(JSR|BSR).*DISKIO2_FLUSHDATA/)h_flush=1
    if(l~/(JSR|BSR).*LADFUNC_SAVETEXTADSTOFILE/)h_save_ads=1
    if(l~/(JSR|BSR).*DATETIME_SAVEPAIR/)h_save_pair=1
    if(l~/(JSR|BSR).*LOCAVAIL_SAVEAVAILABILITYDATAFIL/)h_save_locavail=1
    if(l~/(JSR|BSR).*P_TYPE_WRITEPROMO/)h_write_promo=1
    if(l~/^LEA [0-9]+\((A7)\),A7$/ || l~/^LEA \$[0-9A-F]+\((A7)\),A7$/)h_cleanup=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_ENTRY=" h_entry
    print "HAS_FLUSH_CALL=" h_flush
    print "HAS_SAVE_ADS_CALL=" h_save_ads
    print "HAS_SAVE_PAIR_CALL=" h_save_pair
    print "HAS_SAVE_LOCAVAIL_CALL=" h_save_locavail
    print "HAS_WRITE_PROMO_CALL=" h_write_promo
    print "HAS_STACK_CLEANUP=" h_cleanup
    print "HAS_RTS=" h_rts
}
