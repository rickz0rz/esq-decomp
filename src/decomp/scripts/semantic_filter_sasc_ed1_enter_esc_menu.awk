BEGIN{
    has_entry=0
    has_ui_busy=0
    has_setfont=0
    has_initbitmap=0
    has_setrast=0
    drmd_hits=0
    has_drop=0
    has_palette_copy=0
    has_disable=0
    has_enable=0
    has_read_mode=0
    has_color_mode_clear=0
    has_serial_shadow=0
    has_copper_off=0
    has_save_clear=0
    has_seed_defaults=0
    mulu_hits=0
    has_max_ad=0
    has_text_limit=0
    has_scroll_clamp=0
    has_block_offset=0
    has_current_ad=0
    has_help=0
    has_sprintf=0
    has_datetime=0
    setapen_hits=0
    has_center_bias=0
    has_center_half=0
    has_center_font_add=0
    has_center_final_offset=0
    has_display=0
    has_rise=0
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
    if(l~/^ED1_ENTERESCMENU[A-Z0-9_]*:/)has_entry=1
    if(l~/GLOBAL_UIBUSYFLAG/ && l~/#\$?1/)has_ui_busy=1
    if(l~/(JSR|BSR).*_LVOSETFONT/)has_setfont=1
    if(l~/(JSR|BSR).*_LVOINITBITMAP/)has_initbitmap=1
    if(l~/(JSR|BSR).*_LVOSETRAST/)has_setrast=1
    if(l~/(JSR|BSR).*_LVOSETDRMD/)drmd_hits++
    if(l~/(JSR|BSR).*ESQIFF_RUNCOPPERDROPTRANSITION/)has_drop=1
    if((l~/WDISP_PALETTETRIPLESRBASE/ && l~/KYBD_CUSTOMPALETTETRIPLESRBASE/) ||
       (l~/LEA KYBD_CUSTOMPALETTETRIPLESRBASE/ || l~/LEA WDISP_PALETTETRIPLESRBASE/) ||
       (l~/MOVE\.B/ && l~/\(A0,D7\.L\)/ && l~/\(A1,D7\.L\)/))has_palette_copy=1
    if(l~/(JSR|BSR).*_LVODISABLE/)has_disable=1
    if(l~/(JSR|BSR).*_LVOENABLE/)has_enable=1
    if(l~/ESQPARS2_READMODEFLAGS/ && l~/#\$?100/)has_read_mode=1
    if(l~/CLR\.W ESQSHARED_BANNERCOLORMODEWORD/)has_color_mode_clear=1
    if(l~/(JSR|BSR).*(SCRIPT_UPDATESERIALSHADOWFROMCTRLBYTE|GROUP_AK_JMPTBL_SCRIPT_UPDATESER)/)has_serial_shadow=1
    if(l~/(JSR|BSR).*(SETCOPPEREFFECT_OFFDISABLEHIGHLIGHT|GROUP_AM_JMPTBL_ESQ_SETCOPPEREFF)/)has_copper_off=1
    if(l~/CLR\.L ED_SAVETEXTADSONEXITFLAG/)has_save_clear=1
    if(l~/(JSR|BSR).*(ED1_JMPTBL_GCOMMAND_SEEDBANNERDE|GCOMMAND_SEEDBANNERDEFAULTS)/)has_seed_defaults=1
    if(l~/(JSR|BSR).*MATH_MULU32/)mulu_hits++
    if(l~/ED_MAXADNUMBER/)has_max_ad=1
    if(l~/ED_TEXTLIMIT/)has_text_limit=1
    if((l~/ED_DIAGSCROLLSPEEDCHAR/ && l~/#\$?36/) ||
       (l~/ED_TEXTLIMIT/ && l~/#\$?6/))has_scroll_clamp=1
    if(l~/ED_BLOCKOFFSET/)has_block_offset=1
    if(l~/GLOBAL_REF_LONG_CURRENT_EDITING_/)has_current_ad=1
    if(l~/(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/)has_help=1
    if(l~/(JSR|BSR).*WDISP_SPRINTF/)has_sprintf=1
    if(l~/(JSR|BSR).*(DRAWDATETIMEBANNERROW|DRAWDATETIMEB)/)has_datetime=1
    if(l~/(JSR|BSR).*_LVOSETAPEN/)setapen_hits++
    if((l~/MOVEQ(\.L)? #\$?22,D[016]/) || (l~/MOVEQ(\.L)? #34,D[016]/))has_center_bias=1
    if(l~/ASR\.L #\$?1,D[016]/)has_center_half=1
    if(l~/ADD\.L D[05],D[16]/)has_center_font_add=1
    if((l~/MOVEQ(\.L)? #\$?21,D[016]/) || (l~/MOVEQ(\.L)? #33,D[016]/))has_center_final_offset=1
    if(l~/(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/)has_display=1
    if(l~/(JSR|BSR).*ESQIFF_RUNCOPPERRISETRANSITION/)has_rise=1
}

END{
    print "HAS_ENTRY="has_entry
    print "HAS_UI_BUSY="has_ui_busy
    print "HAS_SETFONT="has_setfont
    print "HAS_INITBITMAP="has_initbitmap
    print "HAS_SETRAST="has_setrast
    print "HAS_DRMD="(drmd_hits >= 3 ? 1 : 0)
    print "HAS_DROP="has_drop
    print "HAS_PALETTE_COPY="has_palette_copy
    print "HAS_DISABLE="has_disable
    print "HAS_ENABLE="has_enable
    print "HAS_READ_MODE="has_read_mode
    print "HAS_COLOR_MODE_CLEAR="has_color_mode_clear
    print "HAS_SERIAL_SHADOW="has_serial_shadow
    print "HAS_COPPER_OFF="has_copper_off
    print "HAS_SAVE_CLEAR="has_save_clear
    print "HAS_SEED_DEFAULTS="has_seed_defaults
    print "HAS_MULU_TWICE="(mulu_hits >= 2 ? 1 : 0)
    print "HAS_MAX_AD="has_max_ad
    print "HAS_TEXT_LIMIT="has_text_limit
    print "HAS_SCROLL_CLAMP="has_scroll_clamp
    print "HAS_BLOCK_OFFSET="has_block_offset
    print "HAS_CURRENT_AD="has_current_ad
    print "HAS_HELP="has_help
    print "HAS_SPRINTF="has_sprintf
    print "HAS_DATETIME="has_datetime
    print "HAS_SETAPEN_TWICE="(setapen_hits >= 2 ? 1 : 0)
    print "HAS_CENTER_BIAS="has_center_bias
    print "HAS_CENTER_HALF="has_center_half
    print "HAS_CENTER_FONT_ADD="has_center_font_add
    print "HAS_CENTER_FINAL_OFFSET="has_center_final_offset
    print "HAS_DISPLAY="has_display
    print "HAS_RISE="has_rise
}
