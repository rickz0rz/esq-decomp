BEGIN{h_mode=0;h_draw_screen=0;h_redraw_rows=0;h_redraw_cursor=0;h_draw_color=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/MOVE\.B #\$?4,ED_MENUSTATEID/)h_mode=1
    if(l~/(JSR|BSR).*ED_DRAWADEDITINGSCREEN/)h_draw_screen=1
    if(l~/(JSR|BSR).*ED_REDRAWALLROWS/)h_redraw_rows=1
    if(l~/(JSR|BSR).*ED_REDRAWCURSORCHAR/)h_redraw_cursor=1
    if(l~/(JSR|BSR).*ED_DRAWCURRENTCOLORINDICATOR/)h_draw_color=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_MODE4="h_mode
    print "HAS_DRAW_SCREEN="h_draw_screen
    print "HAS_REDRAW_ROWS="h_redraw_rows
    print "HAS_REDRAW_CURSOR="h_redraw_cursor
    print "HAS_DRAW_COLOR="h_draw_color
    print "HAS_RTS="h_rts
}
