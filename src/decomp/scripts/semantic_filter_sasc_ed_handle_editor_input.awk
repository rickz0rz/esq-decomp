BEGIN {
    h_entry=0
    h_nav_menu_dispatch=0
    h_nav_menu_range_gate=0
    h_cursor_draw=0
    h_mode_reinit=0
    h_char_adjust=0
    h_toggle_text_cursor=0
    h_delete_shift=0
    h_insert_shift=0
    h_nav_ring=0
    h_nav_mode=0
    h_spacing=0
    h_clear=0
    h_fill=0
    h_alt_ad=0
    h_finalize_sync=0
    h_color_indicator=0
    h_commit=0
    h_apply_active=0
    h_help=0
    h_page_line_toggle=0
    h_cursor_sync_line_page=0
    h_insert_row_shift=0
    h_delete_row_shift=0
    h_fill_row_chars=0
    h_delete_page_refresh=0
    h_insert_char=0
    h_mode9_help=0
    h_toggle_line_page_mode=0
    h_nav_dirs=0
    h_esc_commit_help=0
    h_esc_early_exit=0
    h_insert_ascii=0
    h_finalize_branch=0
    h_page_down=0
    h_consts=0
    h_rts=0
    esc_help_window=0
}

function norm(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l=norm($0)
    if (l=="") next

    if (esc_help_window > 0) {
        if (l ~ /^BRA(\.[A-Z])? / || l == "RTS") h_esc_early_exit=1
        esc_help_window--
    }

    if (l ~ /^ED_HANDLEEDITORINPUT:/ || l ~ /^ED_HANDLEEDITORINPUT[A-Z0-9_]*:/) h_entry=1
    if ((l ~ /ED_STATERINGTABLE/ && l ~ /ED_LASTMENUINPUTCHAR/) || l ~ /__SWITCH_ED_HANDLEEDITORINPUT_/ || l ~ /JMP .*PC,D1\.W/ || l ~ /\.CASE_NAV_KEY:/) h_nav_menu_dispatch=1
    if (l ~ /SUBI\.W #\$20,D1/ || l ~ /MOVEQ\.L #\$20,D0/ || l ~ /SUB\.L D0,D1/ || l ~ /CMPI\.L #\$26,D1/ || l ~ /SUBI\.W #\$1C,D0/ || l ~ /ADD\.W D1,D1/) h_nav_menu_range_gate=1
    if (l ~ /(JSR|BSR).*ED_DRAWCURSORCHAR/) h_cursor_draw=1
    if (l ~ /ED_TEXTMODEREINITPENDINGFLAG/ || l ~ /BOOLISTEXTORCURSOR/) h_mode_reinit=1
    if (l ~ /EXTRACTHIGHNIBBLE/ || l ~ /EXTRACTLOWNIBBLE/ || l ~ /EXTRACTH/ || l ~ /EXTRACTL/ || l ~ /PACKNIBBLESTOBYTE/ || l ~ /MERGEHIGHLOWNIBBLES/ || l ~ /PACKNIBBLESTO/ || l ~ /MERGEHIGHLOWN/) h_char_adjust=1
    if (l ~ /SETAPEN1BPEN6DRMD1DRAW/ || l ~ /SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_/ || l ~ /BOOLISTEXTORCURSOR/) h_toggle_text_cursor=1
    if (l ~ /SCRATCHSHIFTBASE/ || l ~ /EDITBUFFERSCRATCHSHIFTBASE/) h_delete_shift=1
    if (l ~ /LIVESHIFTBASE/ || l ~ /EDITBUFFERLIVESHIFTBASE/) h_insert_shift=1
    if (l ~ /ED_STATERINGINDEX/ || l ~ /ED_STATERINGTABLE/ || l ~ /ED_LASTMENUINPUTCHAR/) h_nav_ring=1
    if (l ~ /DISPLIB_DISPLAYTEXTATPOSITION/ || l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/) h_nav_mode=1
    if (l ~ /TRANSFORMLINESPACING_MODE1/ || l ~ /TRANSFORMLINESPACING_MODE2/ || l ~ /TRANSFORMLINESPACING_MODE3/) h_spacing=1
    if (l ~ /EDITBUFFERSCRATCH/ && l ~ /#\$20/ || l ~ /ED_REDRAWALLROWS/) h_clear=1
    if (l ~ /ED_CURRENTCHAR/ && l ~ /ED_REDRAWROW/ || l ~ /ED_REDRAWALLROWS/) h_fill=1
    if (l ~ /ED_NEXTADNUMBER/ || l ~ /ED_PREVADNUMBER/) h_alt_ad=1
    if (l ~ /SYNC_CURRENT_CHAR/ || l ~ /ED_CURRENTCHAR/ && l ~ /EDITCURSOROFFSET/) h_finalize_sync=1
    if (l ~ /ED_DRAWCURRENTCOLORINDICATOR/ || l ~ /ED_REDRAWCURSORCHAR/) h_color_indicator=1
    if (l ~ /ED_COMMITCURRENTADEDITS/) h_commit=1
    if (l ~ /ED_APPLYACTIVEFLAGTOADDATA/) h_apply_active=1
    if (l ~ /ED_DRAWESCMENUBOTTOMHELP/ || l ~ /ED_DRAWEDITHELPTEXT/) h_help=1
    if ((l ~ /GLOBAL_REF_BOOL_IS_LINE_OR_PAGE/ && l ~ /ED_EDITCURSOROFFSET/) || (l ~ /ED_VIEWPORTOFFSET/ && l ~ /ED_EDITCURSOROFFSET/) || l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/) h_cursor_sync_line_page=1
    if ((l ~ /EDITBUFFERSCRATCH/ && l ~ /EDITBUFFERLIVE/ && l ~ /ED_REDRAWALLROWS/) || (l ~ /ED_BLOCKOFFSET/ && l ~ /MATH_MULU32/) || (l ~ /#\$20/ && l ~ /ED_CURRENTCHAR/)) h_insert_row_shift=1
    if ((l ~ /EDITBUFFERSCRATCHSHIFTBASE/ && l ~ /EDITBUFFERLIVESHIFTBASE/) || (l ~ /ED_BLOCKOFFSET/ && l ~ /MATH_MULU32/) || (l ~ /#\$20/ && l ~ /ED_CURRENTCHAR/ && l ~ /ED_REDRAWALLROWS/)) h_delete_row_shift=1
    if ((l ~ /ED_CURRENTCHAR/ && l ~ /EDITBUFFERLIVE/) || (l ~ /ED_REDRAWROW/ && l ~ /ED_REDRAWALLROWS/)) h_fill_row_chars=1
    if ((l ~ /EDITBUFFERLIVEINDEXBASEMINUS1/ && l ~ /ED_TEMPCOPYOFFSET/) || (l ~ /EDITBUFFERSCRATCHINDEXBASEMINUS1/ && l ~ /ED_BLOCKOFFSET/) || l ~ /ED_DRAWCURSORCHAR/) h_delete_page_refresh=1
    if (l ~ /ED_EDITBUFFERSCRATCHSHIFTBASE/ || l ~ /ED_EDITBUFFERLIVESHIFTBASE/ || l ~ /SCRATCHSHIFTBASE/ || l ~ /LIVESHIFTBASE/) h_insert_char=1
    if ((l ~ /ED_MENUSTATEID/ && l ~ /ED_DRAWEDITHELPTEXT/) || l ~ /MOVE\.B #\$9,ED_MENUSTATEID/ || l ~ /MOVE\.B #\$9,ED_MENUSTATEID\(A4\)/) h_mode9_help=1
    if ((l ~ /SETAPEN/ || l ~ /_LVOSETAPEN/) && (l ~ /SETBPEN/ || l ~ /_LVOSETBPEN/) || (l ~ /ED2_STR_PAGE/ && l ~ /ED2_STR_LINE/) || (l ~ /BOOLISLINEORPAGE/ && l ~ /MATH_DIVS32/)) h_toggle_line_page_mode=1
    if ((l ~ /ED_EDITCURSOROFFSET/ && (l ~ /#40/ || l ~ /#\$28/)) || l ~ /MOVEQ #40/ || l ~ /MOVEQ\.L #\$27/ || l ~ /MOVEQ\.L #\$28/ || l ~ /ADDQ\.L #1,ED_EDITCURSOROFFSET/ || l ~ /ADDQ\.L #\$1,ED_EDITCURSOROFFSET/ || l ~ /SUBQ\.L #1,ED_EDITCURSOROFFSET/ || l ~ /SUBQ\.L #\$1,ED_EDITCURSOROFFSET/) h_nav_dirs=1
    if (l ~ /ED_COMMITCURRENTADEDITS/ || l ~ /ED_DRAWESCMENUBOTTOMHELP/ || l ~ /TEXTMODEREINITPENDINGFLAG/ && l ~ /MOVEL/) h_esc_commit_help=1
    if (l ~ /ED_DRAWESCMENUBOTTOMHELP/) esc_help_window=2
    if (l ~ /#25/ || l ~ /#\$19/ || l ~ /EDITBUFFERSCRATCH/ && l ~ /ED_LASTKEYCODE/ || l ~ /CASEINSERTASCIICHAR/) h_insert_ascii=1
    if (l ~ /SYNCCURRENTCHARANDMAYBEDRAW/ || l ~ /ED_REDRAWCURSORCHAR/ || l ~ /ED_DRAWCURRENTCOLORINDICATOR/) h_finalize_branch=1
    if ((l ~ /ED_TEXTLIMIT/ && (l ~ /ED_EDITCURSOROFFSET/ || l ~ /ED_VIEWPORTOFFSET/)) || (l ~ /GROUP_AG_JMPTBL_MATH_MULU32/ && l ~ /ED_TEXTLIMIT/) || l ~ /MOVEQ #40/ || l ~ /MOVEQ\.L #\$28/) h_page_down=1
    if (l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/ || l ~ /BOOLISLINEORPAGE/) h_page_line_toggle=1
    if (l ~ /#\$80/ || l ~ /#128/ || l ~ /#\$6C/ || l ~ /#108/ || l ~ /#\$35/ || l ~ /#53/ || l ~ /#\$36/ || l ~ /#54/ || l ~ /#\$20/ || l ~ /#32/ || l ~ /#\$26/ || l ~ /#38/) h_consts=1
    if (l == "RTS") h_rts=1
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_NAV_MENU_DISPATCH=" h_nav_menu_dispatch
    print "HAS_NAV_MENU_RANGE_GATE=" h_nav_menu_range_gate
    print "HAS_CURSOR_DRAW=" h_cursor_draw
    print "HAS_MODE_REINIT=" h_mode_reinit
    print "HAS_CHAR_ADJUST=" h_char_adjust
    print "HAS_TOGGLE_TEXT_CURSOR=" h_toggle_text_cursor
    print "HAS_DELETE_SHIFT=" h_delete_shift
    print "HAS_INSERT_SHIFT=" h_insert_shift
    print "HAS_NAV_RING=" h_nav_ring
    print "HAS_NAV_MODE=" h_nav_mode
    print "HAS_SPACING_TRANSFORMS=" h_spacing
    print "HAS_CLEAR_PATH=" h_clear
    print "HAS_FILL_PATH=" h_fill
    print "HAS_ALT_AD_NAV=" h_alt_ad
    print "HAS_FINALIZE_SYNC=" h_finalize_sync
    print "HAS_COLOR_INDICATOR=" h_color_indicator
    print "HAS_COMMIT=" h_commit
    print "HAS_APPLY_ACTIVE=" h_apply_active
    print "HAS_HELP_PATH=" h_help
    print "HAS_CURSOR_SYNC_LINE_PAGE=" h_cursor_sync_line_page
    print "HAS_INSERT_ROW_SHIFT=" h_insert_row_shift
    print "HAS_DELETE_ROW_SHIFT=" h_delete_row_shift
    print "HAS_FILL_ROW_CHARS=" h_fill_row_chars
    print "HAS_DELETE_PAGE_REFRESH=" h_delete_page_refresh
    print "HAS_INSERT_CHAR=" h_insert_char
    print "HAS_MODE9_HELP=" h_mode9_help
    print "HAS_TOGGLE_LINE_PAGE_MODE=" h_toggle_line_page_mode
    print "HAS_NAV_DIRS=" h_nav_dirs
    print "HAS_ESC_COMMIT_HELP=" h_esc_commit_help
    print "HAS_ESC_EARLY_EXIT=" h_esc_early_exit
    print "HAS_INSERT_ASCII_PATH=" h_insert_ascii
    print "HAS_FINALIZE_BRANCH=" h_finalize_branch
    print "HAS_PAGE_DOWN=" h_page_down
    print "HAS_PAGE_LINE_TOGGLE=" h_page_line_toggle
    print "HAS_KEY_CONSTS=" h_consts
    print "HAS_RTS=" h_rts
}
