BEGIN {
    has_entry = 0
    has_guard = 0
    has_disable = 0
    has_enable = 0
    has_mode_reset = 0
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

    if (l ~ /^DISKIO_RESETCTRLINPUTSTATEIFIDLE:/) has_entry = 1
    if (index(l, "GLOBAL_UIBUSYFLAG") > 0 && (l ~ /^TST\.W / || l ~ /^TST\.L / || l ~ /^MOVE\.W .*?,D0$/ || l ~ /^MOVE\.L .*?,D0$/)) has_guard = 1
    if (index(l, "_LVODISABLE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_disable = 1
    if (index(l, "_LVOENABLE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_enable = 1
    if (index(l, "ESQPARS2_READMODEFLAGS") > 0 && (index(l, ",ESQPARS2_READMODEFLAGS") > 0 || index(l, "ESQPARS2_READMODEFLAGS(A4)") > 0)) has_mode_reset = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_GUARD=" has_guard
    print "HAS_DISABLE=" has_disable
    print "HAS_ENABLE=" has_enable
    print "HAS_MODE_RESET=" has_mode_reset
    print "HAS_RTS=" has_rts
}
