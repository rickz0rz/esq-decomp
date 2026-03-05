BEGIN {
    has_entry = 0
    has_stack_load = 0
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

    if (l ~ /4\(A7\)/ || l ~ /8\(A7\)/ || l ~ /\(4,SP\)/ || l ~ /\$4\(A7\)/ || l ~ /\$8\(A7\)/) has_stack_load = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_STACK_LOAD=" has_stack_load
}
