BEGIN {
    has_label = 0
    has_save = 0
    has_range = 0
    has_null = 0
    has_btst = 0
    has_bounds = 0
    has_truefalse = 0
    has_return_label = 0
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

    if (ENTRY_PREFIX != "" && index(l, ENTRY_PREFIX) == 1) has_label = 1
    if (ENTRY_ALT_PREFIX != "" && index(l, ENTRY_ALT_PREFIX) == 1) has_label = 1

    if (l ~ /MOVEM\.L D6-D7\/A3,-\(A7\)/ || l ~ /MOVEM\.L D6\/D7\/A3,-\(A7\)/ || l ~ /MOVEM\.L D6\/D7\/A5,-\(A7\)/ || l ~ /MOVEM\.L D7\/A5,-\(A7\)/ || l ~ /MOVE\.L A5,-\(A7\)/) has_save = 1
    if ((l ~ /TST\.W D7/ || l ~ /CMP\.W .*D7/) || l ~ /#49/ || l ~ /#\$?31/) has_range = 1
    if ((l ~ /MOVE\.L A3,D0/ || l ~ /MOVE\.L A5,D0/ || l ~ /TST\.L A[0-7]/) && l ~ /BEQ/) has_null = 1
    if (l ~ /BTST #4,7\(A3,D7\.W\)/ || l ~ /BTST #\$?4,\$?7\(A[0-7],D[0-7]\.W\)/ || l ~ /BTST #\$?4,\$?7\(A[0-7],D[0-7]\.L\)/ || l ~ /ANDI?\.B #\$?10/) has_btst = 1
    if ((l ~ /CMPI\.B #\$?5,/ || l ~ /CMP\.B #\$?5,/) && (l ~ /CMPI\.B #\$?A,/ || l ~ /CMP\.B #\$?A,/ || l ~ /#10/)) has_bounds = 1
    if (l ~ /MOVEQ #0,D0/ || l ~ /MOVEQ\.L #\$?0,D0/ || l ~ /MOVEQ #1,D0/ || l ~ /MOVEQ\.L #\$?1,D0/ || l ~ /MOVEQ #0,D6/ || l ~ /MOVEQ\.L #\$?0,D6/ || l ~ /MOVEQ #1,D6/ || l ~ /MOVEQ\.L #\$?1,D6/) has_truefalse = 1
    if (l ~ /^ESQDISP_TESTENTRYGRIDELIGIBILITY_RETURN:/ || l ~ /TESTENTRYGRIDELIGIBILITY_RETURN/ || l ~ /___ESQDISP_TESTENTRYGRIDELIGIBILITY__/) has_return_label = 1
    if (l ~ /MOVEM\.L \(A7\)\+,D6-D7\/A3/ || l ~ /MOVEM\.L \(A7\)\+,D6\/D7\/A3/ || l ~ /MOVEM\.L \(A7\)\+,D6\/D7\/A5/ || l ~ /MOVEM\.L \(A7\)\+,D7\/A5/ || l ~ /MOVE\.L \(A7\)\+,A5/) has_restore = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_LABEL=" has_label
    print "HAS_SAVE=" has_save
    print "HAS_RANGE=" has_range
    print "HAS_NULL=" has_null
    print "HAS_BTST=" has_btst
    print "HAS_BOUNDS=" has_bounds
    print "HAS_TRUEFALSE=" has_truefalse
    print "HAS_RETURN_LABEL=" has_return_label
    print "HAS_RESTORE=" has_restore
    print "HAS_RTS=" has_rts
}
