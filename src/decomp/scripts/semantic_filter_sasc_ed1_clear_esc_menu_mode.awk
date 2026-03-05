BEGIN {
    has_entry = 0
    has_clr = 0
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
    if (l ~ /^CLR\.B ED_MENUSTATEID(\(A[0-7]\))?$/ || l ~ /^MOVE\.B #\$?0,ED_MENUSTATEID(\(A[0-7]\))?$/) has_clr = 1
    if (l ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_CLR=" has_clr
    print "HAS_RTS=" has_rts
}
