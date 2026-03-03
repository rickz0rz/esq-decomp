BEGIN {
    has_entry = 0
    has_setapen = 0
    has_setdrmd = 0
    has_availmem = 0
    has_sprintf = 0
    has_display = 0
    has_compute_htc = 0
    has_update_ctrl_h = 0
    has_restore_bitmap = 0
    has_unlk = 0
    has_rts = 0
}

function trim(s, t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_DRAWMEMORYSTATUSSCREEN:/) has_entry = 1
    if (uline ~ /LVOSETAPEN\(A6\)/) has_setapen = 1
    if (uline ~ /LVOSETDRMD\(A6\)/) has_setdrmd = 1
    if (uline ~ /LVOAVAILMEM\(A6\)/) has_availmem = 1
    if (uline ~ /GROUP_AM_JMPTBL_WDISP_SPRINTF/) has_sprintf = 1
    if (uline ~ /ESQPARS_JMPTBL_DISPLIB_DISPLAYTEXTATPOSITION/) has_display = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_COMPUTEHTCMAXVALUES/) has_compute_htc = 1
    if (uline ~ /ESQFUNC_JMPTBL_PARSEINI_UPDATECTRLHDELTAMAX/) has_update_ctrl_h = 1
    if (uline ~ /^MOVE\.L -76\(A5\),4\(A0\)$/) has_restore_bitmap = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SETAPEN=" has_setapen
    print "HAS_SETDRMD=" has_setdrmd
    print "HAS_AVAILMEM=" has_availmem
    print "HAS_SPRINTF=" has_sprintf
    print "HAS_DISPLAY=" has_display
    print "HAS_COMPUTE_HTC=" has_compute_htc
    print "HAS_UPDATE_CTRL_H=" has_update_ctrl_h
    print "HAS_RESTORE_BITMAP=" has_restore_bitmap
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
