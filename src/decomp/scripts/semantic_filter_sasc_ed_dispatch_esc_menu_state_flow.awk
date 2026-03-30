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

    if (u ~ /^ED_DISPATCHESCMENUSTATE[A-Z0-9_]*:/) {
        mark("ENTRY")
    }

    if (u ~ /ED_STATERINGWRITEINDEX/ && u ~ /ED_STATERINGINDEX/) {
        mark("COMPARE_RING_INDEX")
    }

    if (u ~ /ED_MENUDISPATCHREENTRYGUARD/ &&
        (u ~ /^TST\.L / || u ~ /^MOVE\.L .*ED_MENUDISPATCHREENTRYGUARD/)) {
        mark("CHECK_REENTRY_GUARD")
    }

    if (u ~ /^CLR\.L ED_MENUDISPATCHREENTRYGUARD/) {
        mark("CLEAR_REENTRY_GUARD")
    }

    if ((u ~ /ED_STATERINGTABLE/ && u ~ /ED_LASTKEYCODE/) ||
        (u ~ /ED_STATERINGTABLE/ && prev ~ /ED_STATERINGINDEX/) ||
        (u ~ /ED_LASTKEYCODE/ && prev ~ /ED_STATERINGTABLE/) ||
        u ~ /MOVE\.B .*ED_LASTKEYCODE/) {
        mark("LOAD_LAST_KEY")
    }

    if (u ~ /GLOBAL_UIBUSYFLAG/) {
        mark("CHECK_UI_BUSY")
    }

    if (u ~ /SETAPEN/) {
        mark("SET_APEN")
    }

    if (u ~ /SETBPEN/) {
        mark("SET_BPEN")
    }

    if (u ~ /SETDRMD/) {
        mark("SET_DRMD")
    }

    if ((u ~ /ED_MENUSTATEID/ && u ~ /#\$?19/) ||
        u ~ /CMPI\.[WL] #\$?19,D0/ ||
        u ~ /CMPI\.[WL] #\$?19,D1/) {
        mark("CHECK_MENU_STATE_RANGE")
    }

    if (u ~ /DISPATCH_TABLE/ || u ~ /^__SWITCH_ED_DISPATCHESCMENUSTATE_[0-9]+:/) {
        mark("DISPATCH_TABLE")
    }

    if (u ~ /ED2_HANDLEMENUACTIONS/) {
        mark("CASE_MENU_ACTIONS")
    }

    if (u ~ /ED1_HANDLEESCMENUINPUT/) {
        mark("CASE_ESC_INPUT")
    }

    if (u ~ /ED_HANDLEEDITATTRIBUTESMENU/) {
        mark("CASE_EDIT_ATTR_MENU")
    }

    if (u ~ /ED_HANDLEEDITORINPUT/) {
        mark("CASE_EDITOR_INPUT")
    }

    if (u ~ /ED_HANDLEEDITATTRIBUTESINPUT/) {
        mark("CASE_EDIT_ATTR_INPUT")
    }

    if (u ~ /ED2_HANDLESCROLLSPEEDSELECTION/) {
        mark("CASE_SCROLL_SPEED")
    }

    if (u ~ /ED2_HANDLEDIAGNOSTICSMENUACTIONS/) {
        mark("CASE_DIAGNOSTICS")
    }

    if (u ~ /ED1_UPDATEESCMENUSELECTION/) {
        mark("CASE_UPDATE_SELECTION")
    }

    if (u ~ /ED_ENTERTEXTEDITMODE/) {
        mark("CASE_TEXT_EDIT")
    }

    if (u ~ /ED_HANDLESPECIALFUNCTIONSMENU/) {
        mark("CASE_SPECIAL_FUNCTIONS")
    }

    if (u ~ /ED_SAVEEVERYTHINGTODISK/) {
        mark("CASE_SAVE_ALL")
    }

    if (u ~ /ED_SAVEPREVUEDATATODISK/) {
        mark("CASE_SAVE_PREVUE")
    }

    if (u ~ /ED_LOADTEXTADSFROMDH2/) {
        mark("CASE_LOAD_TEXT_ADS")
    }

    if (u ~ /ED_REBOOTCOMPUTER/) {
        mark("CASE_REBOOT")
    }

    if (u ~ /ED_HANDLEDIAGNOSTICNIBBLEEDIT/) {
        mark("CASE_DIAGNOSTIC_NIBBLE")
    }

    if (u ~ /ED_CAPTUREKEYSEQUENCE/) {
        mark("CASE_CAPTURE_KEY")
    }

    if (u ~ /ADDQ\.[WL] #\$?1,ED_STATERINGINDEX/ ||
        u ~ /ADDQ\.[WL] #\$?1,ED_STATERINGINDEX\(A4\)/) {
        mark("ADVANCE_RING_INDEX")
    }

    if (u ~ /CMPI\.[WL] #\$?14,ED_STATERINGINDEX/ ||
        u ~ /CMPI\.[WL] #\$?14,ED_STATERINGINDEX\(A4\)/) {
        mark("CHECK_RING_WRAP")
    }

    if (u ~ /^CLR\.L ED_STATERINGINDEX/ || u ~ /^CLR\.L ED_STATERINGINDEX\(A4\)/) {
        mark("WRAP_RING_INDEX")
    }

    if ((u ~ /MOVEQ(\.L)? #\$?1,D0/ && prev ~ /ED_STATERINGINDEX/) ||
        u ~ /MOVE\.L #\$?1,ED_MENUDISPATCHREENTRYGUARD/ ||
        u ~ /MOVE\.L D0,ED_MENUDISPATCHREENTRYGUARD/) {
        mark("RESTORE_REENTRY_GUARD")
    }

    if (u == "RTS") {
        mark("RTS")
    }
    prev = u
}

END {
    split("ENTRY COMPARE_RING_INDEX CHECK_REENTRY_GUARD CLEAR_REENTRY_GUARD LOAD_LAST_KEY CHECK_UI_BUSY SET_APEN SET_BPEN SET_DRMD CHECK_MENU_STATE_RANGE DISPATCH_TABLE CASE_MENU_ACTIONS CASE_ESC_INPUT CASE_EDIT_ATTR_MENU CASE_EDITOR_INPUT CASE_EDIT_ATTR_INPUT CASE_SCROLL_SPEED CASE_DIAGNOSTICS CASE_UPDATE_SELECTION CASE_TEXT_EDIT CASE_SPECIAL_FUNCTIONS CASE_SAVE_ALL CASE_SAVE_PREVUE CASE_LOAD_TEXT_ADS CASE_REBOOT CASE_DIAGNOSTIC_NIBBLE CASE_CAPTURE_KEY ADVANCE_RING_INDEX CHECK_RING_WRAP WRAP_RING_INDEX RESTORE_REENTRY_GUARD RTS", ordered, " ")
    out_index = 0
    for (i = 1; i <= length(ordered); i++) {
        if (seen[ordered[i]]) {
            out_index++
            print out_index ":" ordered[i]
        }
    }
}
