BEGIN {
    has_entry = 0
    has_load = 0
    has_tst = 0
    has_bool = 0
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

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_entry = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_entry = 1

    if (l ~ /10\(A7\)/ || l ~ /8\(A7\)/ || l ~ /D7/ || l ~ /D0/) has_load = 1
    if (l ~ /TST\.W/ || l ~ /CMP\.W #\$?0/ || l ~ /BEQ/ || l ~ /BNE/) has_tst = 1
    if (l ~ /SEQ D0/ || l ~ /NEG\.B D0/ || l ~ /EXT\.L D0/ || l ~ /MOVEQ\.L #\$?FF,D0/ || l ~ /MOVEQ\.L #\$?0,D0/ || l ~ /MOVE\.L #\$?FFFFFFFF,D0/ || l ~ /SNE D0/) has_bool = 1
    if (l ~ /MOVE\.L \(A7\)\+,D7/ || l ~ /MOVEM\.L \(A7\)\+/ || l ~ /ADDQ\.W #\$?4,A7/) has_restore = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOAD=" has_load
    print "HAS_TST=" has_tst
    print "HAS_BOOL=" has_bool
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
