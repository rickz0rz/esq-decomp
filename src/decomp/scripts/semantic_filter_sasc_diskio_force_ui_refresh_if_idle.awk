BEGIN {
    has_entry = 0
    has_guard = 0
    has_setflag = 0
    has_refresh_call = 0
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

    if (l ~ /^DISKIO_FORCEUIREFRESHIFIDLE:/) has_entry = 1
    if (index(l, "GLOBAL_UIBUSYFLAG") > 0 && (l ~ /^TST\.W / || l ~ /^TST\.L / || l ~ /^MOVE\.W .*?,D0$/ || l ~ /^MOVE\.L .*?,D0$/)) has_guard = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && (index(l, "#$100") > 0 || index(l, "#256") > 0)) has_setflag = 1
    if ((index(l, "GROUP_AG_JMPTBL_TEXTDISP_RESETSELECTIONANDREFRESH") > 0 || index(l, "GROUP_AG_JMPTBL_TEXTDISP_RESETSE") > 0) && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_refresh_call = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_SETFLAG=" has_setflag
    print "HAS_REFRESH_CALL=" has_refresh_call
    print "HAS_RTS=" has_rts
}
