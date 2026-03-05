BEGIN {
    has_entry = 0
    has_exit_shape = 0
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

    if (l ~ /^UNLK A5$/ || l ~ /^RTS$/) has_exit_shape = 1
    if (l ~ /^CMP\.L __BASE\(A4\),A7$/ || l ~ /^BCS(\.[A-Z]+)? _XCOVF$/) has_exit_shape = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_EXIT_SHAPE=" has_exit_shape
}
