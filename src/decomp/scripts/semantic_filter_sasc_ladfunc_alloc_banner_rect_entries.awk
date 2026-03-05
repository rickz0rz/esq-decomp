BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_ptr_index = 0
    has_alloc_call = 0
    has_size_14 = 0
    has_line_116 = 0
    has_flags_10001 = 0
    has_store_result = 0
    has_return = 0
}

function trim(s, t) {
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

    if (u ~ /^LADFUNC_ALLOCBANNERRECTENTRIES:/ || u ~ /^LADFUNC_ALLOCBANNERRECTEN[A-Z0-9_]*:/) has_entry = 1

    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_loop_bound = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEME") > 0) has_alloc_call = 1
    if (u ~ /#14\./ || u ~ /#\$E\./ || u ~ /#14,/ || u ~ /#\$E,/) has_size_14 = 1
    if (u ~ /#116\./ || u ~ /#\$74\./ || u ~ /#116,/ || u ~ /#\$74,/) has_line_116 = 1
    if (u ~ /#\$10001/ || u ~ /#65537/ || u ~ /MEMF_PUBLIC\+MEMF_CLEAR/) has_flags_10001 = 1

    if (u ~ /^MOVE\.L D0,\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.L D0,\$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.L D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/) has_store_result = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_SIZE_14=" has_size_14
    print "HAS_LINE_116=" has_line_116
    print "HAS_FLAGS_10001=" has_flags_10001
    print "HAS_STORE_RESULT=" has_store_result
    print "HAS_RETURN=" has_return
}
