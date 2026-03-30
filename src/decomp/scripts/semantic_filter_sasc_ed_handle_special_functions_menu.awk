BEGIN{
    h_entry=0;h_get_action=0;h_dispatch_gate=0;h_help=0;h_areyousure=0;h_menu_hl=0;h_diag_regs=0;h_esc_help=0
    h_special_menu=0;h_display=0;h_setapen=0;h_rect=0;h_state_change=0;h_rts=0
    h_prompt_all=0;h_prompt_tv=0;h_prompt_text_ads=0;h_prompt_reboot=0;h_prompt_reboot_line2=0
    h_state_0b=0;h_state_0c=0;h_state_0d=0;h_state_0e=0;h_state_0f=0
    h_prev_dec=0;h_prev_wrap=0;h_next_inc=0;h_next_wrap=0;h_cursor_guard=0;h_clear_temp=0
    prompt_window=0;reboot_window=0
}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/^ED_HANDLESPECIALFUNCTIONSMENU[A-Z0-9_]*:/)h_entry=1
    if(l~/(JSR|BSR).*ED_GETESCMENUACTIONCODE/)h_get_action=1
    if(l~/CMPI\.[WL] #\$?8,D[01]/ || l~/DISPATCH_TABLE/ || l~/__SWITCH_ED_HANDLESPECIALFUNCTIONSMENU/ || l~/JMP .*PC,D[01]\.W/)h_dispatch_gate=1
    if(l~/(JSR|BSR).*ED_DRAWAREYOUSUREPROMPT/)h_areyousure=1
    if(l~/(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/ || l~/(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/)h_menu_hl=1
    if(l~/(JSR|BSR).*ED_DRAWDIAGNOSTICREGISTERVALUES/)h_diag_regs=1
    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_esc_help=1
    if(l~/(JSR|BSR).*ED_DRAWSPECIALFUNCTIONSMENU/ || l~/(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/)h_special_menu=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/ || l~/(JSR|BSR).*ED_DRAWCOLORBARS/)h_setapen=1
    if(l~/(JSR|BSR).*_LVORECTFILL/ || l~/(JSR|BSR).*ED_DRAWCOLORBARS/)h_rect=1
    if(l~/(JSR|BSR).*ED_DRAWAREYOUSUREPROMPT/){prompt_window=8}else if(prompt_window>0){prompt_window--}
    if(prompt_window>0 && l~/ED2_STR_ALL_DATA_IS_TO_BE_SAVED/)h_prompt_all=1
    if(prompt_window>0 && l~/ED2_STR_TV_GUIDE_DATA_IS_TO_BE_S/)h_prompt_tv=1
    if(prompt_window>0 && l~/ED2_STR_TEXT_ADS_WILL_BE_LOADED/)h_prompt_text_ads=1
    if(prompt_window>0 && l~/GLOBAL_STR_COMPUTER_WILL_RESET/){h_prompt_reboot=1;reboot_window=8}
    if(reboot_window>0 && l~/GLOBAL_STR_GO_OFF_AIR_FOR_1_2_MI/)h_prompt_reboot_line2=1
    if(reboot_window>0)reboot_window--
    if(l~/MOVE\.B #\$?B,ED_MENUSTATEID/)h_state_0b=1
    if(l~/MOVE\.B #\$?C,ED_MENUSTATEID/)h_state_0c=1
    if(l~/MOVE\.B #\$?D,ED_MENUSTATEID/)h_state_0d=1
    if(l~/MOVE\.B #\$?E,ED_MENUSTATEID/)h_state_0e=1
    if(l~/MOVE\.B #\$?F,ED_MENUSTATEID/)h_state_0f=1
    if(h_state_0b || h_state_0c || h_state_0d || h_state_0e || h_state_0f)h_state_change=1
    if(l~/SUBQ\.[WL] #\$?1,ED_EDITCURSOROFFSET/)h_prev_dec=1
    if(l~/MOVEQ(\.L)? #\$?3,D0/ || l~/MOVE\.L #\$?3,ED_EDITCURSOROFFSET/)h_prev_wrap=1
    if(l~/ADDQ\.[WL] #\$?1,ED_EDITCURSOROFFSET/)h_next_inc=1
    if(l~/CLR\.L ED_EDITCURSOROFFSET/)h_next_wrap=1
    if((l~/MOVEQ(\.L)? #\$?2,D0/ || l~/CMPI\.[WL] #\$?2,D[01]/) && (l~/ED_EDITCURSOROFFSET/ || prev~/ED_EDITCURSOROFFSET/))h_cursor_guard=1
    if(l~/CLR\.L ED_TEMPCOPYOFFSET/)h_clear_temp=1
    if(l=="RTS")h_rts=1
    prev=l
}
END{
    print "HAS_ENTRY="h_entry
    print "HAS_GET_ACTION="h_get_action
    print "HAS_DISPATCH_GATE="h_dispatch_gate
    print "HAS_ARE_YOU_SURE="h_areyousure
    print "HAS_PROMPT_ALL="h_prompt_all
    print "HAS_PROMPT_TV_GUIDE="h_prompt_tv
    print "HAS_PROMPT_TEXT_ADS="h_prompt_text_ads
    print "HAS_PROMPT_REBOOT="h_prompt_reboot
    print "HAS_PROMPT_REBOOT_LINE2="h_prompt_reboot_line2
    print "HAS_MENU_HIGHLIGHT="h_menu_hl
    print "HAS_DIAG_REGS="h_diag_regs
    print "HAS_ESC_HELP="h_esc_help
    print "HAS_SPECIAL_MENU_DRAW="h_special_menu
    print "HAS_DISPLAY_CALL="h_display
    print "HAS_SETAPEN="h_setapen
    print "HAS_RECTFILL="h_rect
    print "HAS_MENU_STATE_CHANGE="h_state_change
    print "HAS_STATE_0B="h_state_0b
    print "HAS_STATE_0C="h_state_0c
    print "HAS_STATE_0D="h_state_0d
    print "HAS_STATE_0E="h_state_0e
    print "HAS_STATE_0F="h_state_0f
    print "HAS_PREV_DECREMENT="h_prev_dec
    print "HAS_PREV_WRAP="h_prev_wrap
    print "HAS_NEXT_INCREMENT="h_next_inc
    print "HAS_NEXT_WRAP="h_next_wrap
    print "HAS_CURSOR_GUARD="h_cursor_guard
    print "HAS_CLEAR_TEMP_COPY="h_clear_temp
    print "HAS_RTS="h_rts
}
