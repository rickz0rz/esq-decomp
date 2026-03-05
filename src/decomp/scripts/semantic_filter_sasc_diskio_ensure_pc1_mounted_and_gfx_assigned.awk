BEGIN {
    has_entry = 0
    has_save = 0
    has_guard = 0
    has_setflag = 0
    has_execute = 0
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

    if (l ~ /^DISKIO_ENSUREPC1MOUNTEDANDGFXASSIGNED:/ || l ~ /^DISKIO_ENSUREPC1MOUNTEDANDGFXASS/) has_entry = 1
    if (l ~ /^MOVEM\.L D2-D3,-\(A7\)$/ || l ~ /^MOVEM\.L D2\/D3,-\(A7\)$/ || l ~ /^MOVEM\.L \(A7\)\+,D2-D3$/ || l ~ /^MOVEM\.L \(A7\)\+,D2\/D3$/ || l ~ /^LEA \$[0-9A-F]+\(A7\),A7$/) has_save = 1
    if (index(l, "DISKIO_PC1MOUNTASSIGNFLAG") > 0 && (l ~ /^TST\.W / || l ~ /^TST\.L / || l ~ /^MOVE\.W .*?,D0$/ || l ~ /^MOVE\.L .*?,D0$/)) has_guard = 1
    if (index(l, "DISKIO_PC1MOUNTASSIGNFLAG") > 0 && (index(l, "#1,") > 0 || index(l, "#$1,") > 0 || index(l, "#$0001,") > 0)) has_setflag = 1
    if (index(l, "_LVOEXECUTE") > 0 && (l ~ /^JSR / || l ~ /^BSR(\.[A-Z]+)? /)) has_execute = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_GUARD=" has_guard
    print "HAS_SETFLAG=" has_setflag
    print "HAS_EXECUTE=" has_execute
    print "HAS_RTS=" has_rts
}
