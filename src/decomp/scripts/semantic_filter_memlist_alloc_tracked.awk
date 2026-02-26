BEGIN {
    has_size_add = 0
    has_allocmem_call = 0
    has_alloc_fail_return = 0
    has_total_store = 0
    has_prev_from_tail = 0
    has_next_zero = 0
    has_head_empty_check = 0
    has_set_head = 0
    has_tail_nonzero_check = 0
    has_link_prev_tail_next = 0
    has_set_tail = 0
    has_first_empty_check = 0
    has_set_first = 0
    has_return_payload_ptr = 0
    has_rts = 0
    saw_tail_load_to_ax = 0
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

    if (u ~ /^ADD\.L #[0-9]+,D[0-7]$/ || u ~ /^ADDQ\.L #[0-9]+,D[0-7]$/ || u ~ /^LEA [0-9]+\(A[0-7]\),A[0-7]$/ || u ~ /^ADD\.L D[0-7],D[0-7]$/ || u ~ /^ADD\.L \(8,(A7|SP)\),D[0-7]$/) has_size_add = 1

    if (u ~ /JSR .*LVOALLOCMEM/ || u ~ /JSR .*EXEC_ALLOC_MEM/ || u ~ /^JSR \(A[0-7]\)$/) has_allocmem_call = 1

    if ((u ~ /^MOVEQ #0,D0$/ || u ~ /^CLR\.L D0$/) && has_allocmem_call) has_alloc_fail_return = 1

    if (u ~ /^MOVE\.L D[0-7],8\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\(8,A[0-7]\)$/) has_total_store = 1

    if (u ~ /_?GLOBAL_MEMLISTTAIL/ && (u ~ /^MOVEA?\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?,A[0-7]$/ || u ~ /^MOVE\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?,D[0-7]$/ || u ~ /^MOVE\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?,\(4,A[0-7]\)$/)) has_prev_from_tail = 1
    if (u ~ /^MOVEA?\.L 4\(A[0-7]\),A[0-7]$/ || u ~ /^MOVE\.L 4\(A[0-7]\),D[0-7]$/) has_prev_from_tail = 1

    if (u ~ /^MOVE\.L A[0-7],\(A[0-7]\)$/ || u ~ /^CLR\.L \(A[0-7]\)$/ || u ~ /^MOVE\.L #0,\(A[0-7]\)$/) has_next_zero = 1

    if (u ~ /_?GLOBAL_MEMLISTHEAD/ && (u ~ /^TST\.L _?GLOBAL_MEMLISTHEAD(\(A4\))?$/ || u ~ /^MOVEA?\.L _?GLOBAL_MEMLISTHEAD(\(A4\))?,A[0-7]$/)) has_head_empty_check = 1
    if (u ~ /^TST\.L \(A[0-7]\)$/) has_head_empty_check = 1

    if (u ~ /_?GLOBAL_MEMLISTHEAD/ && (u ~ /^MOVE\.L A[0-7],_?GLOBAL_MEMLISTHEAD(\(A4\))?$/ || u ~ /^MOVE\.L D[0-7],_?GLOBAL_MEMLISTHEAD(\(A4\))?$/)) has_set_head = 1
    if (u ~ /^MOVE\.L A[0-7],\(A[0-7]\)$/) has_set_head = 1

    if (u ~ /_?GLOBAL_MEMLISTTAIL/ && (u ~ /^TST\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?$/ || u ~ /^MOVEA?\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?,A[0-7]$/)) has_tail_nonzero_check = 1
    if (u ~ /^TST\.L 4\(A[0-7]\)$/) has_tail_nonzero_check = 1

    if (u ~ /^MOVEA?\.L _?GLOBAL_MEMLISTTAIL(\(A4\))?,A[0-7]$/ || u ~ /^MOVEA?\.L 4\(A[0-7]\),A[0-7]$/) saw_tail_load_to_ax = 1
    if (saw_tail_load_to_ax && (u ~ /^MOVE\.L A[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/)) has_link_prev_tail_next = 1

    if (u ~ /_?GLOBAL_MEMLISTTAIL/ && (u ~ /^MOVE\.L A[0-7],_?GLOBAL_MEMLISTTAIL(\(A4\))?$/ || u ~ /^MOVE\.L D[0-7],_?GLOBAL_MEMLISTTAIL(\(A4\))?$/)) has_set_tail = 1
    if (u ~ /^MOVE\.L A[0-7],4\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],4\(A[0-7]\)$/) has_set_tail = 1

    if (u ~ /_?GLOBAL_MEMLISTFIRSTALLOCNODE/ && (u ~ /^TST\.L _?GLOBAL_MEMLISTFIRSTALLOCNODE(\(A4\))?$/ || u ~ /^MOVEA?\.L _?GLOBAL_MEMLISTFIRSTALLOCNODE(\(A4\))?,A[0-7]$/)) has_first_empty_check = 1

    if (u ~ /_?GLOBAL_MEMLISTFIRSTALLOCNODE/ && (u ~ /^MOVE\.L A[0-7],_?GLOBAL_MEMLISTFIRSTALLOCNODE(\(A4\))?$/ || u ~ /^MOVE\.L D[0-7],_?GLOBAL_MEMLISTFIRSTALLOCNODE(\(A4\))?$/)) has_set_first = 1

    if (u ~ /^LEA 12\(A[0-7]\),A[0-7]$/ || u ~ /^ADD\.L #12,D0$/ || u ~ /^ADDQ\.L #8,D0$/ || u ~ /^ADDQ\.L #4,D0$/ || u ~ /^ADD\.L A[0-7],D0$/ || u ~ /^MOVE\.L A[0-7],D0$/) has_return_payload_ptr = 1

    if (u == "RTS") has_rts = 1
}

END {
    print "HAS_SIZE_ADD=" has_size_add
    print "HAS_ALLOCMEM_CALL=" has_allocmem_call
    print "HAS_ALLOC_FAIL_RETURN=" has_alloc_fail_return
    print "HAS_TOTAL_STORE=" has_total_store
    print "HAS_PREV_FROM_TAIL=" has_prev_from_tail
    print "HAS_NEXT_ZERO=" has_next_zero
    print "HAS_HEAD_EMPTY_CHECK=" has_head_empty_check
    print "HAS_SET_HEAD=" has_set_head
    print "HAS_TAIL_NONZERO_CHECK=" has_tail_nonzero_check
    print "HAS_LINK_PREV_TAIL_NEXT=" has_link_prev_tail_next
    print "HAS_SET_TAIL=" has_set_tail
    print "HAS_FIRST_EMPTY_CHECK=" has_first_empty_check
    print "HAS_SET_FIRST=" has_set_first
    print "HAS_RETURN_PAYLOAD_PTR=" has_return_payload_ptr
    print "HAS_RTS=" has_rts
}
