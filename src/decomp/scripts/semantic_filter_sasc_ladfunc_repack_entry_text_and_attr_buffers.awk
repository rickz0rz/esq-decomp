BEGIN {
    has_entry = 0
    has_text_limit = 0
    has_alloc = 0
    has_copy_pad = 0
    has_mem_move = 0
    has_align24 = 0
    has_align25 = 0
    has_align26 = 0
    has_mul = 0
    has_free = 0
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

    if (index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_ALLOCATE") > 0) has_alloc = 1
    if (index(u, "GROUP_AW_JMPTBL_STRING_COPYPADNUL") > 0 || index(u, "GROUP_AW_JMPTBL_STRING_COPYPAD") > 0) has_copy_pad = 1
    if (index(u, "GROUP_AW_JMPTBL_MEM_MOVE") > 0 || index(u, "GROUP_AW_JMPTBL_MEM_MOV") > 0) has_mem_move = 1
    if (index(u, "NEWGRID_JMPTBL_MATH_MULU32") > 0 || index(u, "NEWGRID_JMPTBL_MATH_MULU") > 0) has_mul = 1

    if (u ~ /#24/ || index(u, "#$18") > 0) has_align24 = 1
    if (u ~ /#25/ || index(u, "#$19") > 0) has_align25 = 1
    if (u ~ /#26/ || index(u, "#$1A") > 0) has_align26 = 1

    if (index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATEMEMORY") > 0 || index(u, "NEWGRID_JMPTBL_MEMORY_DEALLOCATE") > 0) has_free = 1
    if (u == "RTS") has_return = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_TEXT_LIMIT=" has_text_limit
    print "HAS_ALLOC=" has_alloc
    print "HAS_COPY_PAD=" has_copy_pad
    print "HAS_MEM_MOVE=" has_mem_move
    print "HAS_ALIGN24=" has_align24
    print "HAS_ALIGN25=" has_align25
    print "HAS_ALIGN26=" has_align26
    print "HAS_MUL=" has_mul
    print "HAS_FREE=" has_free
    print "HAS_RETURN=" has_return
}
