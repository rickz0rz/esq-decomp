BEGIN {
    has_scan = 0
    has_alloc_call = 0
    has_alloc_size_34 = 0
    has_zero_init = 0
    has_open_mode_call = 0
    has_null_return = 0
    has_rts = 0
}

function trim(s,    t) {
    t = s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line = trim($0)
    if (line == "") next
    gsub(/[ \t]+/, " ", line)
    u = toupper(line)

    if (u ~ /GLOBAL_PREALLOCHANDLENODE0/ || u ~ /STRUCT_PREALLOCHANDLENODE__OPENFLAGS/ || u ~ /STRUCT_PREALLOCHANDLENODE__NEXT/) has_scan = 1
    if (u ~ /JSR .*ALLOC_ALLOCFROMFREELIST/) has_alloc_call = 1
    if (u ~ /#34/ || u ~ /#\$22/) has_alloc_size_34 = 1
    if (u ~ /MOVE\.B D[0-7],\(A[0-7]\)\+/ || u ~ /^CLR\.B/ || u ~ /^CLR\.L/ || u ~ /MOVE\.B #0,/) has_zero_init = 1
    if (u ~ /JSR .*HANDLE_OPENFROMMODESTRING/) has_open_mode_call = 1
    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^MOVE\.L #0,D0$/) has_null_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SCAN=" has_scan
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_SIZE_34=" has_alloc_size_34
    print "HAS_ZERO_INIT=" has_zero_init
    print "HAS_OPEN_MODE_CALL=" has_open_mode_call
    print "HAS_NULL_RETURN=" has_null_return
    print "HAS_RTS=" has_rts
}
