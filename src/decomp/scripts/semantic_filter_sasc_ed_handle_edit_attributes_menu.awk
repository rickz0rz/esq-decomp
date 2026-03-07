BEGIN{h_draw_cursor=0;h_redraw_cursor=0;h_draw_edit=0;h_load_buffers=0;h_draw_help_panels=0;h_update_adnum=0;h_display=0;h_setapen=0;h_setdrmd=0;h_state4=0;h_state5=0;h_save_flag=0;h_ring=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWCURSORCHAR/)h_draw_cursor=1
    if(l~/(JSR|BSR).*ED_REDRAWCURSORCHAR/)h_redraw_cursor=1
    if(l~/(JSR|BSR).*ED_DRAWADEDITINGSCREEN/)h_draw_edit=1
    if(l~/(JSR|BSR).*ED_LOADCURRENTADINTOBUFFERS/)h_load_buffers=1
    if(l~/(JSR|BSR).*ED_DRAWHELPPANELS/)h_draw_help_panels=1
    if(l~/(JSR|BSR).*ED_UPDATEADNUMBERDISPLAY/)h_update_adnum=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)h_setdrmd=1
    if(l~/MOVE\.B #\$?4,ED_MENUSTATEID/)h_state4=1
    if(l~/MOVE\.B #\$?5,ED_MENUSTATEID/)h_state5=1
    if(l~/MOVE\.L #\$?1,ED_SAVETEXTADSONEXITFLAG/ || l~/MOVE\.L D[0-7],ED_SAVETEXTADSONEXITFLAG/)h_save_flag=1
    if(l~/ED_STATERINGINDEX/ || l~/ED_STATERINGTABLE/ || l~/ED_LASTMENUINPUTCHAR/)h_ring=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_DRAW_CURSOR="h_draw_cursor
    print "HAS_REDRAW_CURSOR="h_redraw_cursor
    print "HAS_DRAW_EDIT_SCREEN="h_draw_edit
    print "HAS_LOAD_BUFFERS="h_load_buffers
    print "HAS_DRAW_HELP_PANELS="h_draw_help_panels
    print "HAS_UPDATE_ADNUM="h_update_adnum
    print "HAS_DISPLAY="h_display
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETDRMD="h_setdrmd
    print "HAS_STATE4="h_state4
    print "HAS_STATE5="h_state5
    print "HAS_SAVE_FLAG="h_save_flag
    print "HAS_RING_NAV="h_ring
    print "HAS_RTS="h_rts
}
