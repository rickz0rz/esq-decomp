BEGIN {
    has_mode7 = 0
    has_diag_active = 0
    has_bottom_bg = 0
    has_display = 0
    has_sprintf = 0
    has_disk_usage = 0
    has_disk_errors = 0
    has_diag_text = 0
    has_setapen = 0
    has_continue_prompt = 0
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

    if (l ~ /^MOVE\.B #\$?7,ED_MENUSTATEID(\(A[0-7]\))?$/ || l ~ /^MOVE\.B #\$?07,ED_MENUSTATEID(\(A[0-7]\))?$/ || l ~ /^MOVE\.B D[0-7],ED_MENUSTATEID(\(A[0-7]\))?$/) has_mode7 = 1
    if (l ~ /^MOVE\.W #\$?1,ED_DIAGNOSTICSSCREENACTIVE(\(A[0-7]\))?$/ || l ~ /^MOVEQ(\.L)? #\$?1,D0$/) has_diag_active = 1

    if (l ~ /(JSR|BSR).*ED_DRAWBOTTOMHELPBARBACKGROUND/) has_bottom_bg = 1
    if (l ~ /(JSR|BSR).*DISPLIB_DISPLAYTEXTATPOSITION/) has_display = 1
    if (l ~ /(JSR|BSR).*GROUP_AM_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (l ~ /(JSR|BSR).*DISKIO_QUERYDISKUSAGEPERCENTANDS/) has_disk_usage = 1
    if (l ~ /(JSR|BSR).*DISKIO_QUERYVOLUMESOFTERRORCOUNT/) has_disk_errors = 1
    if (l ~ /(JSR|BSR).*ED_DRAWDIAGNOSTICMODETEXT/) has_diag_text = 1
    if (l ~ /(JSR|BSR).*_LVOSETAPEN/) has_setapen = 1
    if (l ~ /GLOBAL_STR_PUSH_ANY_KEY_TO_CONTI/ || l ~ /GLOBAL_STR_PUSH_ANY_KEY_TO_CONTINUE_2/) has_continue_prompt = 1
    if (l == "RTS") has_rts = 1
}

END {
    print "HAS_MODE7=" has_mode7
    print "HAS_DIAG_ACTIVE=" has_diag_active
    print "HAS_BOTTOM_BG=" has_bottom_bg
    print "HAS_DISPLAY=" has_display
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_DISK_USAGE=" has_disk_usage
    print "HAS_DISK_ERRORS=" has_disk_errors
    print "HAS_DIAG_TEXT=" has_diag_text
    print "HAS_SETAPEN=" has_setapen
    print "HAS_CONTINUE_PROMPT=" has_continue_prompt
    print "HAS_RTS=" has_rts
}
