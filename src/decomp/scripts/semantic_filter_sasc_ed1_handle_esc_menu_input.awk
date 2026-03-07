BEGIN{h_get=0;h_ad_prompt=0;h_diag_help=0;h_menu_hl=0;h_scroll=0;h_bottom=0;h_main_menu=0;h_diag_screen=0;h_special=0;h_display=0;h_setapen=0;h_shutdown=0;h_state2=0;h_state3=0;h_state6=0;h_state8=0;h_statea=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_GETESCMENUACTIONCODE/)h_get=1
    if(l~/(JSR|BSR).*ED_DRAWADNUMBERPROMPT/)h_ad_prompt=1
    if(l~/(JSR|BSR).*ED_DRAWDIAGNOSTICMODEHELPTEXT/)h_diag_help=1
    if(l~/(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/)h_menu_hl=1
    if(l~/(JSR|BSR).*ED_DRAWSCROLLSPEEDMENUTEXT/)h_scroll=1
    if(l~/(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/)h_bottom=1
    if(l~/(JSR|BSR).*ED_DRAWESCMAINMENUTEXT/)h_main_menu=1
    if(l~/(JSR|BSR).*ED1_DRAWDIAGNOSTICSSCREEN/)h_diag_screen=1
    if(l~/(JSR|BSR).*ED_DRAWSPECIALFUNCTIONSMENU/)h_special=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/ESQ_SHUTDOWNREQUESTEDFLAG/)h_shutdown=1
    if(l~/MOVE\.B #\$?2,ED_MENUSTATEID/)h_state2=1
    if(l~/MOVE\.B #\$?3,ED_MENUSTATEID/)h_state3=1
    if(l~/MOVE\.B #\$?6,ED_MENUSTATEID/)h_state6=1
    if(l~/MOVE\.B #\$?8,ED_MENUSTATEID/)h_state8=1
    if(l~/MOVE\.B #\$?A,ED_MENUSTATEID/)h_statea=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_GET_ACTION="h_get
    print "HAS_AD_PROMPT="h_ad_prompt
    print "HAS_DIAG_HELP="h_diag_help
    print "HAS_MENU_HIGHLIGHT="h_menu_hl
    print "HAS_SCROLL_MENU="h_scroll
    print "HAS_BOTTOM_HELP_BG="h_bottom
    print "HAS_ESC_MAIN_MENU="h_main_menu
    print "HAS_DIAG_SCREEN="h_diag_screen
    print "HAS_SPECIAL_MENU="h_special
    print "HAS_DISPLAY_ERROR="h_display
    print "HAS_SETAPEN="h_setapen
    print "HAS_SHUTDOWN_FLAG="h_shutdown
    print "HAS_STATE2="h_state2
    print "HAS_STATE3="h_state3
    print "HAS_STATE6="h_state6
    print "HAS_STATE8="h_state8
    print "HAS_STATEA="h_statea
    print "HAS_RTS="h_rts
}
