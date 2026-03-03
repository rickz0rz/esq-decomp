BEGIN {
    has_entry = 0
    has_link = 0
    has_loop_cmp = 0
    has_alloc_call = 0
    has_store_ptr = 0
    has_reset_write_idx = 0
    has_reset_secondary_idx = 0
    has_unlk = 0
    has_rts = 0
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
    uline = toupper(line)

    if (uline ~ /^ESQFUNC_ALLOCATELINETEXTBUFFERS:/) has_entry = 1
    if (uline ~ /^LINK\.W A5,#-4$/) has_link = 1
    if (uline ~ /^CMP\.W D0,D7$/) has_loop_cmp = 1
    if (uline ~ /ESQIFF_JMPTBL_MEMORY_ALLOCATEMEMORY/) has_alloc_call = 1
    if (uline ~ /^MOVE\.L D0,\(A0\)$/) has_store_ptr = 1
    if (uline ~ /^MOVE\.W D0,LADFUNC_LINESLOTWRITEINDEX$/) has_reset_write_idx = 1
    if (uline ~ /^MOVE\.W D0,LADFUNC_LINESLOTSECONDARYINDEX$/) has_reset_secondary_idx = 1
    if (uline ~ /^UNLK A5$/) has_unlk = 1
    if (uline ~ /^RTS$/) has_rts = 1
}

END {
    print "HAS_ENTRY=" has_entry
    print "HAS_LINK=" has_link
    print "HAS_LOOP_CMP=" has_loop_cmp
    print "HAS_ALLOC_CALL=" has_alloc_call
    print "HAS_STORE_PTR=" has_store_ptr
    print "HAS_RESET_WRITE_IDX=" has_reset_write_idx
    print "HAS_RESET_SECONDARY_IDX=" has_reset_secondary_idx
    print "HAS_UNLK=" has_unlk
    print "HAS_RTS=" has_rts
}
