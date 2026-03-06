BEGIN {
    has_help_panels = 0
    has_setdrmd = 0
    has_setapen = 0
    has_display = 0
    has_str1 = 0
    has_str2 = 0
    has_str3 = 0
    has_clear_cursor = 0
    has_draw_main = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    gsub(/[ \t]+/, " ", t)
    return toupper(t)
}

{
    l = trim($0)
    if (l == "") next

    if (l ~ /(JSR|BSR).*ED_DRAWHELPPANELS/) has_help_panels = 1
    if (l ~ /(JSR|BSR).*_LVOSETDRMD/) has_setdrmd = 1
    if (l ~ /(JSR|BSR).*_LVOSETAPEN/) has_setapen = 1
    if (l ~ /(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/) has_display = 1
    if (l ~ /GLOBAL_STR_PUSH_ESC_TO_RESUME/) has_str1 = 1
    if (l ~ /GLOBAL_STR_PUSH_RETURN_TO_ENTER_SELECTION_1/ || l ~ /GLOBAL_STR_PUSH_RETURN_TO_ENTER_/ ) has_str2 = 1
    if (l ~ /GLOBAL_STR_PUSH_ANY_KEY_TO_SELECT_1/ || l ~ /GLOBAL_STR_PUSH_ANY_KEY_TO_SELEC/ ) has_str3 = 1
    if (l ~ /^CLR\.L ED_EDITCURSOROFFSET(\(A[0-7]\))?$/ || l ~ /^MOVE\.L #\$?0,ED_EDITCURSOROFFSET(\(A[0-7]\))?$/) has_clear_cursor = 1
    if (l ~ /(JSR|BSR).*ED_DRAWESCMAINMENUTEXT/) has_draw_main = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_HELP_PANELS=" has_help_panels
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_SETAPEN=" has_setapen
    print "HAS_DISPLAY=" has_display
    print "HAS_STR1=" has_str1
    print "HAS_STR2=" has_str2
    print "HAS_STR3=" has_str3
    print "HAS_CLEAR_CURSOR=" has_clear_cursor
    print "HAS_DRAW_MAIN=" has_draw_main
    print "HAS_RTS=" has_rts
}
