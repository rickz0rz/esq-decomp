BEGIN {
    has_entry = 0
    has_diag_guard = 0
    has_setapen = 0
    has_disp_call = 0
    has_restore = 0
    has_rts = 0
}

function t(s, x) {
    x = s
    sub(/;.*/, "", x)
    sub(/^[ \t]+/, "", x)
    sub(/[ \t]+$/, "", x)
    gsub(/[ \t]+/, " ", x)
    return toupper(x)
}

{
    l = t($0)
    if (l == "") next

    if (l ~ /^DISKIO_DRAWTRANSFERERRORMESSAGE/) has_entry = 1
    if (index(l, "ED_DIAGNOSTICSSCREENACTIVE") > 0 && (l ~ /^TST\.W / || l ~ /^TST\.L / || l ~ /^MOVE\.W .*?,D0$/ || l ~ /^MOVE\.L .*?,D0$/)) has_diag_guard = 1
    if (index(l, "_LVOSETAPEN") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_setapen = 1
    if (index(l, "DISPLIB_DISPLAYTEXTATPOSITION") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_disp_call = 1
    if (l ~ /^MOVE\.L \(A7\)\+,D7$/ || l ~ /^MOVEM\.L \(A7\)\+,D7$/) has_restore = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_DIAG_GUARD=" has_diag_guard
    print "HAS_SETAPEN=" has_setapen
    print "HAS_DISP_CALL=" has_disp_call
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
