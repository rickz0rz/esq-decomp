BEGIN {
    has_entry = 0
    has_loop_bound = 0
    has_ptr_index = 0
    has_entry_null_guards = 0
    has_strlen_scan = 0
    has_attr_free_call = 0
    has_replace_owned_call = 0
    has_store_textptr = 0
    has_clear_call = 0
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

    if (u ~ /^LADFUNC_RESETENTRYTEXTBUFFERS:/ || u ~ /^LADFUNC_RESETENTRYTEXTBUFF[A-Z0-9_]*:/) has_entry = 1
    if (u ~ /^MOVEQ(\.L)? #46,D[0-7]$/ || u ~ /^MOVEQ(\.L)? #\$2E,D[0-7]$/ || u ~ /^CMP\.[LW] D[0-7],D[0-7]$/ || u ~ /^BGE\.[SWB] /) has_loop_bound = 1
    if (index(u, "LADFUNC_ENTRYPTRTABLE") > 0 || u ~ /^ASL\.L #2,D[0-7]$/ || u ~ /^ASL\.L #\$2,D[0-7]$/) has_ptr_index = 1

    if (u ~ /^TST\.L \(A[0-7]\)$/ || u ~ /^TST\.L [0-9]+\([A0-7]\)$/ || u ~ /^BEQ\.[SWB] /) has_entry_null_guards = 1
    if (u ~ /^TST\.B \(A[0-7]\)\+?$/ || u ~ /^ADDQ\.L #1,A[0-7]$/ || u ~ /^BNE\.[SWB] / || u ~ /^SUBA?\.L [0-9]+\([A0-7]\),A[0-7]$/ || u ~ /^SUB\.L [0-9]+\([A0-7]\),D[0-7]$/) has_strlen_scan = 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0 || index(u, "GLOBAL_STR_LADFUNC_C_4") > 0 || u ~ /212/ || u ~ /\$D4/) has_attr_free_call = 1
    if (index(u, "ESQPARS_REPLACEOWNEDSTRING") > 0) has_replace_owned_call = 1

    if (u ~ /^MOVE\.L D0,6\(A[0-7]\)$/ || u ~ /^MOVE\.L D0,\$6\(A[0-7]\)$/) has_store_textptr = 1
    if (index(u, "LADFUNC_CLEARBANNERRECTENTRIES") > 0) has_clear_call = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LOOP_BOUND=" has_loop_bound
    print "HAS_PTR_INDEX=" has_ptr_index
    print "HAS_ENTRY_NULL_GUARDS=" has_entry_null_guards
    print "HAS_STRLEN_SCAN=" has_strlen_scan
    print "HAS_ATTR_FREE_CALL=" has_attr_free_call
    print "HAS_REPLACE_OWNED_CALL=" has_replace_owned_call
    print "HAS_STORE_TEXTPTR=" has_store_textptr
    print "HAS_CLEAR_CALL=" has_clear_call
    print "HAS_RETURN=" has_return
}
