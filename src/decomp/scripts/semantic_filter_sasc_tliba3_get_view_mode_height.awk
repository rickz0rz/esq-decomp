BEGIN {
    has_entry=0
    has_mulu=0
    has_const_154=0
    has_vm_table=0
    has_offset_4=0
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

    if (u ~ /^TLIBA3_GETVIEWMODEHEIGHT:/ || u ~ /^TLIBA3_GETVIEWMODEHEIG[A-Z0-9_]*:/) has_entry=1
    if (n ~ /MULU32/) has_mulu=1
    if (u ~ /#77/ || u ~ /#\$4D/ || u ~ /#154/ || u ~ /#\$9A/ || u ~ /\(\$9A\)/) has_const_154=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_vm_table=1
    if (u ~ /4\(A0\)/ || u ~ /\$4\(A[0-7]\)/ || u ~ /MOVE\.W \$4\(A5\),D0/ || u ~ /MOVE\.W \$4\(A0\),D0/) has_offset_4=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MULU_CALL="has_mulu
    print "HAS_CONST_154="has_const_154
    print "HAS_VM_TABLE="has_vm_table
    print "HAS_OFFSET_4="has_offset_4
    print "HAS_RTS="has_rts
}
