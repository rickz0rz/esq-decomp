BEGIN {
    has_entry = 0
    has_save = 0
    has_loop_bound = 0
    has_add4 = 0
    has_store = 0
    has_inc = 0
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

    if (l ~ /^MOVEM\.L D7\/A3,-\(A7\)$/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /CMP\.L .*D7/ || l ~ /CMP\.L #\$?4,D7/ || l ~ /CMP\.L D0,D7/) has_loop_bound = 1
    if (l ~ /ADDQ\.L #4,D0/ || l ~ /MOVEQ\.L #\$?4,D0/) has_add4 = 1
    if (l ~ /MOVE\.B D0,55\(A3,D7\.L\)/ || l ~ /MOVE\.B D0,\$?37\(A[0-7],D[0-7]\.L\)/) has_store = 1
    if (l ~ /ADDQ\.L #1,D7/ || l ~ /ADDQ\.L #\$1,D7/) has_inc = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_ADD4=" has_add4
    print "HAS_STORE=" has_store
    print "HAS_INC=" has_inc
    print "HAS_RETURN=" has_return
}
