BEGIN {
    has_label = 0
    has_core = 0
    has_save = 0
    has_null_guard = 0
    has_btst0 = 0
    has_btst2 = 0
    has_true = 0
    has_false = 0
    has_restore = 0
    has_rts = 0
    saw_ptr_to_d0 = 0
    saw_null_branch = 0
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

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_label = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_label = 1
    if (l ~ /^ESQDISP_TESTENTRYBITS0AND2_CORE:/ || l ~ /TESTENTRYBITS0AND2_CORE/) has_core = 1
    if (l ~ /MOVEM\.L D7\/A3,-\(A7\)/ || l ~ /MOVE\.L D7,-\(A7\)/ || l ~ /MOVE\.L A3,-\(A7\)/ || l ~ /MOVE\.L A5,-\(A7\)/) has_save = 1
    if (l ~ /MOVE\.L A3,D0/ || l ~ /MOVE\.L A5,D0/) saw_ptr_to_d0 = 1
    if (l ~ /^BEQ(\.[A-Z]+)? /) saw_null_branch = 1
    if ((l ~ /TST\.L A[0-7]/ || l ~ /CMP\.L #\$?0,A[0-7]/) && l ~ /BEQ/) has_null_guard = 1
    if (l ~ /BTST #0,40\(A3\)/ || l ~ /BTST #\$?0,\$?28\(A5\)/ || l ~ /ANDI?\.B #\$?1/ || l ~ /ANDI?\.L #\$?1/) has_btst0 = 1
    if (l ~ /BTST #2,40\(A3\)/ || l ~ /BTST #\$?2,\$?28\(A5\)/ || l ~ /ANDI?\.B #\$?4/ || l ~ /ANDI?\.L #\$?4/) has_btst2 = 1
    if (l ~ /MOVEQ #1,D0/ || l ~ /MOVEQ\.L #\$?1,D0/ || l ~ /MOVE\.L #\$?1,D0/) has_true = 1
    if (l ~ /MOVEQ #0,D0/ || l ~ /MOVEQ\.L #\$?0,D0/ || l ~ /CLR\.L D0/) has_false = 1
    if (l ~ /MOVEM\.L \(A7\)\+,D7\/A3/ || l ~ /MOVE\.L \(A7\)\+,A3/ || l ~ /MOVE\.L \(A7\)\+,D7/ || l ~ /MOVE\.L \(A7\)\+,A5/) has_restore = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    if (has_null_guard == 0 && saw_ptr_to_d0 == 1 && saw_null_branch == 1) has_null_guard = 1
    print "HAS_LABEL=" has_label
    print "HAS_CORE=" has_core
    print "HAS_SAVE=" has_save
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_BTST0=" has_btst0
    print "HAS_BTST2=" has_btst2
    print "HAS_TRUE=" has_true
    print "HAS_FALSE=" has_false
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
