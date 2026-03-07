BEGIN{
    h_key_write=0
    h_input_write=0
    h_saved_scroll=0
    h_state_index=0
    h_bottom_help=0
    h_menu_hl=0
    h_scroll_text=0
    h_cursor_dec=0
    h_cursor_inc=0
    h_cursor_wrap8=0
    h_cursor_skip1to3=0
    h_cursor_wrap9to0=0
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

    if(l~/ED_LASTKEYCODE/)h_key_write=1
    if(l~/ED_LASTMENUINPUTCHAR/)h_input_write=1
    if(l~/ED_SAVEDSCROLLSPEEDINDEX/)h_saved_scroll=1
    if(l~/ESQPARS2_STATEINDEX/)h_state_index=1

    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)h_bottom_help=1
    if(l~/(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/)h_menu_hl=1
    if(l~/(JSR|BSR).*ED_DRAWSCROLLSPEEDMENUTEXT/)h_scroll_text=1

    if(l~/SUBQ\.L #\$?1,ED_EDITCURSOROFFSET/ || l~/SUBQ\.L #\$?1,ED_EDITCURSOROF/)h_cursor_dec=1
    if(l~/ADDQ\.L #\$?1,ED_EDITCURSOROFFSET/ || l~/ADDQ\.L #\$?1,ED_EDITCURSOROF/)h_cursor_inc=1
    if(l~/MOVEQ(\.L)? #\$?8,D[0-7]/)h_cursor_wrap8=1
    if(l~/MOVEQ(\.L)? #\$?3,D[0-7]/)h_cursor_skip1to3=1
    if(l~/CLR\.L ED_EDITCURSOROFFSET/ || l~/CLR\.L ED_EDITCURSOROF/)h_cursor_wrap9to0=1

    if(l=="RTS")h_rts=1
}
END{
    print "HAS_LAST_KEYCODE_WRITE=" h_key_write
    print "HAS_LAST_MENU_INPUT_WRITE=" h_input_write
    print "HAS_SAVED_SCROLL_SPEED_WRITE=" h_saved_scroll
    print "HAS_STATE_INDEX_WRITE=" h_state_index
    print "HAS_DRAW_BOTTOM_HELP=" h_bottom_help
    print "HAS_DRAW_MENU_HIGHLIGHT=" h_menu_hl
    print "HAS_DRAW_SCROLL_MENU_TEXT=" h_scroll_text
    print "HAS_CURSOR_DECREMENT_PATH=" h_cursor_dec
    print "HAS_CURSOR_INCREMENT_PATH=" h_cursor_inc
    print "HAS_CURSOR_WRAP_TO_8=" h_cursor_wrap8
    print "HAS_CURSOR_SKIP_1_TO_3=" h_cursor_skip1to3
    print "HAS_CURSOR_WRAP_9_TO_0=" h_cursor_wrap9to0
    print "HAS_RTS=" h_rts
}
