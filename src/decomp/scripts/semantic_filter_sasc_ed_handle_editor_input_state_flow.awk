BEGIN {
    h_entry = 0
    h_pending_reinit = 0
    h_initial_cursor_draw = 0
    h_force_text_mode_commit = 0
    h_esc_early_exit = 0
    h_page_down_clamp = 0
    h_menu_dispatch = 0
    h_menu_range_gate = 0
    h_line_page_toggle = 0
    h_mode9_help = 0
    h_insert_ascii = 0
    h_finalize_sync = 0
    h_rts = 0
    esc_help_window = 0
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
    if (l == "") {
        next
    }

    if (esc_help_window > 0) {
        if (l ~ /^BRA(\.[A-Z])? / || l == "RTS") {
            h_esc_early_exit = 1
        }
        esc_help_window--
    }

    if (l ~ /^ED_HANDLEEDITORINPUT:/ || l ~ /^ED_HANDLEEDITORINPUT[A-Z0-9_]*:/) {
        h_entry = 1
    }

    if (l ~ /ED_TEXTMODEREINITPENDINGFLAG/ && l ~ /ED_CURRENTCHAR/) {
        h_pending_reinit = 1
    }

    if (l ~ /(JSR|BSR).*ED_DRAWCURSORCHAR/) {
        h_initial_cursor_draw = 1
    }

    if (l ~ /ED_COMMITCURRENTADEDITS/ || l ~ /ED_DRAWESCMENUBOTTOMHELP/) {
        h_force_text_mode_commit = 1
    }
    if (l ~ /ED_DRAWESCMENUBOTTOMHELP/) {
        esc_help_window = 2
    }

    if (l ~ /ED_TEXTLIMIT/ || l ~ /ED_VIEWPORTOFFSET/ && l ~ /GROUP_AG_JMPTBL_MATH_MULU32/ ||
        l ~ /ED_EDITCURSOROFFSET/ && l ~ /GROUP_AG_JMPTBL_MATH_MULU32/) {
        h_page_down_clamp = 1
    }

    if (l ~ /ED_STATERINGINDEX/ || l ~ /ED_LASTMENUINPUTCHAR/ ||
        l ~ /\\.CASE_NAV_KEY:/ ||
        l ~ /__SWITCH_ED_HANDLEEDITORINPUT/ ||
        l ~ /JMP .*PC,D1\\.W/) {
        h_menu_dispatch = 1
    }

    if (l ~ /#\\$20/ || l ~ /#\\$26/ ||
        l ~ /SUBI\\.W #\\$20,D1/ ||
        l ~ /MOVEQ\\.L #\\$20,D0/ ||
        l ~ /CMPI\\.L #\\$26,D1/) {
        h_menu_range_gate = 1
    }

    if ((l ~ /SETAPEN/ || l ~ /_LVOSETAPEN/) &&
        (l ~ /SETBPEN/ || l ~ /_LVOSETBPEN/ || l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/ || l ~ /DISPLIB_DISPLAYTEXTATPOSITION/)) {
        h_line_page_toggle = 1
    }
    if (l ~ /ED2_STR_PAGE/ || l ~ /ED2_STR_LINE/) {
        h_line_page_toggle = 1
    }

    if ((l ~ /ED_MENUSTATEID/ && l ~ /#\\$9/) ||
        (l ~ /MOVEQ\\.L #\\$9,D0/ && l ~ /ED_MENUSTATEID/) ||
        l ~ /ED_DRAWEDITHELPTEXT/) {
        h_mode9_help = 1
    }

    if (l ~ /ED_LASTKEYCODE/ ||
        l ~ /EDITBUFFERSCRATCH/ ||
        l ~ /EDITBUFFERLIVE/ ||
        l ~ /CASE_INSERT_ASCII_CHAR/ ||
        l ~ /CASEINSERTASCIICHAR/) {
        h_insert_ascii = 1
    }

    if (l ~ /GLOBAL_REF_BOOL_IS_TEXT_OR_CURSO/ && l ~ /ED_CURRENTCHAR/ ||
        l ~ /ED_REDRAWCURSORCHAR/ ||
        l ~ /ED_DRAWCURRENTCOLORINDICATOR/) {
        h_finalize_sync = 1
    }

    if (l == "RTS") {
        h_rts = 1
    }
}

END {
    print "HAS_ENTRY=" h_entry
    print "HAS_PENDING_REINIT=" h_pending_reinit
    print "HAS_INITIAL_CURSOR_DRAW=" h_initial_cursor_draw
    print "HAS_FORCE_TEXT_MODE_COMMIT=" h_force_text_mode_commit
    print "HAS_ESC_EARLY_EXIT=" h_esc_early_exit
    print "HAS_PAGE_DOWN_CLAMP=" h_page_down_clamp
    print "HAS_MENU_DISPATCH=" h_menu_dispatch
    print "HAS_MENU_RANGE_GATE=" h_menu_range_gate
    print "HAS_LINE_PAGE_TOGGLE=" h_line_page_toggle
    print "HAS_MODE9_HELP=" h_mode9_help
    print "HAS_INSERT_ASCII=" h_insert_ascii
    print "HAS_FINALIZE_SYNC=" h_finalize_sync
    print "HAS_RTS=" h_rts
}
