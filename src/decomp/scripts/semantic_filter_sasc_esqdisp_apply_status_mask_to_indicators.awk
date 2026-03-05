BEGIN {
    has_entry = 0
    has_save = 0
    has_cmp_minus_one = 0
    has_btst0 = 0
    has_btst1 = 0
    has_btst2 = 0
    has_btst4 = 0
    has_btst5 = 0
    has_btst8 = 0
    has_call_setslot = 0
    has_color2 = 0
    has_color3 = 0
    has_color4 = 0
    has_color7 = 0
    has_return = 0
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

    if (l ~ /^MOVE\.L D7,-\(A7\)$/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /MOVEQ(\.L)? #\$?FF,D0/ || l ~ /CMP\.L D0,D7/ || l ~ /^MOVE\.L D7,D0$/ || l ~ /^ADDQ\.L #\$?1,D0$/) has_cmp_minus_one = 1
    if (l ~ /BTST #\$?0,D7/) has_btst0 = 1
    if (l ~ /BTST #\$?1,D7/) has_btst1 = 1
    if (l ~ /BTST #\$?2,D7/) has_btst2 = 1
    if (l ~ /BTST #\$?4,D7/) has_btst4 = 1
    if (l ~ /BTST #\$?5,D7/) has_btst5 = 1
    if (l ~ /BTST #\$?8,D7/) has_btst8 = 1
    if (l ~ /SETSTATUSINDICATORCOLORSLOT/ || l ~ /SETSTATUSINDICATORCOLORS/) has_call_setslot = 1
    if (l ~ /PEA 2\.W/ || l ~ /PEA \(\$2\)\.W/ || l ~ /MOVEQ(\.L)? #\$?2,D[0-7]/) has_color2 = 1
    if (l ~ /PEA 3\.W/ || l ~ /PEA \(\$3\)\.W/ || l ~ /MOVEQ(\.L)? #\$?3,D[0-7]/) has_color3 = 1
    if (l ~ /PEA 4\.W/ || l ~ /PEA \(\$4\)\.W/ || l ~ /MOVEQ(\.L)? #\$?4,D[0-7]/) has_color4 = 1
    if (l ~ /PEA 7\.W/ || l ~ /PEA \(\$7\)\.W/ || l ~ /MOVEQ(\.L)? #\$?7,D[0-7]/) has_color7 = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_CMP_MINUS_ONE=" has_cmp_minus_one
    print "HAS_BTST0=" has_btst0
    print "HAS_BTST1=" has_btst1
    print "HAS_BTST2=" has_btst2
    print "HAS_BTST4=" has_btst4
    print "HAS_BTST5=" has_btst5
    print "HAS_BTST8=" has_btst8
    print "HAS_CALL_SETSLOT=" has_call_setslot
    print "HAS_COLOR2=" has_color2
    print "HAS_COLOR3=" has_color3
    print "HAS_COLOR4=" has_color4
    print "HAS_COLOR7=" has_color7
    print "HAS_RETURN=" has_return
}
