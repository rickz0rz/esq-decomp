BEGIN {
    has_null_arg_guard = 0
    has_alloc_size = 0
    has_alloc_flags = 0
    has_alloc_call = 0
    has_alloc_null_guard = 0
    has_type_store = 0
    has_pri_clear = 0
    has_replyport_store = 0
    has_zero_return = 0
    has_ptr_return = 0
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

    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^TST\.L A[0-7]$/ || u ~ /^TST\.L D[0-7]$/) has_null_arg_guard = 1
    if (u ~ /^MOVEQ #48,D0$/ || u ~ /^MOVE\.L #48,D0$/) has_alloc_size = 1
    if (u ~ /#\$?10001/ || u ~ /#65537/ || u ~ /MEMF_PUBLIC\+MEMF_CLEAR/) has_alloc_flags = 1
    if (u ~ /JSR .*LVOALLOCMEM/) has_alloc_call = 1
    if (u ~ /^MOVEA?\.L D0,A[0-7]$/ || u ~ /^TST\.L D0$/) has_alloc_null_guard = 1

    if (u ~ /^MOVE\.B #5,[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.B #5,\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.B #\(NT_MESSAGE\),/) has_type_store = 1
    if (u ~ /^CLR\.B [0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^CLR\.B \([0-9]+,A[0-7]\)$/ || u ~ /^CLR\.B \(STRUCT_IOSTDREQ__IO_MESSAGE\+STRUCT__MESSAGE__MN_NODE\+STRUCT_NODE__LN_PRI\)\(A[0-7]\)$/) has_pri_clear = 1
    if (u ~ /^MOVE\.L A[0-7],[0-9]+\((A[0-7]|D[0-7])\)$/ || u ~ /^MOVE\.L A[0-7],\([0-9]+,A[0-7]\)$/ || u ~ /^MOVE\.L A[0-7],\(STRUCT_IOSTDREQ__IO_MESSAGE\+STRUCT__MESSAGE__MN_REPLYPORT\)\(A[0-7]\)$/) has_replyport_store = 1

    if (u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/ || u ~ /^MOVE\.L A1,D0$/) has_zero_return = 1
    if (u ~ /^MOVE\.L A[0-7],D0$/ || u ~ /^MOVE\.L D[0-7],D0$/) has_ptr_return = 1
    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_NULL_ARG_GUARD=" has_null_arg_guard
    print "HAS_ALLOC_SIZE=" has_alloc_size
    print "HAS_ALLOC_FLAGS=" has_alloc_flags
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_ALLOC_NULL_GUARD=" has_alloc_null_guard
    print "HAS_TYPE_STORE=" has_type_store
    print "HAS_PRI_CLEAR=" has_pri_clear
    print "HAS_REPLYPORT_STORE=" has_replyport_store
    print "HAS_ZERO_RETURN=" has_zero_return
    print "HAS_PTR_RETURN=" has_ptr_return
    print "HAS_RTS=" has_rts
}
