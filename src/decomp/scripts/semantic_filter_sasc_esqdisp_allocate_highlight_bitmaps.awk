BEGIN {
    has_entry = 0
    has_link = 0
    has_initbitmap = 0
    has_loop_bound = 0
    has_alloc_call = 0
    has_store_plane = 0
    has_clear_size = 0
    has_bltclear = 0
    has_loop_inc = 0
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

    if (l ~ /LINK\.W A5,#-4/ || l ~ /^MOVEM\.L .*,-\(A7\)$/) has_link = 1
    if (l ~ /LVOINITBITMAP/) has_initbitmap = 1
    if (l ~ /CMP\.L .*D7/ || l ~ /CMP\.L #\$?3,D7/ || l ~ /CMP\.L D0,D7/) has_loop_bound = 1
    if (l ~ /GRAPHICS_ALLOCRASTER/ || l ~ /GRAPHICS_ALLOCRAS/) has_alloc_call = 1
    if (l ~ /MOVE\.L D0,8\(A3,D1\.L\)/ || l ~ /MOVE\.L D0,\$?8\(A[0-7],D[0-7]\.L\)/) has_store_plane = 1
    if (l ~ /MULU #\$?58,D1/ || l ~ /MULU #\$?58,D0/ || l ~ /MULS #\$?58/ || (l ~ /^MOVE\.L D1,D2$/ || l ~ /^MOVE\.L D[0-7],D2$/) || l ~ /^ASL\.L #\$?3,D2$/) has_clear_size = 1
    if (l ~ /LVOBLTCLEAR/) has_bltclear = 1
    if (l ~ /ADDQ\.L #1,D7/ || l ~ /ADDQ\.L #\$1,D7/) has_loop_inc = 1
    if (l ~ /^RTS$/) has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_INITBITMAP=" has_initbitmap
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_STORE_PLANE=" has_store_plane
    print "HAS_CLEAR_SIZE=" has_clear_size
    print "HAS_BLTCLEAR=" has_bltclear
    print "HAS_LOOP_INC=" has_loop_inc
    print "HAS_RETURN=" has_return
}
