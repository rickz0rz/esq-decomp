BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_ptr_index = 0
    has_null_ptr_guard = 0
    has_strlen_scan = 0
    has_replace_owned_call = 0
    has_attr_free_call = 0
    has_entry_free_call = 0
    has_clear_slot = 0
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

    if (u ~ /^LADFUNC_FREEBANNERRECTENTRIES:/ || u ~ /^LADFUNC_FREEBANNERRECTENTR[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_loop_bound = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1

    if (u ~ /^TST\.L \(A[0-7]\)$/ || u ~ /^BEQ\.[SWB] /) has_null_ptr_guard = 1
    if (u ~ /^TST\.B \(A[0-7]\)\+?$/ || u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^BNE\.[SWB] / || u ~ /^SUBA?\.L [0-9]+\([A0-7]\),A[0-7]$/ || u ~ /^SUB\.L [0-9]+\([A0-7]\),D[0-7]$/) has_strlen_scan = 1

    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_owned_call = 1
    if (index(u, "GLOBAL_STR_LADFUNC_C_2") > 0 || (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 && u ~ /147/)) has_attr_free_call = 1
    if (index(u, "GLOBAL_STR_LADFUNC_C_3") > 0 || (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 && u ~ /150/)) has_entry_free_call = 1

    if (u ~ /^CLR\.L \(A[0-7]\)$/ || u ~ /^CLR\.L \$0\(A[0-7],D[0-7]\.L\)$/ || u ~ /^MOVE\.L D[0-7],\(A[0-7]\)$/ || u ~ /^MOVE\.L D[0-7],\$0\(A[0-7],D[0-7]\.L\)$/) has_clear_slot = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_NULL_PTR_GUARD=" has_null_ptr_guard
    print "HAS_STRLEN_SCAN=" has_strlen_scan
    print "HAS_REPLACE_OWNED_CALL=" has_replace_owned_call
    print "HAS_ATTR_FREE_CALL=" has_attr_free_call
    print "HAS_ENTRY_FREE_CALL=" has_entry_free_call
    print "HAS_CLEAR_SLOT=" has_clear_slot
    print "HAS_RETURN=" has_return
}
