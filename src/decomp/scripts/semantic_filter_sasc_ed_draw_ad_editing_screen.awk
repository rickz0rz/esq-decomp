BEGIN{h_help=0;h_line_page=0;h_text_cursor=0;badge_calls=0;h_sprintf=0;h_mulu=0;h_setapen=0;h_setbpen=0;h_setdrmd=0;h_rect=0;display_calls=0;h_rts=0}
function t(s, x){x=s;sub(/;.*/,"",x);sub(/^[ \t]+/,"",x);sub(/[ \t]+$/,"",x);gsub(/[ \t]+/," ",x);return toupper(x)}
{
    l=t($0)
    if(l=="")next
    if(l~/(JSR|BSR).*ED_DRAWHELPPANELS/)h_help=1
    if(l~/(JSR|BSR).*SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_/)badge_calls++
    if(l~/(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/)h_sprintf=1
    if(l~/(JSR|BSR).*ESQIFF_JMPTBL_MATH_MULU32/)h_mulu=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)h_setapen=1
    if(l~/(JSR|BSR).*_LVOSETBPEN/)h_setbpen=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)h_setdrmd=1
    if(l~/(JSR|BSR).*_LVORECTFILL/)h_rect=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)display_calls++
    if(l=="RTS")h_rts=1
}
END{
    if (badge_calls >= 1) h_line_page = 1
    if (badge_calls >= 2) h_text_cursor = 1
    print "HAS_HELP="h_help
    print "HAS_LINE_PAGE_BADGE="h_line_page
    print "HAS_TEXT_CURSOR_BADGE="h_text_cursor
    print "HAS_SPRINTF="h_sprintf
    print "HAS_MULU32="h_mulu
    print "HAS_SETAPEN="h_setapen
    print "HAS_SETBPEN="h_setbpen
    print "HAS_SETDRMD="h_setdrmd
    print "HAS_RECTFILL="h_rect
    print "HAS_DISPLAY="(display_calls>=4?1:0)
    print "HAS_RTS="h_rts
}
