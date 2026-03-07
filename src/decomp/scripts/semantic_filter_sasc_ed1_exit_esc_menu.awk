BEGIN {
    h_init_bm = 0
    h_set_font = 0
    h_reset_hl = 0
    h_prime_transition = 0
    h_update_hl = 0
    h_refresh_tick = 0
    h_clear_menu_mode = 0
    h_update_refresh_mode = 0
    h_draw_top = 0
    h_optional_save = 0
    h_wait_clear_bit0 = 0
    h_free_brushes = 0
    h_seed_banner = 0
    h_draw_bottom = 0
    h_set_rast_mode = 0
    h_copper_rise = 0
    h_rts = 0
}

function norm(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = norm($0)
    if (l == "") next

    if (l ~ /(JSR|BSR).*_LVOINITBITMAP/) h_init_bm = 1
    if (l ~ /(JSR|BSR).*_LVOSETFONT/) h_set_font = 1
    if (l ~ /(JSR|BSR).*ED1_JMPTBL_GCOMMAND_RESETHIGHLIG/) h_reset_hl = 1
    if (l ~ /(JSR|BSR).*GROUP_AM_JMPTBL_SCRIPT_PRIMEBANN/) h_prime_transition = 1
    if (l ~ /(JSR|BSR).*ESQFUNC_JMPTBL_LADFUNC_UPDATEHIG/) h_update_hl = 1
    if (l ~ /(JSR|BSR).*ESQFUNC_UPDATEDISKWARNINGANDREFR/) h_refresh_tick = 1
    if (l ~ /(JSR|BSR).*ED1_CLEARESCMENUMODE/) h_clear_menu_mode = 1
    if (l ~ /(JSR|BSR).*ESQFUNC_UPDATEREFRESHMODESTATE/) h_update_refresh_mode = 1
    if (l ~ /(JSR|BSR).*ED1_JMPTBL_NEWGRID_DRAWTOPBORDER/) h_draw_top = 1
    if (l ~ /(JSR|BSR).*ED1_JMPTBL_LADFUNC_SAVETEXTADSTO/) h_optional_save = 1
    if (l ~ /(JSR|BSR).*ED1_WAITFORFLAGANDCLEARBIT0/) h_wait_clear_bit0 = 1
    if (l ~ /(JSR|BSR).*ESQIFF_JMPTBL_BRUSH_FREEBRUSHLIS/) h_free_brushes = 1
    if (l ~ /(JSR|BSR).*ED1_JMPTBL_GCOMMAND_SEEDBANNERFR/) h_seed_banner = 1
    if (l ~ /(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/) h_draw_bottom = 1
    if (l ~ /(JSR|BSR).*ESQFUNC_JMPTBL_TEXTDISP_SETRASTF/) h_set_rast_mode = 1
    if (l ~ /(JSR|BSR).*ESQIFF_RUNCOPPERRISETRANSITION/) h_copper_rise = 1
    if (l == "RTS") h_rts = 1
}

END {
    print "HAS_INIT_BITMAP=" h_init_bm
    print "HAS_SET_FONT=" h_set_font
    print "HAS_RESET_HIGHLIGHT=" h_reset_hl
    print "HAS_PRIME_TRANSITION=" h_prime_transition
    print "HAS_UPDATE_HIGHLIGHT=" h_update_hl
    print "HAS_REFRESH_TICK=" h_refresh_tick
    print "HAS_CLEAR_MENU_MODE=" h_clear_menu_mode
    print "HAS_UPDATE_REFRESH_MODE=" h_update_refresh_mode
    print "HAS_DRAW_TOP=" h_draw_top
    print "HAS_OPTIONAL_SAVE=" h_optional_save
    print "HAS_WAIT_CLEAR_BIT0=" h_wait_clear_bit0
    print "HAS_FREE_BRUSHES=" h_free_brushes
    print "HAS_SEED_BANNER=" h_seed_banner
    print "HAS_DRAW_BOTTOM_HELP=" h_draw_bottom
    print "HAS_SET_RAST_MODE=" h_set_rast_mode
    print "HAS_COPPER_RISE=" h_copper_rise
    print "HAS_RTS=" h_rts
}
