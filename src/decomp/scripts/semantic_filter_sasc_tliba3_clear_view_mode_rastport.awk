BEGIN {
    has_entry=0
    has_mulu=0
    has_const_154=0
    has_vm_table=0
    has_offset_10=0
    has_setrast=0
    has_graphics_base=0
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

    if (u ~ /^TLIBA3_CLEARVIEWMODERASTPORT:/ || u ~ /^TLIBA3_CLEARVIEWMODERASTPOR[A-Z0-9_]*:/) has_entry=1
    if (n ~ /MULU32/) has_mulu=1
    if (u ~ /#77/ || u ~ /#\$4D/ || u ~ /#154/ || u ~ /#\$9A/ || u ~ /\(\$9A\)/) has_const_154=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_vm_table=1
    if (u ~ /10\(A0\)/ || u ~ /\$A\(A[0-7]\)/ || u ~ /#10([^0-9]|$)/ || u ~ /\$A/) has_offset_10=1
    if (n ~ /SETRAST|LVOSETRAST/) has_setrast=1
    if (n ~ /GLOBALREFGRAPHICSLIBRARY/) has_graphics_base=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_MULU_CALL="has_mulu
    print "HAS_CONST_154="has_const_154
    print "HAS_VM_TABLE="has_vm_table
    print "HAS_OFFSET_10="has_offset_10
    print "HAS_SET_RAST_CALL="has_setrast
    print "HAS_GRAPHICS_BASE="has_graphics_base
    print "HAS_RTS="has_rts
}
