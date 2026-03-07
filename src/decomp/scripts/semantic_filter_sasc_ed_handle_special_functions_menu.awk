BEGIN{h_get_action=0;h_help=0;h_areyousure=0;h_menu_hl=0;h_diag_regs=0;h_esc_help=0;h_special_menu=0;h_display=0;h_setapen=0;h_rect=0;h_state_change=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_GETESCMENUACTIONCODE/)h_get_action=1
    if(l~/(JSR|BSR).*ED_DRAWAREYOUSUREPROMPT/)h_areyousure=1
    if(l~/(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/ || l~/(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/)h_menu_hl=1
    if(l~/(JSR|BSR).*ED_DRAWDIAGNOSTICREGISTERVALUES/)h_diag_regs=1
    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_esc_help=1
    if(l~/(JSR|BSR).*ED_DRAWSPECIALFUNCTIONSMENU/ || l~/(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/)h_special_menu=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/ || l~/(JSR|BSR).*ED_DRAWCOLORBARS/)h_setapen=1
    if(l~/(JSR|BSR).*_LVORECTFILL/ || l~/(JSR|BSR).*ED_DRAWCOLORBARS/)h_rect=1
    if(l~/MOVE\.B #\$?B,ED_MENUSTATEID/ || l~/MOVE\.B #\$?C,ED_MENUSTATEID/ || l~/MOVE\.B #\$?D,ED_MENUSTATEID/ || l~/MOVE\.B #\$?E,ED_MENUSTATEID/ || l~/MOVE\.B #\$?F,ED_MENUSTATEID/)h_state_change=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_GET_ACTION="h_get_action
    print "HAS_ARE_YOU_SURE="h_areyousure
    print "HAS_MENU_HIGHLIGHT="h_menu_hl
    print "HAS_DIAG_REGS="h_diag_regs
    print "HAS_ESC_HELP="h_esc_help
    print "HAS_SPECIAL_MENU_DRAW="h_special_menu
    print "HAS_DISPLAY_CALL="h_display
    print "HAS_SETAPEN="h_setapen
    print "HAS_RECTFILL="h_rect
    print "HAS_MENU_STATE_CHANGE="h_state_change
    print "HAS_RTS="h_rts
}
