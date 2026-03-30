function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

function mark(tag) {
    seen[tag] = 1
}

{
    line = trim($0)
    if (line == "") {
        next
    }

    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /^ED1_HANDLEESCMENUINPUT[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /(JSR|BSR).*ED_GETESCMENUACTIONCODE/) {
        mark("GET_ACTION")
    }

    if (u ~ /CMPI?\.[WL] #\$?9,D0/ || u ~ /CMPI?\.[WL] #\$?9,D7/) {
        mark("CHECK_ACTION_RANGE")
    }

    if (u ~ /DISPATCH_TABLE/ || u ~ /^__SWITCH_ED1_HANDLEESCMENUINPUT_[0-9]+:/) {
        mark("DISPATCH_TABLE")
    }

    if (u ~ /ED1_ENTERESCMENU_AFTERVERSIONTEX/) {
        mark("CASE_SHOW_VERSION")
    }

    if (u ~ /ED_DIAGTEXTMODECHAR/ && prev ~ /#\$?4C,D1/) {
        mark("CHECK_LOCAL_EDIT_MODE")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?1,D6/ || u ~ /MOVE\.L #\$?1,D6/) &&
        prev ~ /CHECK_LOCAL_EDIT_MODE/) {
        mark("SET_LOCAL_EDIT_ERROR")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWADNUMBERPROMPT/) {
        mark("DRAW_AD_PROMPT")
    }

    if (u ~ /MOVE\.B #\$?2,ED_MENUSTATEID/ || u ~ /MOVE\.L #\$?2,ED_MENUSTATEID/) {
        mark("SET_STATE2")
    }

    if (u ~ /MOVE\.B #\$?3,ED_MENUSTATEID/ || u ~ /MOVE\.L #\$?3,ED_MENUSTATEID/) {
        mark("SET_STATE3")
    }

    if (u ~ /MOVE\.B #\$?6,ED_MENUSTATEID/ || u ~ /MOVE\.L #\$?6,ED_MENUSTATEID/) {
        mark("SET_STATE6")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWDIAGNOSTICMODEHELPTEXT/) {
        mark("DRAW_DIAG_HELP")
    }

    if (u ~ /ED_SAVEDSCROLLSPEEDINDEX/ && u ~ /ED_EDITCURSOROFFSET/) {
        mark("LOAD_SCROLL_SPEED")
    }

    if (u ~ /PEA \(\$?9\)\.W/ || u ~ /PEA 9\.W/) {
        mark("PUSH_SCROLL_MENU_INDEX")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWMENUSELECTIONHIGHLIGHT/) {
        mark("DRAW_MENU_HIGHLIGHT")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWSCROLLSPEEDMENUTEXT/) {
        mark("DRAW_SCROLL_MENU")
    }

    if (u ~ /(JSR|BSR).*ED1_DRAWDIAGNOSTICSSCREEN/) {
        mark("DRAW_DIAGNOSTICS")
    }

    if (u ~ /MOVE\.B #\$?A,ED_MENUSTATEID/ || u ~ /MOVE\.L #\$?A,ED_MENUSTATEID/) {
        mark("SET_STATEA")
    }

    if (u ~ /^CLR\.L ED_EDITCURSOROFFSET/ || u ~ /^MOVEQ(\.L)? #\$?0,D0$/) {
        if (prev ~ /DRAW_DIAG_HELP/ || prev ~ /SET_STATEA/) {
            mark("CLEAR_CURSOR_OFFSET")
        }
    }

    if (u ~ /PEA \(\$?4\)\.W/ || u ~ /PEA 4\.W/) {
        if (!seen["SET_APEN_ERROR"]) {
            mark("PUSH_SPECIAL_MENU_INDEX")
        }
    }

    if (u ~ /(JSR|BSR).*ED_DRAWSPECIALFUNCTIONSMENU/) {
        mark("DRAW_SPECIAL_MENU")
    }

    if (u ~ /MOVE\.B #\$?8,ED_MENUSTATEID/ || u ~ /MOVE\.L #\$?8,ED_MENUSTATEID/) {
        mark("SET_STATE8")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/) {
        mark("DRAW_BOTTOM_HELP")
    }

    if (u ~ /ESQ_SHUTDOWNREQUESTEDFLAG/ &&
        (u ~ /#\$?1/ || prev ~ /#\$?1,D0/ || prev ~ /#\$?1,D1/)) {
        mark("SET_SHUTDOWN_FLAG")
        in_adjust_tail = 1
    }

    if ((u ~ /MOVEQ(\.L)? #\$?5,D0/ || u ~ /MOVEQ(\.L)? #\$?5,D5/) &&
        in_adjust_tail && !seen["DRAW_ESC_MAIN_MENU"]) {
        mark("ADJUST_STEP5")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?1,D0/ || u ~ /MOVEQ(\.L)? #\$?1,D5/) &&
        in_adjust_tail && !seen["DRAW_ESC_MAIN_MENU"]) {
        mark("ADJUST_STEP1")
    }

    if (u ~ /ED_EDITCURSOROFFSET/ && (u ~ /^ADD\.L / || u ~ /^MOVE\.L .*ED_EDITCURSOROFFSET/)) {
        mark("UPDATE_CURSOR_OFFSET")
    }

    if (u ~ /MOVEQ(\.L)? #\$?6,D1/ || u ~ /PEA \(\$?6\)\.W/ || u ~ /PEA 6\.W/) {
        mark("PREPARE_MOD6")
    }

    if ((u ~ /(JSR|BSR).*(ESQIFF_JMPTBL_MATH_DIVS32|_CXD[0-9A-F]+)/ || u ~ /(JSR|BSR).*MATH_DIVS32/) &&
        seen["PREPARE_MOD6"]) {
        mark("WRAP_CURSOR_MOD6")
    }

    if (u ~ /(JSR|BSR).*ED_DRAWESCMAINMENUTEXT/) {
        mark("DRAW_ESC_MAIN_MENU")
        in_adjust_tail = 0
    }

    if (u ~ /^TST\.[BLW] D6/ || u ~ /^TST\.[BLW] D6$/ || u ~ /^TST\.L D6/) {
        mark("CHECK_ERROR_FLAG")
    }

    if ((u ~ /PEA \(\$?4\)\.W/ || u ~ /PEA 4\.W/ || u ~ /MOVEQ(\.L)? #\$?4,D0/) &&
        (seen["CHECK_ERROR_FLAG"] || prev ~ /CHECK_ERROR_FLAG/)) {
        mark("SET_APEN_ERROR")
    }

    if (u ~ /(JSR|BSR).*_LVOSETAPEN/) {
        if (!seen["SET_APEN_ERROR_DONE"] && seen["SET_APEN_ERROR"]) {
            mark("SET_APEN_ERROR_DONE")
        } else {
            mark("RESTORE_APEN")
        }
    }

    if (u ~ /ED2_STR_LOCAL_EDIT_NOT_AVAILABLE/ || u ~ /(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/) {
        if (seen["SET_APEN_ERROR_DONE"]) {
            mark("DRAW_LOCAL_EDIT_ERROR")
        }
    }

    if (u == "RTS") {
        mark("RTS")
    }

    prev = u
}

END {
    split("ENTRY GET_ACTION CHECK_ACTION_RANGE DISPATCH_TABLE CASE_SHOW_VERSION CHECK_LOCAL_EDIT_MODE SET_LOCAL_EDIT_ERROR DRAW_AD_PROMPT SET_STATE2 SET_STATE3 SET_STATE6 DRAW_DIAG_HELP LOAD_SCROLL_SPEED PUSH_SCROLL_MENU_INDEX DRAW_MENU_HIGHLIGHT DRAW_SCROLL_MENU DRAW_DIAGNOSTICS SET_STATEA CLEAR_CURSOR_OFFSET PUSH_SPECIAL_MENU_INDEX DRAW_SPECIAL_MENU SET_STATE8 DRAW_BOTTOM_HELP SET_SHUTDOWN_FLAG ADJUST_STEP5 ADJUST_STEP1 UPDATE_CURSOR_OFFSET PREPARE_MOD6 WRAP_CURSOR_MOD6 DRAW_ESC_MAIN_MENU CHECK_ERROR_FLAG SET_APEN_ERROR SET_APEN_ERROR_DONE DRAW_LOCAL_EDIT_ERROR RESTORE_APEN RTS", ordered, " ")
    out_index = 0
    for (i = 1; i <= length(ordered); i++) {
        if (seen[ordered[i]]) {
            out_index++
            print out_index ":" ordered[i]
        }
    }
}
