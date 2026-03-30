BEGIN {
    has_entry = 0
    has_text_limit = 0
    alloc_calls = 0
    free_calls = 0
    copy_pad_calls = 0
    mem_move_calls = 0
    has_row_mul = 0
    has_emit_mode = 0
    has_emit_chars = 0
    has_align24 = 0
    has_align25 = 0
    has_align26 = 0
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

    if (u ~ /^LADFUNC_REPACKENTRYTEXTANDATTRBUFFERS:/ || u ~ /^LADFUNC_REPACKENTRYTEXTANDATTRBU[A-Z0-9_]*:/) has_entry = 1
    if (index(u, "ED_TEXTLIMIT") > 0) has_text_limit = 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) alloc_calls++
    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) free_calls++
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0) copy_pad_calls++
    if (index(u, "GROUP_AW_JMPTBL_MEM_MOVE") > 0 || index(u, "GROUP_AW_JMPTBL_MEM_MOV") > 0) mem_move_calls++
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_MULU") > 0) has_row_mul = 1

    if (u ~ /#24/ || index(u, "#$18") > 0) has_align24 = 1
    if (u ~ /#25/ || index(u, "#$19") > 0) has_align25 = 1
    if (u ~ /#26/ || index(u, "#$1A") > 0) has_align26 = 1

    if (u ~ /^MOVE\.B D[0-7],(\$0|0)\(A[0-7],D[0-7]\.L\)$/) has_emit_mode = 1
    if (u ~ /^MOVE\.B [^,]*\(A[0-7],D[0-7]\.L\),(\$0|0)\(A[0-7],D[0-7]\.L\)$/) has_emit_chars = 1

    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXT_LIMIT=" has_text_limit
    print "ALLOC_CALLS=" alloc_calls
    print "FREE_CALLS=" free_calls
    print "COPY_PAD_CALLS=" copy_pad_calls
    print "MEM_MOVE_CALLS=" mem_move_calls
    print "HAS_ROW_MUL=" has_row_mul
    print "HAS_EMIT_MODE=" has_emit_mode
    print "HAS_EMIT_CHARS=" has_emit_chars
    print "HAS_ALIGN24=" has_align24
    print "HAS_ALIGN25=" has_align25
    print "HAS_ALIGN26=" has_align26
    print "HAS_RETURN=" has_return
}
