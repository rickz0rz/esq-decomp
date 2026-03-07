BEGIN{h_ring=0;h_parse=0;h_class_test=0;h_phase_update=0;h_copy_back=0;h_menu_clear=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/ED_STATERINGINDEX/ || l~/ED_STATERINGTABLE/ || l~/ED_LASTKEYCODE/)h_ring=1
    if(l~/(JSR|BSR).*ESQFUNC_JMPTBL_LADFUNC_PARSEHEXDIGIT/ || l~/(JSR|BSR).*ESQFUNC_JMPTBL_LADFUNC_PARSEHEXD/)h_parse=1
    if(l~/WDISP_CHARCLASSTABLE/ || l~/BTST #\$?7/)h_class_test=1
    if(l~/ED_CUSTOMPALETTECAPTUREPHASEMOD4/ || l~/DIVS/ || l~/%/)h_phase_update=1
    if(l~/KYBD_CUSTOMPALETTETRIPLESRBASE/ || l~/KYBD_CUSTOMPALETTECAPTURESCRATCHBASE/)h_copy_back=1
    if(l~/CLR\.B ED_MENUSTATEID/ || l~/MOVE\.B #\$?0,ED_MENUSTATEID/)h_menu_clear=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_RING_INDEXING="h_ring
    print "HAS_PARSE_HEX="h_parse
    print "HAS_CLASS_GATE="h_class_test
    print "HAS_PHASE_UPDATE="h_phase_update
    print "HAS_CAPTURE_BUFFER_WRITE="h_copy_back
    print "HAS_MENU_CLEAR="h_menu_clear
    print "HAS_RTS="h_rts
}
