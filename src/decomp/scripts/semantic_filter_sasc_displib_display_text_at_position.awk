BEGIN {
    has_entry = 0
    has_null_guard = 0
    has_move = 0
    has_strlen = 0
    has_text = 0
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

    if (l ~ /^MOVE\.L A2,D0$/ || l ~ /^TST\.L A2$/ || l ~ /^BEQ(\.[A-Z]+)?/) has_null_guard = 1
    if (l ~ /LVOMOVE/ || l ~ /^JSR _LVOMOVE/) has_move = 1
    if (l ~ /^TST\.B \(A0\)\+/ || l ~ /^SUBA\.L A2,A0$/ || l ~ /TST\.B \$0\(A[0-7],D[0-7]\.L\)/) has_strlen = 1
    if (l ~ /LVOTEXT/ || l ~ /^JSR _LVOTEXT/) has_text = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_MOVE=" has_move
    print "HAS_STRLEN=" has_strlen
    print "HAS_TEXT=" has_text
}
