BEGIN {
    has_entry = 0
    has_save = 0
    has_null_guard = 0
    has_store_b40 = 0
    has_store_w46 = 0
    has_store_b41 = 0
    has_store_b42 = 0
    has_copy_call = 0
    has_clear_b45 = 0
    has_restore_return = 0
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

    if (l ~ /^MOVEM\.L D4-D7\/A2-A3,-\(A7\)$/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_save = 1
    if (l ~ /MOVE\.L A3,D0/ || l ~ /TST\.L D0/ || l ~ /BEQ\./) has_null_guard = 1
    if (l ~ /(MOVE\.B .*40\(A3\)|MOVE\.B .*\$28\(A[35]\))/) has_store_b40 = 1
    if (l ~ /(MOVE\.W .*46\(A3\)|MOVE\.W .*\$2E\(A[35]\))/) has_store_w46 = 1
    if (l ~ /(MOVE\.B .*41\(A3\)|MOVE\.B .*\$29\(A[35]\))/) has_store_b41 = 1
    if (l ~ /(MOVE\.B .*42\(A3\)|MOVE\.B .*\$2A\(A[35]\))/) has_store_b42 = 1
    if (l ~ /STRING_COPYPADNUL/ || l ~ /STRING_COPYPAD/) has_copy_call = 1
    if (l ~ /CLR\.B 45\(A3\)/ || l ~ /CLR\.B \(A0\)/ || l ~ /CLR\.B \$2D\(A[35]\)/) has_clear_b45 = 1
    if (l ~ /^MOVEM\.L \(A7\)\+,D4-D7\/A2-A3$/ || l ~ /^RTS$/) has_restore_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_SAVE=" has_save
    print "HAS_NULL_GUARD=" has_null_guard
    print "HAS_STORE_B40=" has_store_b40
    print "HAS_STORE_W46=" has_store_w46
    print "HAS_STORE_B41=" has_store_b41
    print "HAS_STORE_B42=" has_store_b42
    print "HAS_COPY_CALL=" has_copy_call
    print "HAS_CLEAR_B45=" has_clear_b45
    print "HAS_RESTORE_RETURN=" has_restore_return
}
