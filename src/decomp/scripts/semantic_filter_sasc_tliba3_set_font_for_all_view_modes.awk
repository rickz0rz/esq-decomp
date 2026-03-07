BEGIN {
    has_entry=0
    has_loop_10=0
    has_mulu=0
    has_vm_table=0
    has_offset10=0
    has_setfont=0
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

    if (u ~ /^TLIBA3_SETFONTFORALLVIEWMODES:/ || u ~ /^TLIBA3_SETFONTFORALLVIEWMODE[A-Z0-9_]*:/) has_entry=1
    if (u ~ /#9([^0-9]|$)/ || u ~ /#\$9/ || u ~ /#10([^0-9]|$)/ || u ~ /#\$A/) has_loop_10=1
    if (n ~ /MATHMULU32/) has_mulu=1
    if (n ~ /TLIBA3VMARRAYRUNTIMETABLE/) has_vm_table=1
    if (u ~ /10\(A0\)/ || u ~ /\$A\(A[0-7]\)/ || u ~ /#10([^0-9]|$)/ || u ~ /\$A/) has_offset10=1
    if (n ~ /LVOSETFONT/) has_setfont=1
    if (n ~ /GLOBALREFGRAPHICSLIBRARY/) has_graphics_base=1
    if (u == "RTS") has_rts=1
}

END {
    print "HAS_ENTRY="has_entry
    print "HAS_LOOP_10="has_loop_10
    print "HAS_MULU_CALL="has_mulu
    print "HAS_VM_TABLE="has_vm_table
    print "HAS_OFFSET_10="has_offset10
    print "HAS_SETFONT_CALL="has_setfont
    print "HAS_GRAPHICS_BASE="has_graphics_base
    print "HAS_RTS="has_rts
}
