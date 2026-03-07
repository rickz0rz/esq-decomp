BEGIN{h_build=0;h_pack=0;h_redraw_rows=0;h_draw_color=0;h_redraw_cursor=0;h_line_page=0;h_text_cursor=0;h_sprintf=0;h_display=0;h_mulu=0;h_setapen=0;h_setbpen=0;h_setdrmd=0;h_rect=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_BUILDENTRYBUFFERSORDEFAULT/ || l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_BUILDENTRYBUFFER/ || l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_BUILDENT/)h_build=1
    if(l~/(JSR|BSR).*GROUP_AL_JMPTBL_LADFUNC_PACKNIBB/)h_pack=1
    if(l~/(JSR|BSR).*ED_REDRAWALLROWS/)h_redraw_rows=1
    if(l~/(JSR|BSR).*ED_DRAWCURRENTCOLORINDICATOR/)h_draw_color=1
    if(l~/(JSR|BSR).*ED_REDRAWCURSORCHAR/)h_redraw_cursor=1
    if(l~/(JSR|BSR).*SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE/ || l~/(JSR|BSR).*SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_/)h_line_page=1
    if(l~/(JSR|BSR).*SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR/ || l~/(JSR|BSR).*SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_/)h_text_cursor=1
    if(l~/(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/)h_sprintf=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)h_display=1
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_mulu=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETBPEN/)h_setbpen=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)h_setdrmd=1
    if(l~/(JSR|BSR).*_LVORECTFILL/)h_rect=1
    if(l=="RTS")h_rts=1
}
END{
    print "HAS_BUILD_BUFFERS="h_build
    print "HAS_PACK_NIBBLES="h_pack
    print "HAS_REDRAW_ROWS="h_redraw_rows
    print "HAS_DRAW_COLOR="h_draw_color
    print "HAS_REDRAW_CURSOR="h_redraw_cursor
    print "HAS_LINE_PAGE_BADGE="h_line_page
    print "HAS_TEXT_CURSOR_BADGE="h_text_cursor
    print "HAS_SPRINTF="h_sprintf
    print "HAS_DISPLAY="h_display
    print "HAS_MULU32="h_mulu
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETBPEN="h_setbpen
    print "HAS_SETDRMD="h_setdrmd
    print "HAS_RECTFILL="h_rect
    print "HAS_RTS="h_rts
}
