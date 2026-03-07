BEGIN {
    has_entry=0
    has_loop_cmp=0
    has_alloc_call=0
    has_store_ptr=0
    has_reset_write=0
    has_reset_secondary=0
    has_rts=0
}

function trim(s, t) {
    t=s
    sub(/;.*/, "", t)
    sub(/^[ \t]+/, "", t)
    sub(/[ \t]+$/, "", t)
    return t
}

{
    line=trim($0)
    if (line=="") next
    gsub(/[ \t]+/, " ", line)
    u=toupper(line)
    n=u
    gsub(/[^A-Z0-9]/, "", n)

    if (u ~ /^ESQFUNC_ALLOCATELINETEXTBUFFERS:/ || u ~ /^ESQFUNC_ALLOCATELINETEXTBUFFER[A-Z0-9_]*:/) has_entry=1
    if (u ~ /#20([^0-9]|$)/ || u ~ /#\$14/ || n ~ /CMPWD0D7/) has_loop_cmp=1
    if (n ~ /ALLOCATEMEM/) has_alloc_call=1
    if (n ~ /MOVELD0A0/ || n ~ /MOVELD0A[0-7]/ || u ~ /MOVE\.L D0,\$0\(A0,D1\.L\)/ || u ~ /MOVE\.L D0,\(A0,D1\.L\)/) has_store_ptr=1
    if (n ~ /LADFUNCLINESLOTWRITEINDEX/) has_reset_write=1
    if (n ~ /LADFUNCLINESLOTSECONDARYINDEX/) has_reset_secondary=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LOOP_CMP="has_loop_cmp
    print "HAS_ALLOC_CALL="has_alloc_call
    print "HAS_STORE_PTR="has_store_ptr
    print "HAS_RESET_WRITE_IDX="has_reset_write
    print "HAS_RESET_SECONDARY_IDX="has_reset_secondary
    print "HAS_RTS="has_rts
}
