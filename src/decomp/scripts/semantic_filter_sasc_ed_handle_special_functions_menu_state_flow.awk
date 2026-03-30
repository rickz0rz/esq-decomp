BEGIN {
    prompt_window = 0
    reboot_window = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

function mark(tag) {
    seen[tag] = 1
}

{
    u = trim($0)
    if (u == "") {
        next
    }

    if (u ~ /^ED_HANDLESPECIALFUNCTIONSMENU[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /(JSR|BSR).*ED_GETESCMENUACTIONCODE/) {
        mark("GET_ACTION")
    }

    if (u ~ /CMPI\.[WL] #\$?8,D0/ || u ~ /CMPI\.[WL] #\$?8,D1/ ||
        u ~ /__SWITCH_ED_HANDLESPECIALFUNCTIONSMENU/ ||
        u ~ /DISPATCH_TABLE/ || u ~ /JMP .*PC,D0\.W/ || u ~ /JMP .*PC,D1\.W/) {
        mark("DISPATCH_GATE")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWESCMENUBOTTOMHELP/) {
        mark("CASE_HELP")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWAREYOUSUREPROMPT/) {
        prompt_window = 8
    } else if (prompt_window > 0) {
        prompt_window--
    }

    if (prompt_window > 0 && u ~ /ED2_STR_ALL_DATA_IS_TO_BE_SAVED/) {
        mark("CASE_SAVE_ALL_PROMPT")
    }
    if (prompt_window > 0 && u ~ /ED2_STR_TV_GUIDE_DATA_IS_TO_BE_S/) {
        mark("CASE_SAVE_TV_GUIDE_PROMPT")
    }
    if (prompt_window > 0 && u ~ /ED2_STR_TEXT_ADS_WILL_BE_LOADED/) {
        mark("CASE_LOAD_TEXT_ADS_PROMPT")
    }
    if (prompt_window > 0 && u ~ /GLOBAL_STR_COMPUTER_WILL_RESET/) {
        mark("CASE_REBOOT_PROMPT")
        reboot_window = 8
    }

    if (reboot_window > 0 && u ~ /GLOBAL_STR_GO_OFF_AIR_FOR_1_2_MI/) {
        mark("CASE_REBOOT_SECOND_LINE")
    }
    if (reboot_window > 0) {
        reboot_window--
    }

    if (u ~ /MOVE\.B #\$?B,ED_MENUSTATEID/) {
        mark("STATE_0B")
    }
    if (u ~ /MOVE\.B #\$?C,ED_MENUSTATEID/) {
        mark("STATE_0C")
    }
    if (u ~ /MOVE\.B #\$?D,ED_MENUSTATEID/) {
        mark("STATE_0D")
    }
    if (u ~ /MOVE\.B #\$?E,ED_MENUSTATEID/) {
        mark("STATE_0E")
    }
    if (u ~ /MOVE\.B #\$?F,ED_MENUSTATEID/) {
        mark("STATE_0F")
    }

    if (u ~ /SUBQ\.[WL] #\$?1,ED_EDITCURSOROFFSET/ ||
        u ~ /SUBQ\.[WL] #\$?1,ED_EDITCURSOROFFSET\(A4\)/) {
        mark("PREV_DECREMENT")
    }
    if (u ~ /MOVEQ(\.L)? #\$?3,D0/ || u ~ /MOVE\.L #\$?3,ED_EDITCURSOROFFSET/) {
        mark("PREV_WRAP_TO_3")
    }

    if (u ~ /ADDQ\.[WL] #\$?1,ED_EDITCURSOROFFSET/ ||
        u ~ /ADDQ\.[WL] #\$?1,ED_EDITCURSOROFFSET\(A4\)/) {
        mark("NEXT_INCREMENT")
    }
    if (u ~ /CLR\.L ED_EDITCURSOROFFSET/ || u ~ /CLR\.L ED_EDITCURSOROFFSET\(A4\)/) {
        mark("NEXT_WRAP_TO_0")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?2,D0/ || u ~ /CMPI\.[WL] #\$?2,D0/ || u ~ /CMPI\.[WL] #\$?2,D1/) &&
        (u ~ /ED_EDITCURSOROFFSET/ || prev ~ /ED_EDITCURSOROFFSET/)) {
        mark("COLOR_BARS_CURSOR_GUARD")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/ || u ~ /(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/) {
        mark("REDRAW_MENU_HIGHLIGHT")
    }
    if (u ~ /(JSR|BSR).*ED_DRAWSPECIALFUNCTIONSMENU/ || u ~ /(JSR|BSR).*ED_DRAWSPECIALMENUSELECTION/) {
        mark("REDRAW_SPECIAL_MENU")
    }

    if (u ~ /(JSR|BSR).*_LVOSETAPEN/ || u ~ /(JSR|BSR).*ED_DRAWCOLORBARS/) {
        mark("DRAW_COLOR_BARS")
    }
    if (u ~ /(JSR|BSR).*_LVORECTFILL/ || u ~ /(JSR|BSR).*ED_DRAWCOLORBARS/) {
        mark("DRAW_COLOR_RECTS")
    }
    if (u ~ /^CLR\.L ED_TEMPCOPYOFFSET/ || u ~ /^CLR\.L ED_TEMPCOPYOFFSET\(A4\)/) {
        mark("CLEAR_TEMP_COPY")
    }
    if (u ~ /(JSR|BSR).*ED_DRAWDIAGNOSTICREGISTERVALUES/) {
        mark("DRAW_DIAG_REGS")
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev = u
}

END {
    split("ENTRY GET_ACTION DISPATCH_GATE CASE_HELP CASE_SAVE_ALL_PROMPT CASE_SAVE_TV_GUIDE_PROMPT CASE_LOAD_TEXT_ADS_PROMPT CASE_REBOOT_PROMPT CASE_REBOOT_SECOND_LINE STATE_0B STATE_0C STATE_0D STATE_0E STATE_0F PREV_DECREMENT PREV_WRAP_TO_3 NEXT_INCREMENT NEXT_WRAP_TO_0 COLOR_BARS_CURSOR_GUARD REDRAW_MENU_HIGHLIGHT REDRAW_SPECIAL_MENU DRAW_COLOR_BARS DRAW_COLOR_RECTS CLEAR_TEMP_COPY DRAW_DIAG_REGS RTS", ordered, " ")
    for (i = 1; i <= length(ordered); i++) {
        print ordered[i] "=" (ordered[i] in seen ? 1 : 0)
    }
}
